// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const BGG_BASE_URL = 'https://boardgamegeek.com/boardgame'

Deno.serve(async (req) => {
  try {
    const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
    const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    
    if (!supabaseKey) {
       return new Response(JSON.stringify({ error: 'Missing SUPABASE_SERVICE_ROLE_KEY' }), { status: 500 })
    }

    const supabase = createClient(supabaseUrl, supabaseKey)

    // 2. Busca lote de jogos
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
          console.error(`Failed to scrape details for ${game.name}`)
          results.push({ id: game.id, status: 'error', reason: 'scrape_failed' })
        }

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

    // 1. Metadados de Meta Tags
    const descMatch = html.match(/<meta property="og:description" content="([^"]+)"/)
    let description = descMatch ? decode(descMatch[1]) : ''
    const imgMatch = html.match(/<meta property="og:image" content="([^"]+)"/)
    const imageUrl = imgMatch ? imgMatch[1] : null

    // 2. Título (Nome Limpo)
    let bggName: string | null = null
    const titleMatch = html.match(/<title>(.*?) \| BoardGameGeek<\/title>/)
    if (titleMatch) {
       bggName = titleMatch[1]
          .replace(/\s*\|\s*Board\s*Game.*/gi, '')
          .replace(/\s*\|\s*BoardGameGeek/gi, '')
          .trim()
    }

    const tryParseStat = (key: string) => {
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

    // 3. Extração Avançada via JSON GEEK.geekitemPreload
    let categories: string | null = null
    let mechanics: string | null = null
    let type: string | null = null
    let families: string | null = null
    let integrations: string | null = null
    let reimplementations: string | null = null
    let rank = 0
    let rating: number | null = null
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
                  .replace(/<[^>]+>/g, '')
                  .replace(/&quot;/g, '"')
                  .replace(/&amp;/g, '&')
                  .replace(/&#039;/g, "'")
                  .trim()
              }

              if (item.links) {
                const joinNames = (key: string) => {
                  const arr = item.links[key]
                  return Array.isArray(arr) ? arr.map((o: any) => o.name).join(', ') : null
                }
                categories = joinNames('boardgamecategory')
                mechanics = joinNames('boardgamemechanic')
                type = joinNames('boardgamesubdomain')
                families = joinNames('boardgamefamily')
                integrations = joinNames('boardgameintegration')
                reimplementations = joinNames('reimplements')
              }

              if (item.stats) {
                if (item.stats.rating && item.stats.rating.average) {
                  rating = parseFloat(item.stats.rating.average)
                }
                if (Array.isArray(item.stats.ranks)) {
                  const bgRank = item.stats.ranks.find((r: any) => r.name === 'boardgame')
                  if (bgRank) rank = parseInt(bgRank.value) || 0
                }
              }
            }
          }
        }
      }
    } catch (_e) {
      console.warn('JSON parsing failed')
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
      categories,
      mechanics,
      type,
      families,
      integrations,
      reimplementations,
      rank,
      rating,
      name: bggName,
    }

  } catch (e) {
    console.error(`Error scraping BGG ${bggId}:`, e)
    return null
  }
}

function decode(str: string) {
  return str.replace(/&quot;/g, '"').replace(/&amp;/g, '&').replace(/&#039;/g, "'")
}
