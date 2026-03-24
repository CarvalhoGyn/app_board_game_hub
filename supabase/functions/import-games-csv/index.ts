// deno-lint-ignore-file no-explicit-any
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { parse } from 'https://deno.land/std@0.208.0/csv/parse.ts'

Deno.serve(async (req) => {
    try {
        // 1. Initialize Supabase
        const supabaseUrl = Deno.env.get('SUPABASE_URL') ?? ''
        const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''

        if (!supabaseKey) {
            return new Response(JSON.stringify({ error: 'Missing SUPABASE_SERVICE_ROLE_KEY' }), {
                status: 500,
                headers: { 'Content-Type': 'application/json' },
            })
        }

        const supabase = createClient(supabaseUrl, supabaseKey)

        // 2. Parse Request Payload (Optional filename, default to fixed)
        let filename = 'boardgames_ranks.csv'
        try {
            const body = await req.json()
            if (body.filename) filename = body.filename
        } catch {
            // Body might be empty, use default
        }

        console.log(`Starting import for: ${filename}`)

        // 3. Download CSV from Storage
        const { data: fileData, error: downloadError } = await supabase
            .storage
            .from('data')
            .download(filename)

        if (downloadError) {
            return new Response(JSON.stringify({ error: `Failed to download file: ${downloadError.message}` }), {
                status: 400,
                headers: { 'Content-Type': 'application/json' },
            })
        }

        // 4. Parse CSV
        const text = await fileData.text()
        // Parse with skipping headers, and assuming column order:
        // id, name, yearpublished, rank, bayesaverage, average, usersrated, ...
        // Or we can use 'columns' option if we trust the header row. 
        // Let's use result as array of arrays (rows) for speed/simplicity, ignoring header.
        const rows = parse(text, { skipFirstRow: true }) as any[][]

        console.log(`CSV Parsed. Rows found: ${rows.length}`)

        // 5. Batch Processing
        const BATCH_SIZE = 1000
        let processed = 0
        let inserted = 0
        let errors = 0

        // Chunk the array
        for (let i = 0; i < rows.length; i += BATCH_SIZE) {
            const chunk = rows.slice(i, i + BATCH_SIZE)
            const validRows = []

            for (const row of chunk) {
                // Validation: Row must have id (0) and name (1)
                // CSV Format based on samples: 
                // id, name, yearpublished, rank, bayesaverage, average, ...
                if (row.length < 6) continue

                try {
                    const bggId = parseInt(row[0])
                    const name = row[1]
                    const year = parseInt(row[2]) || 0
                    const rank = parseInt(row[3]) || 0
                    const rating = parseFloat(row[5]) || 0.0

                    if (!isNaN(bggId) && name) {
                        validRows.push({
                            bgg_id: bggId,
                            name: name,
                            year_published: year,
                            rank: rank,
                            rating: rating,
                            updated_at: new Date().toISOString(),
                        })
                    }
                } catch {
                    errors++
                }
            }

            if (validRows.length > 0) {
                const { error: upsertError } = await supabase
                    .from('games')
                    .upsert(validRows, {
                        onConflict: 'bgg_id', // Critical for preventing duplicates/ensuring update
                        ignoreDuplicates: false // We WANT to update if it exists
                    })

                if (upsertError) {
                    console.error('Batch error:', upsertError)
                    errors += validRows.length
                } else {
                    inserted += validRows.length
                }
            }

            processed += chunk.length
            // Log progress occasionally
            if (processed % 10000 === 0) console.log(`Processed ${processed} / ${rows.length}`)
        }

        return new Response(JSON.stringify({
            message: 'Import complete',
            total_rows: rows.length,
            inserted_or_updated: inserted,
            errors: errors
        }), {
            headers: { 'Content-Type': 'application/json' },
        })

    } catch (err: any) {
        return new Response(JSON.stringify({ error: err.message }), {
            status: 500,
            headers: { 'Content-Type': 'application/json' },
        })
    }
})
