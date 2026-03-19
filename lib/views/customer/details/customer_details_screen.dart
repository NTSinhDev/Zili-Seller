import 'package:flutter/material.dart';

import '../../../bloc/customer/customer_cubit.dart';
import '../../../di/dependency_injection.dart';
import '../../../res/res.dart';
import '../../../utils/enums/customer_enum.dart';
import '../../../utils/widgets/widgets.dart';
import '../../../views/customer/details/debt_view.dart';
import '../../../views/customer/details/information_view.dart';
import '../../../views/customer/details/transaction_view.dart';
import '../../common/list_screen_template.dart';
import 'addresses_view.dart';

class CustomerDetailsScreen extends StatefulWidget {
  const CustomerDetailsScreen({super.key, required this.customerId});
  final String customerId;
  static const String routeName = '/customer/details';

  @override
  State<CustomerDetailsScreen> createState() => _CustomerDetailsScreenState();
}

class _CustomerDetailsScreenState extends State<CustomerDetailsScreen> {
  final CustomerCubit _customerCubit = di<CustomerCubit>();
  int _selectedTab = 0;
  CustomerDetailsScreenTab _selectedTabValue = .information;

  @override
  void initState() {
    super.initState();
    _customerCubit.getCustomerById(widget.customerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Chi tiết khách hàng',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        bottom: BaseFilterTabs(
          tabs: <TabConfig>[
            .new(
              label: 'Thông tin',
              value: CustomerDetailsScreenTab.information,
            ),
            .new(
              label: 'Giao dịch',
              value: CustomerDetailsScreenTab.transaction,
            ),
            .new(label: 'Công nợ', value: CustomerDetailsScreenTab.debt),
            .new(label: 'Địa chỉ', value: CustomerDetailsScreenTab.address),
          ],
          selectedTab: _selectedTab,
          onTabChanged: (index, value) => setState(() {
            _selectedTab = index;
            _selectedTabValue = value;
          }),
          showFilterButton: false,
        ),
      ),
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: Stack(
        fit: .expand,
        children: [
          InformationView(tabIndex: _selectedTabValue),
          TransactionView(
            tabIndex: _selectedTabValue,
            customerId: widget.customerId,
          ),
          DebtView(tabIndex: _selectedTabValue, customerId: widget.customerId),
          AddressesView(
            tabIndex: _selectedTabValue,
            customerId: widget.customerId,
          ),
        ],
      ),
    );
  }
}
