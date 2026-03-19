part of "../order_details_screen.dart";

class _OrderStatus extends StatefulWidget {
  const _OrderStatus();

  @override
  State<_OrderStatus> createState() => _OrderStatusState();
}

class _OrderStatusState extends State<_OrderStatus> {
  int statePosition = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _statusComp(
          label: "Tạo đơn",
          position: 0,
          onChangedStatus: () {
            context.showCustomDialog(
              height: 166.h,
              barrierColor: Colors.black38,
              canDismiss: false,
              backgroundColor: AppColors.white,
              child: UINotificationProvider.common(
                context,
                title: 'Chuyển trạng thái đơn hàng',
                content:
                    '''Xác nhận chuyển trạng đơn hàng này thành "tạo đơn"?''',
                leftButton: 'Hủy',
                rightButton: 'Xác nhận',
                onTap: () {},
              ),
            );
            setState(() {
              statePosition = 0;
            });
          },
        ),
        const Icon(
          Icons.chevron_right_sharp,
          color: AppColors.primary,
        ),
        _statusComp(
          label: "Thực hiện",
          position: 1,
          onChangedStatus: () {
            context.showCustomDialog(
              height: 166.h,
              barrierColor: Colors.black38,
              canDismiss: false,
              backgroundColor: AppColors.white,
              child: UINotificationProvider.common(
                context,
                title: 'Chuyển trạng thái đơn hàng',
                content:
                    '''Xác nhận chuyển trạng đơn hàng này thành "thực hiện"?''',
                leftButton: 'Hủy',
                rightButton: 'Xác nhận',
                onTap: () {},
              ),
            );
            setState(() {
              statePosition = 1;
            });
          },
        ),
        const Icon(
          Icons.chevron_right_sharp,
          color: AppColors.primary,
        ),
        _statusComp(
          label: "Hoàn thành",
          position: 2,
          onChangedStatus: () {
            context.showCustomDialog(
              height: 166.h,
              barrierColor: Colors.black38,
              canDismiss: false,
              backgroundColor: AppColors.white,
              child: UINotificationProvider.common(
                context,
                title: 'Chuyển trạng thái đơn hàng',
                content:
                    '''Xác nhận chuyển trạng đơn hàng này thành "hoàn thành"?''',
                leftButton: 'Hủy',
                rightButton: 'Xác nhận',
                onTap: () {},
              ),
            );
            setState(() {
              statePosition = 2;
            });
          },
        ),
      ],
    );
  }

  Widget _statusComp({
    required String label,
    required int position,
    Function()? onChangedStatus,
  }) {
    return Container(
      width: 78.w,
      height: 30.h,
      alignment: Alignment.center,
      decoration: statePosition == position
          ? BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(15.r),
              border: Border.all(color: AppColors.primary),
            )
          : null,
      child: Text(
        label,
        style: AppStyles.text.medium(
          fSize: 13.sp,
          color: statePosition == position ? AppColors.white : null,
        ),
      ),
    );
  }
}
