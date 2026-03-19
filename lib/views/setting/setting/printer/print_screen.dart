import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/data/entity/printer.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/services/common_service.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/views/common/bottom_scaffold_button.dart';

import '../../../../res/res.dart';
import '../../../../utils/widgets/widgets.dart';
import '../../../common/selector_form_field.dart';

class PrintScreen extends StatefulWidget {
  final Printer printer;
  const PrintScreen({super.key, required this.printer});

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  File? _file;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: widget.printer.name,
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      extendBody: true,
      body: ColumnWidget(
        padding: .symmetric(horizontal: 20.w, vertical: 16.h),
        gap: 20.h,
        children: [
          AbsorbPointer(
            absorbing: true,
            child: SelectorFormField<String>(
              label: 'Máy in',
              hintOrValue: widget.printer.name,
              selected: widget.printer.name,
              disabled: true,
              options: [widget.printer.name],
              renderValue: (value, onTap) => BottomSheetListItem(
                isDense: false,
                title: widget.printer.name,
                isSelected: true,
                onTap: onTap,
              ),
              onSelected: (_) {},
            ),
          ),
          OpenBottomSheetListButton(
            label: 'Tài liệu in',
            placeholder:
                _file?.path.split("/").lastOrNull ?? "Chọn tài liệu in",
            onTap: () async {
              final file = await pickDocumentFile();
              if (file != null) {
                _file = file;
                setState(() {});
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: BottomScaffoldButton(
        onTap: () {
          if (_file != null) {
            context.showLoading();
            di<CommonService>()
                .requestPrintFile(file: _file!, printer: widget.printer)
                .then((result) {
                  if (context.mounted) {
                    context.hideLoading();
                    if (result == true) {
                      showNoticeDialog(
                        context: context,
                        title: "Đã gửi yêu cầu in",
                        variant: .success,
                        message:
                            "Đã gửi yêu cầu in tệp tài liệu ${_file!.path.split("/").last} đến server.",
                      );
                    }
                  }
                });
          }
        },
        label: "In tài liệu",
      ),
    );
  }

  Future<File?> pickDocumentFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return null;
    final path = result.files.single.path;
    if (path == null) return null;

    return File(path);
  }
}
