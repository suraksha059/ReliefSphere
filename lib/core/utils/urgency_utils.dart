import 'package:flutter/material.dart';
import 'package:relief_sphere/core/model/request_model.dart';

class UrgencyUtils {
  static UrgencyLevel getUrgencyLevel(int level) {
    if (level == 5) {
      return UrgencyLevel.critical;
    } else if (level == 4) {
      return UrgencyLevel.veryHigh;
    } else if (level == 3) {
      return UrgencyLevel.high;
    } else if (level == 2) {
      return UrgencyLevel.moderate;
    } else {
      return UrgencyLevel.low;
    }
  }

  static Color getUrgencyColor(UrgencyLevel urgency,
      {required ThemeData theme}) {
    switch (urgency) {
      case UrgencyLevel.critical:
        return theme.colorScheme.error;
      case UrgencyLevel.veryHigh:
        return theme.colorScheme.error.withOpacity(0.8);

      case UrgencyLevel.high:
        return theme.colorScheme.tertiary;

      case UrgencyLevel.moderate:
        return theme.colorScheme.primary;

      case UrgencyLevel.low:
        return theme.colorScheme.primary;
    }
  }
}
