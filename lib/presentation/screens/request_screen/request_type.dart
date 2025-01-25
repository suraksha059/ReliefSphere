import 'package:flutter/material.dart';

enum RequestType {
  food(
    icon: Icons.restaurant_outlined,
    label: 'Food & Essentials',
    description: 'Request food supplies and basic necessities',
  ),
  medical(
    icon: Icons.medical_services_outlined,
    label: 'Medical Aid',
    description: 'Request medicines and medical assistance',
  ),
  shelter(
    icon: Icons.home_outlined,
    label: 'Shelter',
    description: 'Request temporary housing or accommodation',
  ),
  clothing(
    icon: Icons.checkroom_outlined,
    label: 'Clothing',
    description: 'Request essential clothing items',
  ),
  utilities(
    icon: Icons.water_drop_outlined,
    label: 'Utilities',
    description: 'Request water, electricity or basic utilities',
  ),
  other(
    icon: Icons.more_horiz_outlined,
    label: 'Other',
    description: 'Request other types of assistance',
  );

  final IconData icon;
  final String label;
  final String description;

  const RequestType({
    required this.icon,
    required this.label,
    required this.description,
  });
}
