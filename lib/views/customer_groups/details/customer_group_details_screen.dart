import 'package:flutter/material.dart';
import '../../../res/res.dart';
import '../../../utils/widgets/widgets.dart';
import './information_view.dart';

class CustomerGrDetailsScreen extends StatefulWidget {
  const CustomerGrDetailsScreen({super.key, required this.customerId});
  final String customerId;
  static const String routeName = '/customer-group/details';

  @override
  State<CustomerGrDetailsScreen> createState() =>
      _CustomerGrDetailsScreenState();
}

class _CustomerGrDetailsScreenState extends State<CustomerGrDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Chi tiết nhóm khách hàng',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
      ),
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: true,
      extendBody: true,
      body: InformationView(),
    );
  }
}
