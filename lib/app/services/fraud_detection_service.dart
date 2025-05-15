import 'package:relief_sphere/core/model/request_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../exceptions/exceptions.dart';

class FraudDetectionService {
  final SupabaseClient _supabase;

  FraudDetectionService(this._supabase);

  String getJsonRequestType(RequestType type) {
    switch (type) {
      case RequestType.foodAndEssentials:
        return 'food_and_essentials';
      case RequestType.medicalAid:
        return 'medical_aid';
      case RequestType.clothing:
        return 'clothing';
      case RequestType.utilities:
        return 'utilities';
      default:
        return 'other';
    }
  }

  Future<bool> runFraudChecks({
    required String id,
    required double longitude,
    required double latitude,
    required RequestType resourceType,
  }) async {
    try {
      final last24Hours = DateTime.now().subtract(const Duration(hours: 24));

      // Check 1: Frequency Analysis
      final frequencyResponse = await _supabase.functions.invoke(
        'frequency-analysis',
        body: {
          'victim_id': id,
          'last_24_hours': last24Hours.toIso8601String(),
        },
      );
      if (frequencyResponse.status != 200) {
        throw AppExceptions(
            'Frequency check failed: ${frequencyResponse.data}');
      }

      final isFrequencyFraud = frequencyResponse.data['isFraudulent'];
      if (isFrequencyFraud) {
        return true; // Stop checks if frequency fraud detected
      }

      // Check 2: Resource Duplication (only if frequency check passes)
      final resourceResponse = await _supabase.functions.invoke(
        'resource-analysis',
        body: {
          'victim_id': id,
          'resource_type': getJsonRequestType(resourceType),
          'last_24_hours': last24Hours.toIso8601String(),
        },
      );
      if (resourceResponse.status != 200) {
        throw AppExceptions('Resource check failed: ${resourceResponse.data}');
      }

      final isResourceFraud = resourceResponse.data['status'] == 'rejected';
      if (isResourceFraud) {
        return true; // Stop checks if resource fraud detected
      }

      // Check 3: Location Mismatch (only if previous checks pass)

      final locationResponse = await _supabase.functions.invoke(
        'location-analysis',
        body: {
          'victim_id': id,
          'lat': latitude,
          'long': longitude,
        },
      );
      if (locationResponse.status != 200) {
        throw AppExceptions('Location check failed: ${locationResponse.data}');
      }

      final isLocationFraud = locationResponse.data['status'] == 'rejected';
      return isLocationFraud;
    } catch (e) {
      print('Fraud detection error: $e'); // Log error for debugging
      throw AppExceptions('Error during fraud detection: $e');
    }
  }
}
