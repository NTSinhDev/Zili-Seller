import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/template_mail_data.dart';
import '../../../../data/repositories/order_repository.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../services/common_service.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/enums/order_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../preview_image_url/preview_image_url_screen.dart';

class QuotationTypeSection extends StatefulWidget {
  final QuoteMailType? type;
  final Function(QuoteMailType, List<String>?, String) onMailTypeChanged;
  const QuotationTypeSection({
    super.key,
    required this.type,
    required this.onMailTypeChanged,
  });

  @override
  State<QuotationTypeSection> createState() => _QuotationTypeSectionState();
}

class _QuotationTypeSectionState extends State<QuotationTypeSection> {
  final CommonService _commonService = di<CommonService>();
  final OrderRepository _orderRepository = di<OrderRepository>();

  List<TemplateMailData> _templateMails = [];
  final List<(QuoteMailType, String)> _mailOptions = [
    (QuoteMailType.greenBeanQuote, 'Báo giá nhân xanh'),
    (QuoteMailType.brandQuote, 'Báo giá thương hiệu'),
    (QuoteMailType.quantityQuote, 'Báo giá số lượng'),
  ];
  QuoteMailType _crMailType = QuoteMailType.values.first;

  @override
  void initState() {
    super.initState();
    if (widget.type.isNotNull) _crMailType = widget.type!;
    _loadActiveQuoteTemplateMails();
  }

  void _loadActiveQuoteTemplateMails() {
    if ((_orderRepository.templateMails.valueOrNull ?? []).isNotEmpty) {
      _templateMails = _orderRepository.templateMails.valueOrNull ?? [];
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        final notes = _templateMails
            .valueBy((e) => e.code == _crMailType.toConstant)
            ?.note;
        final opts = _templateMails
            .valueBy((e) => e.code == _crMailType.toConstant)
            ?.contentJSON?["headerQuantities"];
        widget.onMailTypeChanged(
          _crMailType,
          opts is List<String>? ? opts : null,
          notes ?? '',
        );
        setState(() {});
      });
    } else {
      _commonService.getActiveQuoteTemplateMails().then((value) {
        // Defer to next frame to avoid FocusScope assertion after async completion
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _templateMails = value;
          final notes = _templateMails
              .valueBy((e) => e.code == _crMailType.toConstant)
              ?.note;
          final opts = _templateMails
              .valueBy((e) => e.code == _crMailType.toConstant)
              ?.contentJSON?["headerQuantities"];
          widget.onMailTypeChanged(
            _crMailType,
            opts is List<String>? ? opts : null,
            notes ?? '',
          );
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: .all(16.w),
      color: AppColors.white,
      child: InkWell(
        onTap: () {
          context.focus.unfocus();
          showModalBottomSheet(
            context: context,
            backgroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: .vertical(top: .circular(20.r)),
            ),
            isScrollControlled: true,
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            builder: (context) => ColumnWidget(
              mainAxisSize: .min,
              children: [
                BottomSheetHeader(
                  title: 'Phiếu báo giá',
                  onClose: context.navigator.pop,
                ),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: .symmetric(vertical: 16.h),
                    itemCount: _mailOptions.length,
                    clipBehavior: .hardEdge,
                    itemBuilder: (context, index) {
                      final (mailType, label) = _mailOptions[index];

                      return BottomSheetListItem(
                        isDense: false,
                        title: label,
                        isSelected: mailType == _crMailType,
                        trailing: InkWell(
                          onTap: () {
                            final template = _templateMails
                                .where(
                                  (e) =>
                                      e.code ==
                                          _mailOptions[index].$1.toConstant &&
                                      e.exampleImageUrl != null &&
                                      e.exampleImageUrl!.trim().isNotEmpty,
                                )
                                .firstOrNull;
                            final url = template?.exampleImageUrl?.trim();
                            if (url != null &&
                                url.isNotEmpty &&
                                context.mounted) {
                              PreviewImageUrlScreen.open(
                                context,
                                title: _mailOptions[index].$2,
                                imageUrl: url,
                              );
                            }
                          },
                          child: Container(
                            padding: .symmetric(horizontal: 8.w, vertical: 8.h),
                            child: Text(
                              '(Xem mẫu)',
                              style: AppStyles.text.medium(
                                fSize: 12.sp,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          if (mailType == _crMailType) {
                            context.navigator.pop();
                            return;
                          }
                          final template = _templateMails
                              .where((e) => e.code == mailType.toConstant)
                              .firstOrNull;
                          final opts =
                              template?.contentJSON?["headerQuantities"];
                          widget.onMailTypeChanged(
                            mailType,
                            (opts ?? []).length > 0
                                ? List.generate(
                                    opts.length,
                                    (i) => opts[i].toString(),
                                  )
                                : null,
                            template?.note ?? '',
                          );
                          setState(() {
                            _crMailType = mailType;
                          });
                          context.navigator.pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
        child: RowWidget(
          mainAxisAlignment: .spaceBetween,
          children: [
            RowWidget(
              gap: 12.w,
              children: [
                Container(
                  padding: .all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: .circular(8.r),
                  ),
                  child: Icon(
                    Icons.receipt_long_outlined,
                    color: AppColors.primary,
                    size: 20.sp,
                  ),
                ),
                ColumnWidget(
                  crossAxisAlignment: .start,
                  gap: 4.h,
                  children: [
                    Text(
                      'Phiếu báo giá',
                      style: AppStyles.text.medium(
                        fSize: 12.sp,
                        color: AppColors.grey84,
                      ),
                    ),
                    PlaceholderOptionsWidget(
                      width: 0.5.sw,
                      options: PlaceholderOptions.text16,
                      condition: _templateMails.isNotEmpty,
                      child: Text(
                        _mailOptions
                                .valueBy((option) => option.$1 == _crMailType)
                                ?.$2 ??
                            'Chưa chọn loại báo giá',
                        style: AppStyles.text.semiBold(
                          fSize: 16.sp,
                          color: AppColors.black3,
                          height: 18 / 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Icon(Icons.chevron_right, color: AppColors.grey84, size: 24.sp),
          ],
        ),
      ),
    );
  }
}
