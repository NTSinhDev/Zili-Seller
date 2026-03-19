import '../../../utils/enums.dart';
import '../../../utils/enums/order_enum.dart';

class ReviewQuotationInput {
  final String code;
  final QuoteStatus status;
  final String? reasonNote;
  final int? reasonId;

  ReviewQuotationInput({
    required this.code,
    required this.status,
    this.reasonNote,
    this.reasonId,
  });

  Map<String, dynamic> toMap() {
    return {
      'code': code,
      if ([QuoteStatus.approved, QuoteStatus.rejected].contains(status))
        'status': status.toConstant,
      if (reasonNote != null) 'reasonNote': reasonNote,
      if (reasonId != null) 'reasonId': reasonId,
    };
  }
}
