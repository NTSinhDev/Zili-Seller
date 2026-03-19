import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/helpers/permission_helper.dart';

import '../../bloc/collaborator/collaborator_cubit.dart';
import '../../bloc/customer/customer_cubit.dart';
import '../../bloc/setting/setting_cubit.dart';
import '../../data/repositories/collaborator_repository.dart';
import '../../data/repositories/customer_repository.dart';
import '../../data/repositories/order_repository.dart';
import '../../data/repositories/setting_repository.dart';
import '../../res/res.dart';
import '../../services/common_service.dart';
import '../../utils/widgets/widgets.dart';
import '../../views/loading/loading_screen.dart';
import '../../bloc/order/order_cubit.dart';
import '../../di/dependency_injection.dart';
import 'create_order/create_order_screen.dart';
import 'order_list/order_list_screen.dart';

class EntryOrderScreen extends StatelessWidget {
  const EntryOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ColumnWidget(
        backgroundColor: Colors.white,
        padding: .symmetric(horizontal: 20.w, vertical: 20.h),
        gap: 20.w,
        children: [
          _buildCreateOrderEntry(context),
          _buildOrderEntryList(context),
        ],
      ),
    );
  }

  Widget _buildOrderEntryList(BuildContext context) {
    Widget item(String title, IconData icon, String screenName) {
      return InkWell(
        onTap: () {
          if (screenName.isNotEmpty && screenName != '/' && context.mounted) {
            context.navigator.pushNamed(screenName);
          }
        },
        child: SizedBox(
          width: .infinity,
          child: ColumnWidget(
            padding: .symmetric(vertical: 20.h),
            backgroundColor: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: .circular(8.r),
            gap: 8.h,
            children: [
              Icon(icon, size: 24.sp, color: AppColors.primary),
              Text(title, style: AppStyles.text.medium(fSize: 14.sp)),
            ],
          ),
        ),
      );
    }

    return ColumnWidget(
      gap: 20.w,
      children: [
        RowWidget(
          gap: 20.w,
          children: [
            Expanded(
              child: item('Đơn hàng', Icons.receipt, OrderListScreen.keyName),
            ),
            Expanded(
              child: item(
                'Đơn nháp',
                Icons.edit_square,
                OrderListScreen.keyName,
              ),
            ),
          ],
        ),
        // RowWidget(
        //   gap: 20.w,
        //   children: [
        //     Expanded(child: item('Trả hàng', Icons.repartition_rounded, '')),
        //     Expanded(child: item('Vận đơn', Icons.local_shipping_rounded, '')),
        //   ],
        // ),
      ],
    );
  }

  Widget _buildCreateOrderEntry(BuildContext context) {
    if (!PermissionHelper.create(AbilitySubject.orderManagement)) {
      return const SizedBox.shrink();
    }

    final OrderCubit orderCubit = di<OrderCubit>();
    final OrderRepository orderRepository = di<OrderRepository>();
    final CustomerCubit customerCubit = di<CustomerCubit>();
    final CustomerRepository customerRepository = di<CustomerRepository>();
    final CollaboratorRepository collaboratorRepository =
        di<CollaboratorRepository>();
    final SettingRepository settingRepository = di<SettingRepository>();
    final SettingCubit settingCubit = di<SettingCubit>();
    final CommonService commonService = di<CommonService>();
    final CollaboratorCubit collaboratorCubit = di<CollaboratorCubit>();

    return InkWell(
      onTap: () {
        if (context.mounted) {
          // Build tasks list
          final tasks = <LoadingTask>[
            if (!orderRepository.warehousesHasValue)
              LoadingTask(
                name: 'Danh sách chi nhánh',
                loader: () async {
                  final warehouses = await commonService.loadWarehousesData();
                  return warehouses;
                },
                errorMessage: 'Không thể tải danh sách chi nhánh',
              ),
            if ((customerRepository.activeStaffs.valueOrNull ?? []).isEmpty)
              LoadingTask(
                name: 'Danh sách nhân viên',
                loader: () async {
                  final staffs = await customerCubit.getActiveStaffs(
                    aboutMe: true,
                  );
                  return staffs;
                },
                errorMessage: 'Không thể tải danh sách nhân viên',
              ),
            if (settingRepository.saleChannelsValue.isEmpty)
              LoadingTask(
                name: 'Danh sách kênh bán hàng',
                loader: () async {
                  final saleChannels = await settingCubit.getSaleChannels();
                  return saleChannels;
                },
                errorMessage: 'Không thể tải danh sách kênh bán hàng',
              ),
            if ((orderRepository.deliveryMethods.valueOrNull ?? []).isEmpty)
              LoadingTask(
                name: 'Danh sách phương thức giao hàng',
                loader: () async {
                  final deliveryMethods = await orderCubit.getDeliveryMethods();
                  return deliveryMethods;
                },
                errorMessage: 'Không thể tải danh sách phương thức giao hàng',
              ),
            if ((collaboratorRepository.collaborators.valueOrNull ?? [])
                .isEmpty)
              LoadingTask(
                name: 'Danh sách cộng tác viên',
                loader: collaboratorCubit.fetchCollaborators,
                errorMessage: 'Không thể tải danh sách cộng tác viên',
              ),
          ];

          // If no tasks, navigate directly to CreateOrderScreen
          if (tasks.isEmpty) {
            context.navigator.pushNamed(CreateOrderScreen.keyName);
            return;
          }

          // Show loading screen if there are tasks
          LoadingScreen.navigate(
            context,
            tasks: tasks,
            successRoute: CreateOrderScreen.keyName,
            loadingMessage: 'Đang chuẩn bị tạo đơn hàng...',
          );
        }
      },
      child: DottedBorder(
        color: AppColors.primary.withValues(alpha: 0.5),
        strokeWidth: 1.w,
        radius: .circular(5.r),
        dashPattern: const [4, 4, 4, 4],
        padding: .symmetric(horizontal: 20.w, vertical: 32.h),
        borderType: .RRect,
        
        child: SizedBox(
          width: .infinity,
          child: ColumnWidget(
            mainAxisAlignment: .center,
            gap: 10.h,
            children: [
              Container(
                padding: .all(8.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: .circle,
                ),
                child: Icon(Icons.add, size: 16.sp, color: AppColors.white),
              ),
              Text(
                'Tạo đơn hàng',
                style: AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
