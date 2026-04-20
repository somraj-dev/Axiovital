import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.3.1"
import { pipeline, env } from "https://cdn.jsdelivr.net/npm/@xenova/transformers@2.17.2"

// -- ENVIRONMENT CONFIG --
env.useBrowserCache = false;
env.allowLocalModels = false;

// Initialize the embedding model (all-MiniLM-L6-v2)
// This model converts text into 384-dimensional vectors
const extractor = await pipeline('feature-extraction', 'sentence-transformers/all-MiniLM-L6-v2');

serve(async (req) => {
  // CORS Headers
  const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  }

  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    const { query, location = 'bhopal' } = await req.json()
    
    if (!query) throw new Error("Query is required");

    // 1. Preprocessing & Hinglish Support
    let processedQuery = query.toLowerCase().trim();
    const synonyms: Record<string, string> = {
      "bukhar": "fever",
      "khansi": "cough",
      "dawai": "medicine",
      "doctor": "doctor",
      "dr": "doctor"
    };
    
    for (const [key, val] of Object.entries(synonyms)) {
      if (processedQuery.includes(key)) processedQuery = processedQuery.replace(key, val);
    }

    // 2. Intent Detection (Rule-based)
    let intent = 'all';
    if (/doctor|physician|surgeon|clinic/.test(processedQuery)) intent = 'doctor';
    else if (/lab|test|pathology|blood/.test(processedQuery)) intent = 'lab';
    else if (/medicine|tablet|capsule|syrup/.test(processedQuery)) intent = 'medicine';
    else if (/insurance|policy|plan/.test(processedQuery)) intent = 'insurance';

    // 3. Generate Embedding using all-MiniLM-L6-v2
    const output = await extractor(processedQuery, {
      pooling: 'mean',
      normalize: true,
    });
    const queryEmbedding = Array.from(output.data);

    // 4. Query DB for semantic match
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
    );

    const { data: matches, error } = await supabase.rpc('match_kavaan', {
      query_embedding: queryEmbedding,
      match_threshold: 0.3,
      match_count: 20,
      intent_filter: intent
    });

    if (error) throw error;

    // 5. Final Ranking Algorithm (Amazon-style)
    const rankedResults = matches.map((item: any) => {
      const semanticScore = item.similarity;
      
      // Text Relevance (Keyword match in name)
      let textRelevance = 0.0;
      if (item.name.toLowerCase().includes(processedQuery)) textRelevance = 1.0;
      else if (processedQuery.split(' ').some((w: string) => item.name.toLowerCase().includes(w))) textRelevance = 0.6;

      // Popularity (Logarithmic scale)
      const popScore = Math.log10(1 + (item.popularity || 0)) / 3.0;
      
      // Rating Score
      const ratingScore = ((item.rating || 0) / 5.0) * (Math.log10(1 + (item.review_count || 0)) / 3.0);

      // Category Intent Boost
      const intentBoost = (item.type === intent) ? 1.5 : 1.0;

      const finalScore = (
        (0.40 * semanticScore) +
        (0.30 * textRelevance) +
        (0.15 * popScore) +
        (0.10 * ratingScore) +
        (0.05 * 0.5) // Mock Personalization
      ) * intentBoost;

      return {
        ...item,
        score: parseFloat(finalScore.toFixed(3))
      };
    }).sort((a: any, b: any) => b.score - a.score);

    return new Response(
      JSON.stringify({ results: rankedResults, intent }),
      { headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )

  } catch (error: any) {
    return new Response(
      JSON.stringify({ error: error.message }),
      { status: 500, headers: { ...corsHeaders, 'Content-Type': 'application/json' } }
    )
  }
})
