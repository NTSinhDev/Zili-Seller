part of '../fill_in_store_information_screen.dart';

class _FormInput extends StatefulWidget {
  final Function(String) onInputStoreOwner;
  final Function(String) onInputStoreNamed;
  final Function(Location) onInputStoreRegion;
  const _FormInput({
    required this.onInputStoreOwner,
    required this.onInputStoreNamed,
    required this.onInputStoreRegion,
  });

  @override
  State<_FormInput> createState() => _FormInputState();
}

class _FormInputState extends State<_FormInput> {
  final AuthRepository authRepository = di<AuthRepository>();
  bool validateEmail = true;
  String validatorPassword = '';
  String? province;
  String? district;
  String? town;
  late final StreamSubscription<Location> subscriptionProvince;
  late final StreamSubscription<Location> subscriptionDistrict;
  late final StreamSubscription<Location> subscriptionTown;

  @override
  void initState() {
    super.initState();
    subscriptionProvince =
        authRepository.storeProvinceStream.listen(onChooseRegion);
    subscriptionDistrict =
        authRepository.storeDistrictStream.listen(onChooseRegion);
    subscriptionTown = authRepository.storeTownStream.listen(onChooseRegion);
  }

  @override
  void dispose() {
    subscriptionProvince.cancel();
    subscriptionDistrict.cancel();
    subscriptionTown.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomInputFieldWidget(
          label: 'Họ và tên',
          hint: 'Nhập họ và tên của bạn',
          type: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          // color: !validateEmail ? AppColors.red : null,
          // notify: !validateEmail ? 'Tên cửa hàng không hợp lệ!' : null,
          onChanged: (storeOwner) {
            widget.onInputStoreOwner(storeOwner);
          },
        ),
        CustomInputFieldWidget(
          label: 'Tên cửa hàng',
          hint: 'Nhập tên cửa hàng',
          type: TextInputType.name,
          textCapitalization: TextCapitalization.words,
          // color: !validateEmail ? AppColors.red : null,
          // notify: !validateEmail ? 'Tên cửa hàng không hợp lệ!' : null,
          onChanged: (storeNamed) {
            widget.onInputStoreNamed(storeNamed);
          },
        ),
        CustomInputFieldWidget(
          onTap: () {
            authRepository.jumpToPageView(pageIndex: 3);
          },
          label: 'Khu vực',
          hint: handleValueRegion() ?? 'Chọn khu vực',
          textCapitalization: TextCapitalization.words,
          customStyleHint: handleValueRegion() != null
              ? AppStyles.text.medium(
                  fSize: 16.sp,
                  color: AppColors.primary,
                )
              : AppStyles.text.medium(
                  fSize: 14.sp,
                  color: AppColors.primary.withOpacity(0.7),
                ),
          suffixIcon: CustomIconStyle(
            icon: CupertinoIcons.chevron_right,
            style: AppStyles.text.medium(fSize: 16.sp),
          ),
        ),
      ],
    );
  }

  String? handleValueRegion() {
    if (province == null) return null;
    String valueDistrict = '';
    String valueTown = '';
    if (district != null) {
      valueDistrict = "$district, ";
    }
    if (town != null) {
      valueTown = "$town, ";
    }
    return "$valueTown$valueDistrict$province";
  }

  void onChooseRegion(Location location) {
    setState(() {
      if (location.levelEnum == LocationLevel.Province_City) {
        province = location.name;
      } else if (location.levelEnum == LocationLevel.District) {
        district = location.name;
      } else {
        town = location.name;
      }
    });
    widget.onInputStoreRegion(location);
  }

  // String _setValidatorPassword(String password) {
  //   if (password.length < 6) {
  //     return 'Mật khẩu phải có tối thiếu 6 kí tự';
  //   }
  //   if (password.length > 25) {
  //     return 'Mật khẩu có tối đa 25 kí tự!';
  //   }
  //   return '';
  // }
}
