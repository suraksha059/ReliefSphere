import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.7"
import "jsr:@supabase/functions-js/edge-runtime.d.ts"
import admin from "npm:firebase-admin@11.11.1"

// Debug logging for initialization
console.log("Starting notification function...")
console.log("Checking environment variables...")

console.log("Hello from Functions!")

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface NotificationPayload {
  profile_id: string;
  title: string;
  body: string;
  type: string;
  data?: Record<string, string>;
  token?: string;
  created_at: string;
}

interface WebhookPayload {
  type: 'INSERT';
  table: string;
  record: NotificationPayload;
  schema: 'public';
  old_record: null | NotificationPayload;
}

// Validate environment variables
const supabaseUrl = Deno.env.get('URL')
const supabaseKey = Deno.env.get('SERVICE_KEY')
const firebaseServiceAccount = Deno.env.get('FIREBASE_CONFIG')

console.log("Supabase URL exists:", !!supabaseUrl)
console.log("Supabase key exists:", !!supabaseKey)
console.log("Firebase config exists:", !!firebaseServiceAccount)

if (!supabaseUrl || !supabaseKey || !firebaseServiceAccount) {
  throw new Error('Required environment variables are not set')
}

const supabase = createClient(supabaseUrl, supabaseKey)

// Initialize Firebase Admin
const serviceAccount = JSON.parse(firebaseServiceAccount)
const firebaseApp = admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
})

const messaging = admin.messaging(firebaseApp)

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    console.log("Received request:", req.method)
    const payload: WebhookPayload = await req.json()
    console.log("Webhook payload:", JSON.stringify(payload, null, 2))

    const { data, error } = await supabase
      .from('profiles')
      .select('fcm_token')
      .eq('id', payload.record.profile_id)
      .single()

    if (error) {
      console.error("Supabase error:", error)
      throw new Error(`Failed to fetch FCM token: ${error.message}`)
    }

    if (!data?.fcm_token) {
      console.error("No FCM token found for user:", payload.record.profile_id)
      throw new Error('FCM token not found')
    }

    console.log("Retrieved FCM token:", data.fcm_token)

    // Validate FCM token format
    if (typeof data.fcm_token !== 'string' || data.fcm_token.length < 100) {
      console.error("Invalid FCM token format:", data.fcm_token)
      throw new Error('Invalid FCM token format')
    }

    // Convert all data values to strings
    const stringifiedData: Record<string, string> = {};
    if (payload.record.data) {
      Object.entries(payload.record.data).forEach(([key, value]) => {
        stringifiedData[key] = String(value);
      });
    }

    const message = {
      token: data.fcm_token,
      notification: {
        title: payload.record.title,
        body: payload.record.body,
      },
      data: stringifiedData, // Use the stringified data
      android: {
        priority: 'high',
      },
      apns: {
        payload: {
          aps: {
            contentAvailable: true,
          },
        },
      },
    }

    console.log("Sending FCM message:", JSON.stringify(message, null, 2))

    try {
      const response = await messaging.send(message)
      console.log("FCM Response:", response)
      
      return new Response(
        JSON.stringify({ 
          success: true, 
          messageId: response,
          debug: {
            fcmToken: data.fcm_token,
            payload: message,
            response: response
          }
        }),
        {
          headers: {
            'Content-Type': 'application/json',
            ...corsHeaders,
          },
        },
      )
    } catch (fcmError) {
      console.error("FCM Error:", fcmError)
      throw new Error(`FCM send failed: ${fcmError.message}`)
    }
  } catch (error) {
    console.error("Function error:", error)
    return new Response(
      JSON.stringify({
        success: false,
        error: error.message,
        stack: error.stack,
        timestamp: new Date().toISOString()
      }),
      {
        status: 400,
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders,
        },
      },
    )
  }
})


