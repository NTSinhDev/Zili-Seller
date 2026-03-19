part of "../orders_history_screen.dart";

class _InputOrderIDField extends StatelessWidget {
  const _InputOrderIDField();

  @override
  Widget build(BuildContext context) {
    final TextStyle style = AppStyles.text.semiBold(
      fSize: 16.sp,
      color: AppColors.beige,
    );
    return TextField(
      cursorColor: AppColors.beige,
      onChanged: (orderID) {},
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.search,
      scrollPadding: const EdgeInsets.all(0),
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: const EdgeInsets.all(0),
        hintText: "Nhập mã đơn cần tìm...",
        hintStyle: style.copyWith(
          fontSize: 14.sp,
          color: AppColors.beige.withOpacity(0.7),
        ),
      ),
      style: style,
    );
  }
}
