part of '../roasting_slip_detail_screen.dart';

class _CancelBottomSheet extends StatefulWidget {
  final Function(String note) onSubmit;
  const _CancelBottomSheet({required this.onSubmit});

  @override
  State<_CancelBottomSheet> createState() => _CancelBottomSheetState();
}

class _CancelBottomSheetState extends State<_CancelBottomSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _noteController;

  @override
  void initState() {
    _noteController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: ColumnWidget(
          children: [
            BottomSheetHeader(
              title: 'Hủy phiếu rang',
              onClose: context.navigator.pop,
            ),
            Form(
              key: _formKey,
              child: ColumnWidget(
                padding: .symmetric(horizontal: 16.w, vertical: 16.h),
                gap: 20.h,
                children: [
                  NoteInputField(
                    controller: _noteController,
                    labelText: 'Lý do *',
                    hintText: 'Lý do',
                  ),
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
    );
  }

  void _handleSubmit() {
    final isNoteValid = _noteController.text.trim().isNotEmpty;
    if (!isNoteValid) return;
    final note = _noteController.text.trim();
    widget.onSubmit(note);
  }
}
