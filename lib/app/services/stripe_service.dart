import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  static const String _secretKey =
      'sk_test_51QsnaL2Ly1gSFyxfqmEcJVcgoR84PdWY82RotAi9VXsnHQlLLQCbSYWruJADzKiMo8lgBv3HGxMTn9ZyWCsvHN0A005lvGcKW3';
  static const String _publishableKey =
      'pk_test_51QsnaL2Ly1gSFyxfFKJwfdQ7iE5sLNQIKOa0ITeZsE5G2dbg0qzM2yFEb8znAgdTj0v2kxIvjSD7eiMiMM605dVx00ybHaQYi8';

  static Future<void> initialize() async {
    Stripe.publishableKey = _publishableKey;
  }

  static Future<PaymentSheetPaymentOption?> initPaymentSheet({
    required String email,
    required double amount,
  }) async {
    try {
      // Log payment attempt
      print('Initializing payment sheet for $email with amount $amount');

      final paymentIntentData = await _createPaymentIntent(
        amount: (amount * 100).toInt().toString(),
        currency: 'NPR',
        email: email,
      );

      print('Payment intent created: ${paymentIntentData['id']}');

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'ReliefSphere',
          paymentIntentClientSecret: paymentIntentData['client_secret'],
          style: ThemeMode.system,
          billingDetails: BillingDetails(email: email),
          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              primary: Color(0xFF0553B1),
            ),
          ),
        ),
      );

      final result = await Stripe.instance.presentPaymentSheet();
      print('Payment result: $result');
      return result;
    } catch (e) {
      print('Stripe payment error: $e');
      throw Exception('Payment failed: ${e.toString()}');
    }
  }

  static Future<Map<String, dynamic>> _createPaymentIntent({
    required String amount,
    required String currency,
    required String email,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'amount': amount,
          'currency': currency,
          'receipt_email': email,
          'payment_method_types[]': 'card',
        },
      );

      return json.decode(response.body);
    } catch (e) {
      throw Exception('Failed to create payment intent: $e');
    }
  }
}
