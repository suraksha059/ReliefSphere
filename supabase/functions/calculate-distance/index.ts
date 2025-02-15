import { serve } from 'https://deno.land/std@0.177.0/http/server.ts';

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, GET, OPTIONS',
};

interface Request {
  id: string;
  lat: number | null;
  long: number | null;
  created_at: string;
  status: string;
}

interface RequestWithDistance extends Request {
  distance: number;
}

interface RequestBody {
  requests: Request[];
  userLat: number;
  userLon: number;
}

function vincentyDistance(lat1: number, lon1: number, lat2: number, lon2: number): number {
  const a = 6378137.0; 
  const f = 1 / 298.257223563; 
  const b = (1 - f) * a; 

  const toRadians = (deg: number) => deg * Math.PI / 180;
  const phi1 = toRadians(lat1);
  const lambda1 = toRadians(lon1);
  const phi2 = toRadians(lat2);
  const lambda2 = toRadians(lon2);

  const L = lambda2 - lambda1;
  const tanU1 = (1 - f) * Math.tan(phi1);
  const tanU2 = (1 - f) * Math.tan(phi2);
  const U1 = Math.atan(tanU1);
  const U2 = Math.atan(tanU2);
  const sinU1 = Math.sin(U1);
  const cosU1 = Math.cos(U1);
  const sinU2 = Math.sin(U2);
  const cosU2 = Math.cos(U2);

  let lambda = L;
  let lambdaP;
  let iterLimit = 100;
  let cosSqAlpha;
  let sinSigma;
  let cos2SigmaM;
  let cosSigma;
  let sigma;

  do {
    const sinLambda = Math.sin(lambda);
    const cosLambda = Math.cos(lambda);
    sinSigma = Math.sqrt(
      (cosU2 * sinLambda) ** 2 +
      (cosU1 * sinU2 - sinU1 * cosU2 * cosLambda) ** 2
    );
    
    if (sinSigma === 0) return 0;
    
    cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
    sigma = Math.atan2(sinSigma, cosSigma);
    const sinAlpha = cosU1 * cosU2 * Math.sin(lambda) / sinSigma;
    cosSqAlpha = 1 - sinAlpha ** 2;
    cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
    
    const C = f / 16 * cosSqAlpha * (4 + f * (4 - 3 * cosSqAlpha));
    lambdaP = lambda;
    lambda = L + (1 - C) * f * sinAlpha * (
      sigma + C * sinSigma * (cos2SigmaM + C * cosSigma * (-1 + 2 * cos2SigmaM ** 2))
    );
  } while (Math.abs(lambda - lambdaP) > 1e-12 && --iterLimit > 0);

  if (iterLimit === 0) return 0;

  const uSq = cosSqAlpha * (a ** 2 - b ** 2) / (b ** 2);
  const A = 1 + uSq / 16384 * (4096 + uSq * (-768 + uSq * (320 - 175 * uSq)));
  const B = uSq / 1024 * (256 + uSq * (-128 + uSq * (74 - 47 * uSq)));
  const deltaSigma = B * sinSigma * (
    cos2SigmaM + B / 4 * (cosSigma * (-1 + 2 * cos2SigmaM ** 2) -
    B / 6 * cos2SigmaM * (-3 + 4 * sinSigma ** 2) * (-3 + 4 * cos2SigmaM ** 2))
  );

  return b * A * (sigma - deltaSigma);
}

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders });
  }

  try {
    const { requests, userLat, userLon } = (await req.json()) as RequestBody;

    if (!Array.isArray(requests) || typeof userLat !== 'number' || typeof userLon !== 'number') {
      throw new Error('Invalid request format');
    }

    const requestsWithDistance: RequestWithDistance[] = requests
      .map((request) => {
        if (request.lat === null || request.long === null) {
          return {
            ...request,
            distance: Number.MAX_VALUE
          };
        }
        return {
          ...request,
          distance: vincentyDistance(userLat, userLon, request.lat, request.long) / 1000
        };
      })
      .sort((a, b) => a.distance - b.distance);

    return new Response(JSON.stringify(requestsWithDistance), { 
      headers: {
        'Content-Type': 'application/json',
        ...corsHeaders
      }
    });
  } catch (error) {
    return new Response(
      JSON.stringify({ 
        error: error instanceof Error ? error.message : 'Unknown error occurred'
      }),
      { 
        status: 400,
        headers: {
          'Content-Type': 'application/json',
          ...corsHeaders
        }
      }
    );
  }
});
