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
        const { victim_id, resource_type, last_24_hours } = await req.json()

        if (!victim_id || !resource_type) {
            throw new Error('Missing required parameters')
        }

        // Fetch pending requests from last 24 hours
        const { data: requests, error } = await supabase
            .from('requests')
            .select('*')
            .eq('status', 'pending')
            .eq('requested_by', victim_id)
            .eq('type', resource_type)
            .gte('created_at', last_24_hours)

        if (error) throw error

        const isFraudulent = requests && requests.length > 3;

        if (isFraudulent) {
            await supabase
                .from('requests')
                .update({ status: 'rejected' })
                .eq('requested_by', victim_id)
                .eq('type', resource_type)
                .gte('created_at', last_24_hours)
        }

        return new Response(
            JSON.stringify({
                isFraudulent,
                message: 'Resource analysis completed'
            }),
            {
                headers: { 'Content-Type': 'application/json', ...corsHeaders },
                status: 200
            }
        )
    } catch (err) {
        console.error(err)
        return new Response(
            JSON.stringify({ error: err.message || 'Error during resource analysis' }),
            {
                headers: { 'Content-Type': 'application/json', ...corsHeaders },
                status: 500
            }
        )
    }
})