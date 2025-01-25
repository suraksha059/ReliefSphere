import 'package:flutter/material.dart';

class DonateNowScreen extends StatefulWidget {
  final String requestTitle;
  final String requesterId;
  final double targetAmount;
  final double raisedAmount;

  const DonateNowScreen({
    super.key,
    required this.requestTitle,
    required this.requesterId,
    required this.targetAmount,
    required this.raisedAmount,
  });

  @override
  State<DonateNowScreen> createState() => _DonateNowScreenState();
}

class _DonateNowScreenState extends State<DonateNowScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedAmount = '';
  String _selectedPaymentMethod = '';
  bool _acceptTerms = false;
  final List<String> _quickAmounts = ['100', '500', '1000', '5000'];
  final List<Map<String, dynamic>> _paymentMethods = [
    {'name': 'Credit Card', 'icon': Icons.credit_card},
    {'name': 'UPI', 'icon': Icons.account_balance},
    {'name': 'Net Banking', 'icon': Icons.public},
  ];

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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.requestTitle,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: widget.raisedAmount / widget.targetAmount,
                      backgroundColor:
                          theme.colorScheme.primaryContainer.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${widget.raisedAmount.toStringAsFixed(0)} raised of ₹${widget.targetAmount.toStringAsFixed(0)}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
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
                  prefixText: '₹ ',
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
                    label: Text('₹$amount'),
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

              // Donate Button
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

  void _processDonation(BuildContext context) {
    // Implement donation processing logic
  }
}
