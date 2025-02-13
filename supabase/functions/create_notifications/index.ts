import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.39.7";

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

interface NotificationRequest {
  type: 'request_created' | 'request_approved' | 'request_rejected';
  requestId: string;
  requestedBy: string;
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
    const { type, requestId, requestedBy } = await req.json() as NotificationRequest

    switch (type) {
      case 'request_created':
        await createNotification({
          profileId: requestedBy,
          title: 'Request Submitted',
          message: 'Your request is being reviewed by our admin team.',
          type: 'request_created',
          data: { request_id: requestId },
          supabase
        })

        // Notify admins
        const { data: admins } = await supabase
          .from('profiles')
          .select('id')
          .eq('role', 'admin')

        for (const admin of admins || []) {
          await createNotification({
            profileId: admin.id,
            title: 'New Request Pending',
            message: 'A new request needs your verification.',
            type: 'admin_notification',
            data: { request_id: requestId },
            supabase
          })
        }
        break

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
        break

      case 'request_rejected':
        await createNotification({
          profileId: requestedBy,
          title: 'Request Rejected',
          message: 'Your request could not be approved at this time.',
          type: 'request_status',
          data: { request_id: requestId },
          supabase
        })
        break
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
  message,
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
  await supabase.from('notifications').insert({
    profile_id: profileId,
    title,
    message,
    type,
    data,
    created_at: new Date().toISOString()
  })
}
