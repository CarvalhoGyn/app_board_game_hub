
// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const BGG_BASE_URL = 'https://boardgamegeek.com/boardgame'

Deno.serve(async (req) => {
  try {
    // 1. Initialize Supabase Client
    // Uses default env vars provided by Supabase Edge Runtime
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    const supabase = createClient(supabaseUrl, supabaseKey)

    // 2. Fetch Batch of Unenriched Games
    // Limit to 5 to avoid timeouts and be polite to BGG
    const { data: games, error: fetchError } = await supabase
      .from('games')
      .select('id, bgg_id, name')
      .is('is_enriched', false)
      .not('bgg_id', 'is', null)
      .limit(5)

    if (fetchError) throw fetchError
    if (!games || games.length === 0) {
      return new Response(JSON.stringify({ message: 'No games to enrich.' }), {
        headers: { 'Content-Type': 'application/json' },
      })
    }

    const results = []

    // 3. Process Each Game
    for (const game of games) {
      try {
        console.log(`Enriching ${game.name} (BGG: ${game.bgg_id})...`)
        const details = await fetchGameDetails(game.bgg_id)

        if (details) {
          const { error: updateError } = await supabase
            .from('games')
            .update({
              ...details,
              is_enriched: true,
              updated_at: new Date().toISOString(),
            })
            .eq('id', game.id)

          if (updateError) {
            console.error(`Failed to update DB for ${game.name}:`, updateError)
            results.push({ id: game.id, status: 'error', reason: 'db_update_failed' })
          } else {
            results.push({ id: game.id, status: 'success', name: game.name })
          }
        } else {
          // If scraping failed (e.g. 404 or captcha), maybe mark is_enriched=true anyway to skip next time?
          // Or keep false to retry? Letting it retry forever is bad. 
          // For now, we leave is_enriched=false, but in prod we might want an error flag.
          console.error(`Failed to scrape details for ${game.name}`)
          results.push({ id: game.id, status: 'error', reason: 'scrape_failed' })
        }

        // 4. Rate Limiting (Politeness)
        await new Promise((resolve) => setTimeout(resolve, 1500))

      } catch (err) {
        console.error(`Error processing ${game.name}:`, err)
        results.push({ id: game.id, status: 'error', reason: err.message })
      }
    }

    return new Response(JSON.stringify({ 
      message: `Processed ${games.length} games.`,
      results 
    }), {
      headers: { 'Content-Type': 'application/json' },
    })

  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { 'Content-Type': 'application/json' },
    })
  }
})

// --- Helper Functions (Ported from Dart) ---

async function fetchGameDetails(bggId: number) {
  try {
    const res = await fetch(`${BGG_BASE_URL}/${bggId}`, {
      headers: {
        'User-Agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        'Accept': 'text/html',
      }
    })

    if (!res.ok) return null
    const html = await res.text()

    // Extract Description (Meta tag)
    const descMatch = html.match(/<meta property="og:description" content="([^"]+)"/)
    let description = descMatch ? decode(descMatch[1]) : ''

    // Extract Image (Meta tag)
    const imgMatch = html.match(/<meta property="og:image" content="([^"]+)"/)
    const imageUrl = imgMatch ? imgMatch[1] : null

    // Extract Stats (Regex fallback)
    const tryParseStat = (key: string) => {
      // Look for: "minplayers":"1" or "minplayers": 1
      const regex = new RegExp(`"${key}"\\s*:\\s*"?(\\d+)"?`, 'i')
      const m = html.match(regex)
      return m ? parseInt(m[1]) : null
    }

    const minPlayers = tryParseStat('minplayers')
    const maxPlayers = tryParseStat('maxplayers')
    const minPlaytime = tryParseStat('minplaytime')
    const maxPlaytime = tryParseStat('maxplaytime')
    const minAge = tryParseStat('minage')
    const yearPublished = tryParseStat('yearpublished')

    // Extract JSON Data (GEEK.geekitemPreload) for standard arrays
    let categories: string | null = null
    let mechanics: string | null = null
    let type: string | null = null
    let families: string | null = null
    let fullDescription = description

    try {
      const jsonStart = html.indexOf('GEEK.geekitemPreload = ')
      if (jsonStart !== -1) {
        let jsonEnd = html.indexOf('GEEK.geekitemSettings =', jsonStart)
        if (jsonEnd === -1) jsonEnd = html.indexOf('</script>', jsonStart)
        
        if (jsonEnd !== -1) {
          const lastSemi = html.lastIndexOf(';', jsonEnd)
          if (lastSemi !== -1 && lastSemi > jsonStart) {
            const jsonString = html.substring(jsonStart + 23, lastSemi)
            const data = JSON.parse(jsonString)
            const item = data.item

            if (item) {
              if (item.description) {
                fullDescription = item.description
                  .replace(/<br\s*\/?>/gi, '\n')
                  .replace(/<[^>]+>/g, '') // Strip tags
                  .replace(/&quot;/g, '"')
                  .replace(/&amp;/g, '&')
                  .replace(/&#039;/g, "'")
                  .trim()
              }

              const links = item.links
              if (links) {
                const joinNames = (key: string) => {
                  const arr = links[key]
                  if (Array.isArray(arr)) {
                    return arr.map((o: any) => o.name).join(', ')
                  }
                  return null
                }
                categories = joinNames('boardgamecategory')
                mechanics = joinNames('boardgamemechanic')
                type = joinNames('boardgamesubdomain')
                families = joinNames('boardgamefamily')
              }
            }
          }
        }
      }
    } catch (_e) {
      console.warn('JSON parsing failed, falling back to basic regex')
    }

    return {
      description: fullDescription || description,
      image_url: imageUrl,
      min_players: minPlayers,
      max_players: maxPlayers,
      min_playtime: minPlaytime,
      max_playtime: maxPlaytime,
      min_age: minAge,
      year_published: yearPublished,
      categories: categories,
      mechanics: mechanics,
      type: type,
      families: families,
    }

  } catch (e) {
    console.error(`Error scraping BGG ${bggId}:`, e)
    return null
  }
}

// Simple entity decoder
function decode(str: string) {
  return str.replace(/&quot;/g, '"').replace(/&amp;/g, '&').replace(/&#039;/g, "'")
}
