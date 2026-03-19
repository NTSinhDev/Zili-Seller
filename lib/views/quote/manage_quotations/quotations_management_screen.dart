import 'package:flutter/material.dart';

import '../../../app/app_wireframe.dart';
import '../../../res/res.dart';
import '../../../utils/widgets/widgets.dart';
import '../../common/action_app_bar.dart';
import 'quotations_management_list.dart';

class QuotationsManagementScreen extends StatelessWidget {
  const QuotationsManagementScreen({super.key});
  static String keyName = '/quotations-management';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(
        context,
        label: 'Quản lý phiếu báo giá',
        elevation: 1,
        shadowColor: AppColors.black.withValues(alpha: 0.5),
        actions: [
          ActionAppBarIcon(
            icon: Icons.post_add,
            onTap: () => AppWireFrame.navigateToQuotationCreation(context),
          ),
        ],
      ),
      body: QuotationsManagementView(),
    );
  }
}
