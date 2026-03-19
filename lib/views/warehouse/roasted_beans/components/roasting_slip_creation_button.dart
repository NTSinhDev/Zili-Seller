part of '../roasted_beans_screen.dart';

class _RoastingSlipCreationAction extends StatelessWidget {
  const _RoastingSlipCreationAction();

  void _loadingDataBeforeNavigate(BuildContext context) {
    if (context.mounted) {
      final CommonService commonService = di<CommonService>();
      final WarehouseRepository warehouseRepository = di<WarehouseRepository>();

      // Build tasks list
      final tasks = <LoadingTask>[
        if (!warehouseRepository.warehousesHasValue)
          LoadingTask(
            name: 'Danh sách chi nhánh',
            errorMessage: 'Không thể tải danh sách chi nhánh',
            loader: () async => await commonService.loadWarehousesData(),
          ),
      ];

      // If no tasks, navigate directly to RoastingSlipCreateScreen
      if (tasks.isEmpty) {
        context.navigator.pushNamed(RoastingSlipCreateScreen.routeName);
        return;
      }

      // Show loading screen if there are tasks
      LoadingScreen.navigate(
        context,
        tasks: tasks,
        successRoute: RoastingSlipCreateScreen.routeName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ActionAppBarIcon(
      icon: Icons.add,
      color: AppColors.primary,
      circleFrame: true,
      onTap: () => _loadingDataBeforeNavigate(context),
    );
  }
}
