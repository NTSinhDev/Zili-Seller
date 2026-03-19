import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:zili_coffee/app/app_wireframe.dart';

import '../../../bloc/customer/customer_cubit.dart';
import '../../../data/models/user/customer_group.dart';
import '../../../data/repositories/customer_repository.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/extension/extension.dart';
import '../../../utils/functions/customer_functions.dart';
import '../../../utils/helpers/permission_helper.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../utils/enums/customer_enum.dart';
import '../../common/action_app_bar.dart';
import '../../common/empty_view_state.dart';
import '../../common/radio_button.dart';
import '../../common/shimmer_view.dart';
import '../create/create_screen.dart';

part 'components/customer_group_creation.dart';
part 'components/item_list_view.dart';

class CustomerGroupsScreen extends StatefulWidget {
  const CustomerGroupsScreen({super.key});
  static String keyName = '/customer-groups';

  @override
  State<CustomerGroupsScreen> createState() => _CustomerGroupsScreenState();
}

class _CustomerGroupsScreenState extends State<CustomerGroupsScreen> {
  final CustomerRepository _customerRepository = di<CustomerRepository>();
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  bool _isLoadMore = false;

  @override
  void initState() {
    super.initState();
    _customerCubit.getGroupCustomers();
  }

  Future<void> _onRefresh() async {
    if (_isLoadMore) return;
    await _customerCubit.getGroupCustomers(
      queryParameters: {'offset': 0, 'limit': 20},
    );
  }

  bool _onLoadMore() {
    if (_isLoadMore) return true;
    final groups = _customerRepository.customerGroups.valueOrNull;
    if (groups != null) {
      final records = groups.length;
      final maxRecords = _customerRepository.totalCustomerGroups;
      if (maxRecords == records) return true;
    }
    _isLoadMore = true;
    if (mounted) setState(() {});
    _customerCubit
        .loadMoreGroupCustomers({'offset': groups?.length ?? 0, 'limit': 20})
        .then((_) {
          _isLoadMore = false;
          if (mounted) setState(() {});
        });
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Nhóm khách hàng',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        actions: PermissionHelper.create(AbilitySubject.customerGroupManagement)
            ? [const _CustomerGroupCreationAction()]
            : [],
      ),
      resizeToAvoidBottomInset: true,
      body: CommonLoadMoreRefreshWrapper(
        onRefresh: _onRefresh,
        onLoadMore: _onLoadMore,
        minusMaxScrollValue: 100.h,
        child: StreamBuilder<List<CustomerGroup>>(
          stream: _customerRepository.customerGroups.stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == .waiting) {
              return const ShimmerView(type: .loadingIndicatorAtHead);
            }

            final items = snapshot.data ?? [];
            if (items.isEmpty) {
              return const EmptyViewState(
                message: 'Không tìm thấy phiên bản nhân xanh',
              );
            }
            return ListView.separated(
              itemCount: items.length + 2,
              separatorBuilder: (context, index) =>
                  index == items.length + 1 || index == 0
                  ? const SizedBox.shrink()
                  : Divider(color: AppColors.greyC0, height: 1.h),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    padding: .symmetric(horizontal: 16.w, vertical: 12.h),
                    color: AppColors.background,
                    child: Align(
                      alignment: .centerLeft,
                      child: Text(
                        '${_customerRepository.totalCustomerGroups} nhóm khách hàng',
                        style: AppStyles.text.medium(
                          fSize: 14.sp,
                          color: AppColors.grey84,
                        ),
                      ),
                    ),
                  );
                }
                if (index == items.length + 1) {
                  if (index < (_customerRepository.totalCustomerGroups)) {
                    return Padding(
                      padding: .all(20.w),
                      child: Center(
                        child: LoadingAnimationWidget.flickr(
                          leftDotColor: const Color(0xFF005C9D),
                          rightDotColor: const Color(0xFFE54925),
                          size: 36.w,
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }
                final item = items[index - 1];
                return _ItemListView(
                  item,
                  // onTap: () => AppWireFrame.navigateToCustomerGroupDetails(
                  //   context,
                  //   customerGroupId: item.id,
                  // ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
