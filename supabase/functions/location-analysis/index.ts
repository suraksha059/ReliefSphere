import { serve } from "https://deno.land/std@0.177.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.7'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

const MAX_DISTANCE = 5; // Maximum allowed distance in km

// Function to calculate distance between two points using Haversine formula
function calculateDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const R = 6371; // Earth's radius in kilometers
  const dLat = (lat2 - lat1) * Math.PI / 180;
  const dLon = (lon2 - lon1) * Math.PI / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1 * Math.PI / 180) * Math.cos(lat2 * Math.PI / 180) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
}

interface LocationRequest {
  victim_id: string;
  request_id: string; // Add request_id

  lat: number;
  long: number;
}

interface LocationResponse {
  isFraudulent: boolean;
  distance: number;
  message: string;
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
      { headers: { 'Content-Type': 'application/json', ...corsHeaders }, status: 500 }
    )
  }

  const supabase = createClient(supabaseUrl, supabaseKey)

  try {
    const body = await req.json() as LocationRequest
    console.log('Request body:', body) // Debug log

    // Validate all required parameters
    if (!body.victim_id || body.lat == null || body.long == null) {
      return new Response(
        JSON.stringify({
          error: `Missing parameters. Required: victim_id, lat, long. Got: ${JSON.stringify(body)}`
        }),
        {
          headers: { 'Content-Type': 'application/json', ...corsHeaders },
          status: 400
        }
      )
    }

    const { victim_id, request_id, lat, long } = body

    // Fetch victim's profile location
    const { data: profile, error: profileError } = await supabase
      .from('profiles')
      .select('lat, log')
      .eq('id', victim_id)
      .single()

    if (profileError || !profile?.lat || !profile?.log) {
      return new Response(
        JSON.stringify({ status: 'rejected', error: 'Profile location not found' }),
        {
          headers: { 'Content-Type': 'application/json', ...corsHeaders },
          status: 404
        }
      )
    }

    // Calculate distance between profile and request location (in km)
    const distance = calculateDistance(
      profile.lat,
      profile.log,
      lat,
      long
    )

    // Flag as fraudulent if distance > 5km
    const isFraudulent = distance > MAX_DISTANCE

    if (isFraudulent) {
      // Update pending requests for this user
      await supabase
        .from('requests')
        .update({ status: 'rejected' })
        .eq('requested_by', request_id)
        .eq('status', 'pending')
    }

    // Update response section
    const response: LocationResponse = {
      isFraudulent: distance > MAX_DISTANCE,
      distance,
      message: `Location analysis completed. Distance: ${distance.toFixed(2)}km`
    };

    return new Response(
      JSON.stringify({
        status: isFraudulent ? 'rejected' : 'approved',
        distance,
        message: `Distance: ${distance.toFixed(2)}km. Max allowed: ${MAX_DISTANCE}km`
      }),
      { headers: { 'Content-Type': 'application/json', ...corsHeaders }, status: 200 }
    )
  } catch (err) {
    console.error(err)
    return new Response(
      JSON.stringify({ error: err.message || 'Error during location analysis' }),
      { headers: { 'Content-Type': 'application/json', ...corsHeaders }, status: 500 }
    )
  }
})