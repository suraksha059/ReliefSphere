import 'package:relief_sphere/core/model/home_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../app/exceptions/exceptions.dart';
import '../../app/services/service_locator.dart';

class HomeApi {
  final SupabaseClient _client = ServiceLocator.supabase.client;

  Future<HomeModel> getDashboardItems({String? userId}) async {
    if (userId == null) {
      throw AppExceptions('userId not found');
    }

    try {
      final activeResponse = await _client
          .from('requests')
          .select('id')
          .inFilter('status', ['pending', 'in_progress']).eq(
              'requested_by', userId);

      final pendingResponse =
          await _client.from('requests').select('id').eq('status', 'pending');

      final aidResponse = await _client
          .from('donation')
          .select('''
            amount,
            requests!inner (
              requested_by
            )
          ''')
          .eq('requests.requested_by', userId)
          .eq('requests.status', 'completed');

      double totalAidReceived = 0;
      for (final donation in aidResponse) {
        totalAidReceived += (donation['amount'] as num).toDouble();
      }

      return HomeModel(
        activeRequests: (activeResponse as List).length,
        pendingRequests: (pendingResponse as List).length,
        aidReceived: totalAidReceived.toInt(),
        lastUpdated: DateTime.now(),
      );
    } catch (error) {
      throw AppExceptions(
          'Failed to fetch dashboard items: ${error.toString()}');
    }
  }
}
