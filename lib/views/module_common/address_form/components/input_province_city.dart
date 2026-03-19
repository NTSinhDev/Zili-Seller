import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/bloc/address/address_cubit.dart';
import 'package:zili_coffee/data/models/address/customer_address.dart';
import 'package:zili_coffee/data/models/address/location.dart';
import 'package:zili_coffee/data/repositories/address_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';

final _textInputStyle = AppStyles.text.medium(fSize: 14.sp);

class InputProvinceCity extends StatefulWidget {
  final AddressCubit cubit;
  final CustomerAddress? address;
  final Function(Location) changedProvinceCity;
  const InputProvinceCity({
    super.key,
    required this.changedProvinceCity,
    required this.cubit,
    this.address,
  });

  @override
  State<InputProvinceCity> createState() => _InputProvinceCityState();
}

class _InputProvinceCityState extends State<InputProvinceCity> {
  final addressRepo = di<AddressRepository>();
  String? province;

  @override
  void initState() {
    super.initState();
    province = widget.address?.province?.name;
  }

  @override
  Widget build(BuildContext context) {
    return CustomInputFieldWidget(
      onTap: () async {
        context.focus.unfocus();
        if (!addressRepo.provincesHasValue()) {
          await widget.cubit.getProvinces();
        }
        if (!mounted) return throw Exception("Lỗi mounted _InputProvinceCity");
        context.showDialogAddressData(
          title: "Tỉnh/Thành",
          address: widget.address,
          stream: addressRepo.provincesStream,

          onSelected: (location) {
            setState(() => province = location.name);
            widget.changedProvinceCity(location);
          },
        );
      },
      hint: province ?? 'Chọn Tỉnh/Thành',
      label: 'Tỉnh/Thành*',
      customStyleLabel: _textInputStyle.copyWith(fontSize: 16.sp),
      customStyleInput: _textInputStyle,
      color: AppColors.black,
      obscure: false,
      suffixIcon: CustomIconStyle(
        icon: CupertinoIcons.chevron_down,
        style: _textInputStyle.copyWith(fontSize: 16.sp),
      ),
    );
  }
}
