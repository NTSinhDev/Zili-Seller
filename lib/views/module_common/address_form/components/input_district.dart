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

class InputDistrict extends StatefulWidget {
  final AddressCubit cubit;
  final CustomerAddress? address;
  final Function(Location) changedDistrict;
  const InputDistrict({
    super.key,
    required this.changedDistrict,
    required this.cubit,
    this.address,
  });

  @override
  State<InputDistrict> createState() => _InputDistrictState();
}

class _InputDistrictState extends State<InputDistrict> {
  final addressRepo = di<AddressRepository>();
  String? district;

  @override
  Widget build(BuildContext context) {
    district = widget.address?.district?.name;
    return CustomInputFieldWidget(
      onTap: () async {
        if (widget.address?.province == null) {
          return context.showDialogAddressData(
            title: "Quận/Huyện",
            address: widget.address,
            stream: addressRepo.districtsStream,
            onSelected: (location) {},
            child: Center(
              child: Text(
                "Vui lòng chọn Tỉnh/Thành!",
                style: AppStyles.text.medium(fSize: 12.sp),
              ),
            ),
          );
        }
        await widget.cubit
            .getDistricts(widget.address!.province!)
            .then((value) {
          context.showDialogAddressData(
            title: "Quận/Huyện",
            address:  widget.address,
            stream: addressRepo.districtsStream,
            onSelected: (location) {
              setState(() => district = location.name);
              widget.changedDistrict(location);
            },
          );
        });
      },
      hint: district ?? 'Nhập Quận/Huyện',
      label: 'Quận/Huyện*',
      textCapitalization: TextCapitalization.words,
      customStyleLabel: _textInputStyle.copyWith(fontSize: 16.sp),
      customStyleInput: _textInputStyle,
      color: AppColors.black,
      suffixIcon: CustomIconStyle(
        icon: CupertinoIcons.chevron_down,
        style: _textInputStyle.copyWith(fontSize: 16.sp),
      ),
    );
  }
}
