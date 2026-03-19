// ignore_for_file: constant_identifier_names

import 'package:zili_coffee/utils/extension/list.dart';

import '../../utils/enums.dart';

enum FirebaseMessagingType {
  newRoastingSlip,
  completedRoastingSlip,
  cancelledRoastingSlip,
  newPackingSlip,
  exportedMaterialPackingSlip,
  completedPackingSlip,
  cancelledPackingSlip,
  createQuotation,
  approveQuotation,
  rejectQuotation;

  static FirebaseMessagingType? tryParse(String? type) {
    return FirebaseMessagingType.values.valueBy(
      (item) => item.toConstant == type,
    );
  }
}
