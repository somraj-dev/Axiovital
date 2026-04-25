// 🌊 Axiovital Supabase Edge Function: Semantic Search
// This function converts a query string into a vector embedding and searches the database.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { query } = await req.json()

    // 1. Initialize Supabase Client
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    )

    // 2. Generate Embedding using Supabase's built-in AI model
    // Note: Supabase provides internal access to transformers models
    const embeddingResponse = await fetch('https://api.supabase.com/v1/ai/embeddings', {
      method: 'POST',
      headers: { 'Authorization': `Bearer ${Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')}` },
      body: JSON.stringify({ input: query, model: 'gte-small' }) // gte-small is 384 dimensions
    })
    
    const { data: [{ embedding }] } = await embeddingResponse.json()

    // 3. Call the PostgreSQL RPC function we created earlier
    const { data: doctors, error: searchError } = await supabase.rpc('match_doctors', {
      query_embedding: embedding,
      match_threshold: 0.5,
      match_count: 5,
    })

    if (searchError) throw searchError

    return new Response(
      JSON.stringify({ results: doctors, intent: 'find_doctor' }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 400, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
