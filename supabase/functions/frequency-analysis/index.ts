import { serve } from "https://deno.land/std@0.177.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.7'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const supabaseUrl = Deno.env.get('URL')
  const supabaseKey = Deno.env.get('SERVICE_KEY')

  if (!supabaseUrl || !supabaseKey) {
    return new Response(
      JSON.stringify({ error: 'Missing environment variables' }),
      {
        status: 500,
        headers: { 'Content-Type': 'application/json', ...corsHeaders }
      }
    )
  }

  const supabase = createClient(supabaseUrl, supabaseKey)

  try {
    const last24Hours = new Date(Date.now() - 24 * 60 * 60 * 1000).toISOString()

    const { data: requests, error } = await supabase
      .from('requests')
      .select('*')
      .eq('status', 'pending')
      .gte('created_at', last24Hours)

    if (error) throw error

    const requestCounts: Record<string, number> = {}
    for (const request of requests) {
      if (!requestCounts[request.victim_id]) {
        requestCounts[request.victim_id] = 0
      }
      requestCounts[request.victim_id]++
    }

    let isFraudulent = false
    for (const [victimId, count] of Object.entries(requestCounts)) {
      if (count >= 5) {
        isFraudulent = true
        await supabase
          .from('requests')
          .update({ status: 'rejected' })
          .eq('requested_by', victimId)
          .eq('status', 'pending')

          .gte('created_at', last24Hours)
          .gt('requested_by', requests[3].id); // Keep first 4 pending

      }
    }

    return new Response(
      JSON.stringify({
        isFraudulent,
        message: 'Frequency analysis completed'
      }),
      {
        headers: { 'Content-Type': 'application/json', ...corsHeaders },
        status: 200
      }
    )
  } catch (err) {
    console.error(err)
    return new Response(
      JSON.stringify({ error: 'Error during frequency analysis' }),
      {
        headers: { 'Content-Type': 'application/json', ...corsHeaders },
        status: 500
      }
    )
  }
})