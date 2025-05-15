import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.7";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface NotificationRequest {
  type: 'request_approved' | 'request_rejected' | 'donor_login';
  requestId: string;
  requestedBy: string;
  donorId?: string;

}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  const supabaseUrl = Deno.env.get('URL')
  const supabaseKey = Deno.env.get('SERVICE_ROLE_KEY')

  if (!supabaseUrl || !supabaseKey) {
    throw new Error('Missing environment variables')
  }

  const supabase = createClient(supabaseUrl, supabaseKey)

  try {
    const { type, requestId, requestedBy, donorId } = await req.json() as NotificationRequest

    switch (type) {
      case 'request_approved':
        // Notify donors
        const { data: donors } = await supabase
          .from('profiles')
          .select('id')
          .eq('role', 'donor')

        for (const donor of donors || []) {
          await createNotification({
            profileId: donor.id,
            title: 'New Donation Opportunity',
            message: 'A new verified request needs your help.',
            type: 'donor_notification',
            data: { request_id: requestId },
            supabase
          })
        }

        // Notify requester
        await createNotification({
          profileId: requestedBy,
          title: 'Request Approved',
          message: 'Your request has been approved and shared with donors.',
          type: 'request_status',
          data: { request_id: requestId },
          supabase
        })
        break;

      case 'request_rejected':
        await createNotification({
          profileId: requestedBy,
          title: 'Request Rejected',
          message: 'Your request could not be approved at this time.',
          type: 'request_status',
          data: { request_id: requestId },
          supabase
        })
        break;

      case 'donor_login':
        if (!donorId) throw new Error('Missing donorId for donor_login notification');

        // Count pending requests that need attention
        const { count, error: countError } = await supabase
          .from('requests')
          .select('*', { count: 'exact', head: true })
          .eq('status', 'pending');

        if (countError) throw countError;

        // Create welcome notification with pending requests summary
        await createNotification({
          profileId: donorId,
          title: 'Welcome Back',
          message: count > 0 ?
            `There are ${count} pending requests that need your help.` :
            'Thank you for your continued support.',
          type: 'donor_welcome',
          data: { pending_count: count.toString() },
          supabase
        });
        break;

      default:
        throw new Error('Invalid notification type');
    }

    return new Response(
      JSON.stringify({ success: true }),
      {
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders
        }
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({
        error: error.message
      }),
      {
        status: 400,
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders
        }
      }
    )
  }
})

async function createNotification({
  profileId,
  title,
  message, // we'll use this as body
  type,
  data,
  supabase
}: {
  profileId: string;
  title: string;
  message: string;
  type: string;
  data: Record<string, string>;
  supabase: any;
}) {
  // First fetch the FCM token
  const { data: profile, error: profileError } = await supabase
    .from('profiles')
    .select('fcm_token')
    .eq('id', profileId)
    .single();

  if (profileError || !profile?.fcm_token) {
    console.error('No FCM token found for user:', profileId);
  }

  // Create notification with token if available
  await supabase.from('notifications').insert({
    profile_id: profileId,
    title,
    message: message, // renamed from message to body
    type,
    data,
    token: profile?.fcm_token, // Add FCM token
    created_at: new Date().toISOString()
  });
}
