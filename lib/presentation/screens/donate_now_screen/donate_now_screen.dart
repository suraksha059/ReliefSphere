import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:khalti_checkout_flutter/khalti_checkout_flutter.dart';
import 'package:provider/provider.dart';

import '../../../app/utils/logger_utils.dart';
import '../../../core/model/request_model.dart';
import '../../../core/notifiers/request/request_notifier.dart';
import '../../widgets/custom_image_viewer.dart';
import '../../widgets/dialogs/dialog_utils.dart';

class DonateNowScreen extends StatefulWidget {
  final RequestModel request;

  const DonateNowScreen({
    super.key,
    required this.request,
  });

  @override
  State<DonateNowScreen> createState() => _DonateNowScreenState();
}

class _DonateNowScreenState extends State<DonateNowScreen> {
  final TextEditingController _amountController = TextEditingController();

  bool isPaymentCompleted = false;
  String paymentStatusMessage = '';
  String _selectedAmount = '';
  String _selectedPaymentMethod = '';
  bool _acceptTerms = false;
  final List<String> _quickAmounts = ['100', '500', '1000', '5000'];
  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'Khalti', 'icon': Icons.wallet},
    {'name': 'Paypal', 'icon': Icons.paypal},
  ];

  late final Future<Khalti?> _khalti;
  PaymentResult? _paymentResult;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Make a Donation',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Request Summary Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primaryContainer.withOpacity(0.3),
                      theme.colorScheme.surface,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.request.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.request.urgencyLevel.value.toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 20,
                          color: theme.colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          widget.request.type.value
                              .replaceAll('_', ' ')
                              .toUpperCase(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.request.description,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        height: 1.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (widget.request.address != null) ...[
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 20,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              widget.request.address!,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    if (widget.request.images?.isNotEmpty ?? false) ...[
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child:
                              CustomImageViewer(images: widget.request.images!),
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Requested on ${DateFormat('MMM d, yyyy').format(widget.request.date ?? DateTime.now())}',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color:
                                _getStatusColor(context, widget.request.status)
                                    .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.request.status.value
                                .replaceAll('_', ' ')
                                .toUpperCase(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: _getStatusColor(
                                  context, widget.request.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Amount Input Section
              Text(
                'Select Amount',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
                decoration: InputDecoration(
                  prefixText: 'Rs ',
                  prefixStyle: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickAmounts.map((amount) {
                  final isSelected = _selectedAmount == amount;
                  return ChoiceChip(
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedAmount = selected ? amount : '';
                        _amountController.text = _selectedAmount;
                      });
                    },
                    label: Text('Rs$amount'),
                    labelStyle: theme.textTheme.bodyLarge?.copyWith(
                      color: isSelected
                          ? theme.colorScheme.onPrimaryContainer
                          : theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Payment Methods
              Text(
                'Payment Method',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: _paymentMethods.map((method) {
                  final isSelected = _selectedPaymentMethod == method['name'];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? theme.colorScheme.primaryContainer.withOpacity(0.3)
                          : theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? theme.colorScheme.primary
                            : theme.colorScheme.outlineVariant,
                      ),
                    ),
                    child: RadioListTile(
                      value: method['name'],
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(
                            () => _selectedPaymentMethod = value.toString());
                      },
                      title: Row(
                        children: [
                          Icon(
                            method['icon'],
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            method['name'],
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              // Terms Checkbox
              CheckboxListTile(
                value: _acceptTerms,
                onChanged: (value) {
                  setState(() => _acceptTerms = value ?? false);
                },
                title: Text(
                  'I agree to the terms and conditions',
                  style: theme.textTheme.bodyMedium,
                ),
                controlAffinity: ListTileControlAffinity.leading,
              ),

              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed:
                    _acceptTerms ? () => _processDonation(context) : null,
                icon: const Icon(Icons.favorite),
                label: const Text('Confirm Donation'),
                style: FilledButton.styleFrom(
                  minimumSize: const Size(double.infinity, 56),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initializeKhalti();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<RequestNotifier>().createDonation();
    });
  }

  Widget _buildPaymentStatus() {
    if (_paymentResult == null) return const SizedBox.shrink();

    return Column(
      children: [
        Text('Transaction ID: ${_paymentResult!.payload?.transactionId}'),
        Text('Status: ${_paymentResult!.payload?.status}'),
        Text('Amount Paid: ${_paymentResult!.payload?.totalAmount}'),
      ],
    );
  }

  Color _getStatusColor(BuildContext context, RequestStatus status) {
    final theme = Theme.of(context);
    switch (status) {
      case RequestStatus.approved:
        return Colors.green;
      case RequestStatus.pending:
        return theme.colorScheme.primary;
      case RequestStatus.inProgress:
        return Colors.orange;
      case RequestStatus.rejected:
        return Colors.red;
      case RequestStatus.completed:
        return Colors.green;
      case RequestStatus.cancelled:
        return Colors.grey;
    }
  }

  void _initializeKhalti() {
    final payConfig = KhaltiPayConfig(
      publicKey: 'live_public_key_979320ffda734d8e9f7758ac39ec775f',
      pidx: 'ZyzCEMLFz2QYFYfERGh8LE',
      environment: Environment.test,
    );

    _khalti = Khalti.init(
      enableDebugging: true,
      payConfig: payConfig,
      onPaymentResult: (paymentResult, khalti) {
        logger.i(paymentResult.toString());
        setState(() {
          _paymentResult = paymentResult;

          paymentResult.payload?.status ?? "Payment Success";
        });
        khalti.close(context);
      },
      onMessage: (
        khalti, {
        description,
        statusCode,
        event,
        needsPaymentConfirmation,
      }) async {
        logger.i(
          'Description: $description, Status Code: $statusCode, Event: $event, NeedsPaymentConfirmation: $needsPaymentConfirmation',
        );
        khalti.close(context);
      },
      onReturn: () => logger.i('Successfully redirected to return_url.'),
    );
  }

  Future<void> _payWithKhalti(BuildContext context) async {
    final khaltiInstance = await _khalti;
    if (khaltiInstance != null) {
      khaltiInstance.open(context);
    }
  }

  void _payWithPaypal() {}

  void _processDonation(BuildContext context) async {
    if (_amountController.text.isEmpty || _selectedPaymentMethod.isEmpty) {
      return;
    }

    final amount = double.parse(_amountController.text);
    if (_selectedPaymentMethod.toLowerCase() == 'khalti') {
      await _payWithKhalti(context);
    }
    if (_selectedPaymentMethod == 'paypal') {
      _payWithPaypal();
    }

    if (isPaymentCompleted) {
      await context.read<RequestNotifier>().createDonation(
            requestId: widget.request.id!,
            amount: amount,
            paymentMethod: _selectedPaymentMethod,
          );

      final notifier = context.read<RequestNotifier>().state;

      if (notifier.isSuccess) {
        DialogUtils.showSuccessDialog(context, onPressed: () {
          context.pop();
        }, theme: Theme.of(context), message: 'donation created successfully');
      }
      if (notifier.isFailure) {
        DialogUtils.showFailureDialog(
          context,
          theme: Theme.of(context),
          title: 'Unable to confirm donation',
          message: notifier.error,
        );
      }
    } else {
      DialogUtils.showFailureDialog(
        context,
        theme: Theme.of(context),
        title: 'Unable to confirm donation',
        message: paymentStatusMessage,
      );
    }
  }
}
