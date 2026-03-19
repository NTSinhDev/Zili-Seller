import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zili_coffee/bloc/app/app_cubit.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

import '../../../bloc/auth/auth_cubit.dart';
import '../../../utils/helpers/crash_logger.dart';

class UserAvatar extends StatelessWidget {
  final String? avatarURL;
  final Function()? callbackWhenChangeAvatar;
  const UserAvatar({
    super.key,
    required this.avatarURL,
    this.callbackWhenChangeAvatar,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      bloc: di<AppCubit>(),
      builder: (context, state) {
        String? avatar = avatarURL;
        if (state is AppReadyWithAuthenticationState) {
          avatar = state.user?.avatar;
        }
        return SizedBox(
          width: 94.w,
          height: 106.h,
          child: Stack(
            children: [
              Align(
                alignment: .topCenter,
                child: Container(
                  decoration: BoxDecoration(
                    shape: .circle,
                    color: AppColors.white,
                    border: avatar == null
                        ? Border.all(color: AppColors.primary)
                        : null,
                  ),
                  child: Stack(
                    children: [
                      if (avatar != null)
                        Align(
                          alignment: .center,
                          child: Icon(
                            Icons.person,
                            size: 56.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      Align(
                        alignment: .center,
                        child: CircleAvatar(
                          backgroundImage: avatar != null
                              ? CachedNetworkImageProvider(avatar)
                              : null,
                          radius: 48.r,
                          backgroundColor: Colors.transparent,
                          child: avatar == null
                              ? Icon(
                                  Icons.person,
                                  size: 56.sp,
                                  color: AppColors.primary,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: .bottomCenter,
                child: InkWell(
                  onTap: () => _updateAvatar(context),
                  child: Container(
                    padding: EdgeInsets.all(7.w),
                    decoration: BoxDecoration(
                      shape: .circle,
                      color: AppColors.white,
                      boxShadow: <BoxShadow>[
                        .new(
                          color: AppColors.black.withValues(alpha: 0.25),
                          offset: const Offset(0.0, 2.0),
                          blurRadius: 1.r,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _updateAvatar(BuildContext context) {
    context.showBottomSheet(
      child: LayoutModalBottomSheet.basic(
        children: [
          Text(
            'Thay đổi ảnh đại diện',
            style: AppStyles.text.semiBold(fSize: 16.sp),
          ),
          height(height: 24.h),
          InkWell(
            onTap: () async {
              try {
                await ImagePicker().pickImage(source: .camera).then((
                  XFile? image,
                ) {
                  if (image == null) return;

                  if (context.mounted) {
                    context.showLoading(message: "Cập nhật avatar");
                  }

                  final imageFile = File(image.path);

                  di<AuthCubit>().updateAvatar(file: imageFile).then((value) {
                    if (value.$1) {
                      if (context.mounted) {
                        context.hideLoading();
                        context.navigator.pop();
                      }
                    } else {
                      if (context.mounted) {
                        context.hideLoading();
                        context.showNotificationDialog(
                          title: "Cập nhật avatar",
                          message: value.$2,
                        );
                      }
                    }
                  });
                });
              } catch (e) {
                CrashLogger.tryToRecordError(
                  "Không thể sử dụng camera",
                  error: e,
                  stackTrace: StackTrace.current,
                );
                CustomSnackBarWidget(
                  context,
                  type: .error,
                  message: "Không thể sử dụng camera",
                ).show();
              }
            },
            child: Row(
              mainAxisAlignment: .start,
              children: [
                width(width: 64),
                Icon(
                  CupertinoIcons.camera_fill,
                  color: Colors.black,
                  size: 20.sp,
                ),
                width(width: 14),
                Text('Chụp ảnh', style: AppStyles.text.medium(fSize: 15.sp)),
                width(width: 20),
              ],
            ),
          ),
          height(height: 18.h),
          InkWell(
            onTap: () async {
              try {
                await ImagePicker().pickImage(source: .gallery).then((
                  XFile? image,
                ) {
                  if (image == null) return;

                  if (context.mounted) {
                    context.showLoading(message: "Cập nhật avatar");
                  }

                  final imageFile = File(image.path);

                  di<AuthCubit>().updateAvatar(file: imageFile).then((value) {
                    if (value.$1) {
                      if (context.mounted) {
                        context.hideLoading();
                        context.navigator.pop();
                      }
                    } else {
                      if (context.mounted) {
                        context.hideLoading();
                        context.showNotificationDialog(
                          title: "Cập nhật avatar",
                          message: value.$2,
                        );
                      }
                    }
                  });
                });
              } catch (e) {
                if (context.mounted) {
                  context.hideLoading();
                }
                CrashLogger.tryToRecordError(
                  "Không thể sử dụng thư viện",
                  error: e,
                  stackTrace: StackTrace.current,
                );
                CustomSnackBarWidget(
                  context,
                  type: .error,
                  message: "Không thể sử dụng thư viện",
                ).show();
              }
            },
            child: Row(
              mainAxisAlignment: .start,
              children: [
                width(width: 64),
                Icon(CupertinoIcons.photo, color: Colors.black, size: 20.sp),
                width(width: 14),
                Text(
                  'Tải lên từ thư viện',
                  style: AppStyles.text.medium(fSize: 15.sp),
                ),
                width(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void pickImage(BuildContext context, {required ImageSource source}) {
    try {
      ImagePicker().pickImage(source: source).then((XFile? image) {
        if (image == null) return;

        if (context.mounted) context.showLoading(message: "Cập nhật avatar");

        final imageFile = File(image.path);

        di<AuthCubit>().updateAvatar(file: imageFile).then((value) {
          if (value.$1) {
            context.hideLoading();
            context.navigator.pop();
          } else {
            context.hideLoading();
            context.showNotificationDialog(
              title: "Cập nhật avatar",
              message: value.$2,
            );
          }
        });
      });
    } on PlatformException catch (e) {
      log('Pick image failed: $e');
    }
  }
}
