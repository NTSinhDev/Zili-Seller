import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../bloc/packing_slip/packing_slip_cubit.dart';
import '../../../../../bloc/packing_slip/packing_slip_state.dart';
import '../../../../../data/models/warehouse/packing_slip_item.dart';
import '../../../../../di/dependency_injection.dart';
import '../../../../../res/res.dart';
import '../../../../../utils/extension/extension.dart';
import '../../../../../utils/formatters/export.dart';
import '../../../../../utils/widgets/widgets.dart';
import '../../../../common/input_form_field.dart';
import '../../../../common/note_input_field.dart';

class CompletePackingBottomSheet extends StatefulWidget {
  final PackingSlipDetailItem item;
  final VoidCallback onRefresh;
  const CompletePackingBottomSheet({
    super.key,
    required this.item,
    required this.onRefresh,
  });

  @override
  State<CompletePackingBottomSheet> createState() =>
      _CompletePackingBottomSheetState();
}

class _CompletePackingBottomSheetState
    extends State<CompletePackingBottomSheet> {
  final PackingSlipCubit _cubit = di<PackingSlipCubit>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormFieldState> _quantityFieldKey =
      GlobalKey<FormFieldState>();
  late final TextEditingController _quantityController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
    _noteController = TextEditingController();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final estimatedQuantity = widget.item.quantity;
    final measureUnit = widget.item.measureUnit ?? 'Túi';

    return BlocListener<PackingSlipCubit, PackingSlipState>(
      bloc: _cubit,
      listener: (context, state) {
        if (state is PackingSlipLoading &&
            state.action == PackingSlipAction.completePacking) {
          context.showLoading();
        } else if (state is PackingSlipSuccess &&
            state.action == PackingSlipAction.completePacking) {
          context.hideLoading();
          context.navigator.pop();
          widget.onRefresh();
        } else if (state is PackingSlipFailure &&
            state.action == PackingSlipAction.completePacking) {
          context.hideLoading();
          final messenger = ScaffoldMessenger.of(context);
          String message = 'Không thể hoàn thành phiếu đóng gói!';
          messenger.showSnackBar(
            SnackBar(
              backgroundColor: AppColors.white,
              elevation: 1,
              duration: const Duration(seconds: 2),
              content: RowWidget(
                gap: 8.w,
                children: [
                  Container(
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: AppColors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 16.sp,
                      color: AppColors.green,
                    ),
                  ),
                  Text(
                    message,
                    style: AppStyles.text.medium(
                      fSize: 14.sp,
                      color: AppColors.green,
                    ),
                  ),
                ],
              ),
              action: SnackBarAction(
                label: 'Đóng',
                textColor: AppColors.black5,
                onPressed: () => messenger.clearSnackBars(),
              ),
            ),
          );
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: .only(bottom: MediaQuery.of(context).viewPadding.bottom),
          child: ColumnWidget(
            children: [
              BottomSheetHeader(
                title: 'Hoàn thành đóng gói',
                onClose: context.navigator.pop,
              ),
              Form(
                key: _formKey,
                child: ColumnWidget(
                  padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                  gap: 20.h,
                  children: [
                    // Thông tin đơn vị tính và số lượng tạm tính
                    ColumnWidget(
                      crossAxisAlignment: .start,
                      gap: 12.h,
                      children: [
                        RowWidget(
                          gap: 4.w,
                          children: [
                            Text(
                              'Đơn vị tính:',
                              style: AppStyles.text.medium(
                                fSize: 14.sp,
                                color: AppColors.black3,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                measureUnit,
                                style: AppStyles.text.semiBold(
                                  fSize: 14.sp,
                                  color: AppColors.black3,
                                ),
                              ),
                            ),
                          ],
                        ),
                        RowWidget(
                          gap: 4.w,
                          children: [
                            Text(
                              'Số lượng tạm tính:',
                              style: AppStyles.text.medium(
                                fSize: 14.sp,
                                color: AppColors.black3,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                estimatedQuantity.toString(),
                                style: AppStyles.text.semiBold(
                                  fSize: 14.sp,
                                  color: AppColors.black3,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Input số lượng thực tế
                    InputFormField(
                      formFieldKey: _quantityFieldKey,
                      controller: _quantityController,
                      label: 'Số lượng thực tế',
                      hint: 'Nhập số lượng',
                      type: decimalInputType(),
                      inputFormatters: decimalInputFormatter(),
                      validator: (value) {
                        final text = value?.trim() ?? '';
                        if (text.isEmpty) {
                          return 'Vui lòng nhập số lượng thực tế';
                        }
                        final parsed = NumExt.tryParseComma(text);
                        if (parsed == null) {
                          return 'Số lượng không hợp lệ!';
                        }
                        if (parsed <= 0) {
                          return 'Số lượng phải lớn hơn 0';
                        }
                        if (parsed > estimatedQuantity) {
                          return 'Số lượng không được vượt quá số lượng tạm tính (${estimatedQuantity.toString()})';
                        }
                        return null;
                      },
                    ),
                    // Input ghi chú
                    NoteInputField(
                      controller: _noteController,
                      labelText: 'Ghi chú',
                      hintText: 'Ghi chú',
                    ),
                    // Buttons
                    RowWidget(
                      gap: 12.w,
                      margin: .only(top: 8.h),
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: context.navigator.pop,
                            style: OutlinedButton.styleFrom(
                              padding: .symmetric(vertical: 12.h),
                              side: const BorderSide(color: AppColors.grayEA),
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(8.r),
                              ),
                            ),
                            child: Text(
                              'Hủy',
                              style: AppStyles.text.medium(
                                fSize: 14.sp,
                                color: AppColors.black3,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _handleSubmit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: .symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: .circular(8.r),
                              ),
                              elevation: 0,
                            ),
                            child: Text(
                              'Xác nhận',
                              style: AppStyles.text.semiBold(
                                fSize: 14.sp,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() {
    final isQuantityValid = _quantityFieldKey.currentState?.validate() ?? false;
    if (!isQuantityValid) return;

    final parsedQuantity =
        NumExt.tryParseComma(_quantityController.text.trim()) ?? 0.0;
    final note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    _cubit.completePackingSlip(
      slipItemId: widget.item.id,
      actualQuantity: parsedQuantity.toDouble(),
      note: note,
    );
  }
}
