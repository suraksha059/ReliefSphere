import '../model/request_model.dart';

String getRequestTypeLabel(RequestType type) {
  switch (type) {
    case RequestType.foodAndEssentials:
      return 'Food & Essentials';

    case RequestType.clothing:
      return 'Clothing';
    case RequestType.medicalAid:
      return 'Medical Aid';
    case RequestType.shelter:
      return 'Shelther';
    case RequestType.utilities:
      return 'Utilities';
    case RequestType.other:
      return 'Other';
  }
}
