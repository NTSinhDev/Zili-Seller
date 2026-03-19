import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_filex/open_filex.dart';
import 'package:external_path/external_path.dart';
import 'package:file_saver/file_saver.dart';
import 'package:zili_coffee/services/common_service.dart';

import '../../../../app/app_wireframe.dart';
import '../../../../data/models/quotation/quotation.dart';
import '../../../../di/dependency_injection.dart';
import '../../../../res/res.dart';
import '../../../../utils/enums.dart';
import '../../../../utils/enums/order_enum.dart';
import '../../../../utils/extension/extension.dart';
import '../../../../utils/helpers/crash_logger.dart';
import '../../../../utils/helpers/permission_helper.dart';
import '../../../../utils/widgets/widgets.dart';

enum _ActionType { copy, export, share, edit }

class TopActionView extends StatelessWidget {
  final Quotation? quotation;
  final bool isQuoteOwner;
  final bool isAccountant;
  const TopActionView({
    super.key,
    this.quotation,
    required this.isQuoteOwner,
    required this.isAccountant,
  });

  List<_ActionType> get _actions {
    final actions = <_ActionType>[];

    if (isQuoteOwner &&
        PermissionHelper.edit(AbilitySubject.quotationManagement)) {
      actions.add(_ActionType.copy);
      if (quotation?.quotationStatus == QuoteStatus.approved.toConstant) {
        actions.add(_ActionType.share);
      }
    }

    if ((isQuoteOwner || isAccountant) &&
        PermissionHelper.edit(AbilitySubject.quotationManagement) &&
        quotation?.quotationStatus == QuoteStatus.approved.toConstant) {
      actions.add(_ActionType.export);
    }

    if ((isAccountant) &&
        quotation?.quotationStatus == QuoteStatus.pending.toConstant &&
        PermissionHelper.edit(AbilitySubject.quotationManagement)) {
      actions.add(_ActionType.edit);
    }

    return actions;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_ActionType>(
      icon: const Icon(Icons.more_vert),
      padding: .zero,
      constraints: BoxConstraints(minWidth: 150.w, minHeight: 0),
      onSelected: (_ActionType action) async {
        switch (action) {
          case .copy:
            AppWireFrame.navToQuotationCreation(quotation);
            break;
          case .export:
            if ((quotation?.pdfUrl).isNull) return;
            _downloadQuotationPdf(context.showLoading, (file) {
              context.hideLoading();
              CustomSnackBarWidget(
                context,
                message: 'Xuất file báo giá thành công!',
                type: .success,
              ).show();
              OpenFilex.open(file.path);
            });
            break;
          case .share:
            if ((quotation?.imageUrl).isNull) return;
            _showShareOptions(context);
            break;
          case .edit:
            if (quotation != null) {
              AppWireFrame.navToQuotationEdition(quotation!);
            }
            break;
        }
      },
      itemBuilder: (context) {
        return _actions.map((action) {
          return PopupMenuItem<_ActionType>(
            value: action,
            height: 36.h,
            child: Row(
              children: [
                Icon(
                  _iconOf(action),
                  color: _colorOf(action, context),
                  size: 16.sp,
                ),
                const SizedBox(width: 12),
                Text(
                  _labelOf(action),
                  style: AppStyles.text.medium(
                    fSize: 14.sp,
                    color: AppColors.black3,
                  ),
                ),
              ],
            ),
          );
        }).toList();
      },
    );
  }

  Future<void> _downloadQuotationPdf(
    Function() setLoading, [
    Function(XFile file)? callBack,
  ]) async {
    try {
      final dirPath = Platform.isIOS
          ? await getApplicationDocumentsDirectory()
          : await ExternalPath.getExternalStoragePublicDirectory(
              Platform.isAndroid
                  ? ExternalPath.DIRECTORY_DOWNLOAD
                  : ExternalPath.DIRECTORY_DOCUMENTS,
            );
      final filePath = '$dirPath/Báo giá ${quotation!.quotationCode}.pdf';
      final file = File(filePath);
      final isFileExists = await file.exists();
      if (isFileExists) {
        callBack?.call(XFile(filePath));
      } else {
        setLoading();
        final url = quotation!.pdfUrl!;
        final dio = Dio();
        final response = await dio.get<List<int>>(
          url,
          options: Options(responseType: ResponseType.bytes),
        );
        if (Platform.isAndroid) {
          await file.writeAsBytes(response.data!);
          callBack?.call(XFile(filePath));
        } else {
          await FileSaver.instance.saveFile(
            name: 'Báo giá ${quotation!.quotationCode}.pdf',
            bytes: Uint8List.fromList(response.data!),
            mimeType: MimeType.pdf,
          );
          callBack?.call(XFile(filePath));
        }
      }
    } catch (e) {
      CrashLogger.tryToRecordError(
        'Không thể tải tệp',
        error: e,
        stackTrace: .current,
      );
    }
  }

  void _showShareOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: .vertical(top: .circular(20.r)),
      ),
      isScrollControlled: true,
      builder: (context) => SafeArea(
        child: ColumnWidget(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomSheetHeader(
              title: 'Chọn phương thức gửi báo giá',
              onClose: context.navigator.pop,
            ),
            const SizedBox(height: 8),
            // ColumnWidget(
            //   padding: .symmetric(horizontal: 20.w),
            //   crossAxisAlignment: .start,
            //   mainAxisSize: .min,
            //   gap: 4.h,
            //   children: [
            //     Text(
            //       "Vui lòng chọn cách bạn muốn gửi báo giá đến khách hàng.",
            //       style: AppStyles.text.medium(
            //         fSize: 12.sp,
            //         color: AppColors.grey84,
            //         height: 14 / 12,
            //       ),
            //     ),
            //     // Text(
            //     //   "Mọi hình thức gửi đều được hệ thống ghi nhận để đảm bảo tính chính xác và minh bạch.",
            //     //   style: AppStyles.text.medium(
            //     //     fSize: 12.sp,
            //     //     height: 14 / 12,
            //     //     color: AppColors.grey84,
            //     //   ),
            //     // ),
            //   ],
            // ),
            BottomSheetListItem(
              isDense: true,
              leading: Icon(Icons.email_outlined, color: AppColors.grey84),
              title: "Gửi báo giá qua email",
              onTap: () {
                if ((quotation?.code).isNull) return;
                context.showLoading();
                di<CommonService>().sendQuotationByMail(quotation!.code!).then((
                  result,
                ) {
                  if (context.mounted) {
                    context.hideLoading();
                    if (result) {
                      CustomSnackBarWidget(
                        context,
                        message: "Đã gửi báo giá đến Email khách hàng",
                        type: .success,
                      ).show();
                    } else {
                      CustomSnackBarWidget(
                        context,
                        message: "Gửi báo giá đến Email khách hàng thất bại!",
                        type: .error,
                      ).show();
                    }
                    context.navigator.maybePop();
                  }
                });
              },
            ),
            BottomSheetListItem(
              isDense: true,
              leading: Icon(Icons.link, color: AppColors.grey84),
              title: "Sử dụng đường dẫn",
              trailing: Text.rich(
                TextSpan(
                  text: "Xem trước",
                  style: AppStyles.text.semiBold(
                    fSize: 12.sp,
                    color: Colors.blue,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      launchUrl(Uri.parse(quotation!.pdfUrl!));
                    },
                ),
              ),
              onTap: () async {
                try {
                  Clipboard.setData(
                    ClipboardData(text: quotation!.pdfUrl!),
                  ).then((_) {
                    if (context.mounted) {
                      context.navigator.maybePop();
                      CustomSnackBarWidget(
                        context,
                        message: 'Đã copy đường dẫn',
                        type: .success,
                      ).show();
                      final params = ShareParams(
                        text: quotation!.pdfUrl,
                        subject: 'Báo giá từ Zili Coffee',
                      );
                      SharePlus.instance.share(params);
                    }
                  });
                } catch (_) {}
              },
            ),
            BottomSheetListItem(
              isDense: true,
              leading: Icon(Icons.share, color: AppColors.grey84),
              title: "Chia sẻ qua ứng dụng",
              onTap: () async {
                try {
                  if ((quotation?.pdfUrl).isNull) return;

                  _downloadQuotationPdf(context.showLoading, (file) {
                    context.hideLoading();
                    final params = ShareParams(
                      files: [file],
                      subject: 'Báo giá từ Zili Coffee',
                    );
                    SharePlus.instance.share(params);
                    context.navigator.maybePop();
                  });
                } catch (_) {}
              },
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  IconData _iconOf(_ActionType action) {
    switch (action) {
      case _ActionType.copy:
        return Icons.copy;
      case _ActionType.export:
        return Icons.file_download;
      case _ActionType.share:
        return Icons.share;
      case _ActionType.edit:
        return Icons.edit;
    }
  }

  Color _colorOf(_ActionType action, BuildContext context) {
    switch (action) {
      case _ActionType.copy:
        return AppColors.black5;
      case _ActionType.export:
        return AppColors.black5;
      case _ActionType.share:
        return AppColors.black5;
      case _ActionType.edit:
        return AppColors.black5;
    }
  }

  String _labelOf(_ActionType action) {
    switch (action) {
      case _ActionType.copy:
        return 'Sao chép';
      case _ActionType.export:
        return 'Xuất file';
      case _ActionType.share:
        return 'Chia sẻ';
      case _ActionType.edit:
        return 'Chỉnh sửa';
    }
  }
}
