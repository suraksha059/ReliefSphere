import 'package:flutter/material.dart';

import '../model/request_model.dart';

IconData getRequestTypeIcon(RequestType type) {
    switch (type) {
      case RequestType.foodAndEssentials:
        return Icons.restaurant_outlined;

      case RequestType.clothing:
        return Icons.checkroom_outlined;
      case RequestType.medicalAid:
        return Icons.medical_services_outlined;
      case RequestType.shelter:
        return Icons.home_outlined;
      case RequestType.utilities:
        return Icons.water_drop_outlined;
      case RequestType.other:
        return Icons.more_horiz_outlined;
    }
  }