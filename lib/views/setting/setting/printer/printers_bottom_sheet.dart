import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/entity/printer.dart';
import 'package:zili_coffee/data/repositories/setting_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/views/common/bottom_scaffold_button.dart';
import 'package:zili_coffee/views/setting/setting/printer/print_screen.dart';

import '../../../../res/res.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/widgets/widgets.dart';

class PrintersBottomSheet {
  void showPrintersBottomSheet(BuildContext context) {
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
      builder: (context) => PrintersSelector(),
    );
  }
}

class PrintersSelector extends StatefulWidget {
  const PrintersSelector({super.key});

  @override
  State<PrintersSelector> createState() => _PrintersSelectorState();
}

class _PrintersSelectorState extends State<PrintersSelector> {
  final SettingRepository repo = di<SettingRepository>();
  int? _selected;
  @override
  Widget build(BuildContext context) {
    return ColumnWidget(
      mainAxisSize: .min,
      children: [
        BottomSheetHeader(title: 'Chọn máy in', onClose: context.navigator.pop),
        StreamBuilder<List<Printer>>(
          stream: repo.printers.stream,
          builder: (context, asyncSnapshot) {
            final list = asyncSnapshot.data ?? [];
            return Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                padding: .symmetric(vertical: 16.h),
                itemCount: list.length,
                clipBehavior: .hardEdge,
                itemBuilder: (context, index) => PrinterContainerItem(
                  isSelected: _selected == index,
                  printer: list[index],
                  callBack: () {
                    setState(() {
                      _selected = index;
                    });
                  },
                ),
              ),
            );
          },
        ),
        BottomScaffoldButton(
          onTap: () {
            if (_selected != null) {
              context.navigator.push(
                MaterialPageRoute(
                  builder: (context) => PrintScreen(
                    printer: (repo.printers.valueOrNull ?? [])[_selected!],
                  ),
                ),
              );
            }
          },
          label: "Xác nhận",
        ),
      ],
    );
  }
}

class PrinterContainerItem extends StatelessWidget {
  final bool isSelected;
  final Printer printer;
  final VoidCallback callBack;
  const PrinterContainerItem({
    super.key,
    required this.printer,
    required this.isSelected,
    required this.callBack,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: printer.availabilityFuture,
      builder: (context, asyncSnapshot) {
        bool isAvailable = asyncSnapshot.data ?? false;

        return BottomSheetListItem(
          isDense: false,
          title: printer.name,
          leading: Stack(
            children: [
              Container(
                padding: .all(2),
                child: Icon(
                  Icons.print,
                  size: 24.r,
                  color: isAvailable ? AppColors.black3 : AppColors.grey84,
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  constraints: BoxConstraints(minWidth: 10.w, minHeight: 10.w),
                  padding: .all(2.r),
                  decoration: BoxDecoration(
                    color: isAvailable ? AppColors.success : Colors.white,
                    shape: .circle,
                    border: !isAvailable
                        ? Border.all(color: AppColors.grey84)
                        : null,
                  ),
                  child: Text(
                    !isAvailable ? '✖' : '',
                    style: AppStyles.text.medium(
                      fSize: 6.sp,
                      color: AppColors.grey84,
                    ),
                  ),
                ),
              ),
            ],
          ),
          disableTap: !isAvailable,
          isSelected: isSelected,
          onTap: isAvailable ? callBack : () {},
        );
      },
    );
  }
}
