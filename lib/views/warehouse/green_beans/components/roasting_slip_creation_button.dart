part of '../green_beans_screen.dart';

class _RoastingSlipCreationAction extends StatelessWidget {
  const _RoastingSlipCreationAction();

  void _loadingDataBeforeNavigate(BuildContext context) {
    di<CommonService>().loadWarehousesData();
    context.navigator.pushNamed(RoastingSlipCreateScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return ActionAppBarIcon(
      icon: Icons.add,
      color: AppColors.primary,
      circleFrame: true,
      onTap: () => _loadingDataBeforeNavigate(context),
      onLongPress: () {},
    );
  }
}
