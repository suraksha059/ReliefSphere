import 'package:image_picker/image_picker.dart';
import 'package:relief_sphere/core/model/request_model.dart';
import 'package:relief_sphere/core/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../app/exceptions/exceptions.dart';
import '../../app/services/service_locator.dart';
import '../model/donation_model.dart';

class RequestApi {
  final SupabaseClient _client = ServiceLocator.supabase.client;

  Future<RequestModel> sendRequest({required RequestModel request}) async {
    try {
      final response = await _client
          .from('requests')
          .insert(request.toJson())
          .select('*')
          .single();

      return RequestModel.fromJson(response);
    } catch (error) {
      throw AppExceptions('Failed to send request: ${error.toString()}');
    }
  }

  Future<List<RequestModel>> getMyRequest(String? userId) async {
    if (userId == null) {
      throw AppExceptions('User ID not found');
    }
    try {
      final response = await _client
          .from('requests')
          .select('*')
          .eq('requested_by', userId)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => RequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw AppExceptions('Failed to fetch requests: ${error.toString()}');
    }
  }

  Future<List<RequestModel>> getAllRequest() async {
    try {
      final response = await _client
          .from('requests')
          .select()
          .order('created_at', ascending: false);
      return (response as List)
          .map((json) => RequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw AppExceptions('Failed to fetch requests: ${error.toString()}');
    }
  }

  Future<List<RequestModel>> getDonatedRequest() async {
    try {
      final response = await _client
          .from('requests')
          .select()
          .eq('status', 'donated')
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => RequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw AppExceptions(
          'Failed to fetch donated requests: ${error.toString()}');
    }
  }

  Future<List<RequestModel>> getPendingAndVerifiedRequest(UserRole role) async {
    try {
      final String status = role == UserRole.admin ? 'pending' : 'approved';

      final response = await _client
          .from('requests')
          .select()
          .eq('status', status)
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => RequestModel.fromJson(json))
          .toList();
    } catch (error) {
      throw AppExceptions(
          'Failed to fetch pending requests: ${error.toString()}');
    }
  }

  Future<void> verifyRequest({required int id, required bool isFreaud}) async {
    try {
      final status = isFreaud ? RequestStatus.rejected : RequestStatus.approved;

      await _client
          .from('requests')
          .update({'status': status.value}).eq('id', id);
    } catch (e) {
      throw AppExceptions('failed to verify request');
    }
  }

  Future<DonationModel> createDonation(
      {required DonationModel donation}) async {
    try {
      final response = await _client
          .from('donation')
          .insert(donation.toJson())
          .select()
          .single();

      return DonationModel.fromJson(response);
    } catch (error) {
      throw AppExceptions('Failed to create donation: ${error.toString()}');
    }
  }

  Future<List<String>> uploadImages(List<XFile> images) async {
    try {
      final List<String> imageUrls = [];

      for (final image in images) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
        final bytes = await image.readAsBytes();

        final response =
            await _client.storage.from('images').uploadBinary(fileName, bytes);

        final url = _client.storage.from('images').getPublicUrl(fileName);

        imageUrls.add(url);
      }

      return imageUrls;
    } catch (error) {
      throw AppExceptions('Failed to upload images: ${error.toString()}');
    }
  }
}
