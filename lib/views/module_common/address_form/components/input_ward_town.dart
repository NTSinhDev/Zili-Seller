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

class InputWardTown extends StatefulWidget {
  final AddressCubit cubit;
  final CustomerAddress? address;
  final Function(Location) changedDistrict;
  const InputWardTown({
    super.key,
    required this.changedDistrict,
    required this.cubit,
    this.address,
  });

  @override
  State<InputWardTown> createState() => _InputWardTownState();
}

class _InputWardTownState extends State<InputWardTown> {
  final addressRepo = di<AddressRepository>();
  String? ward;

  @override
  Widget build(BuildContext context) {
    ward = widget.address?.ward?.name;
    return CustomInputFieldWidget(
      onTap: () async {
        if (widget.address?.district == null) {
          return context.showDialogAddressData(
            title: "Phường/Xã",
            address: widget.address,
            stream: addressRepo.wardsStream,
            onSelected: (location) {},
            child: Center(
              child: Text(
                "Vui lòng chọn Quận/Huyện!",
                style: AppStyles.text.medium(fSize: 12.sp),
              ),
            ),
          );
        }
        await widget.cubit.getWards(widget.address!.district!).then((value) {
          context.showDialogAddressData(
            title: "Phường/Xã",
            address: widget.address,
            stream: addressRepo.wardsStream,
            onSelected: (location) {
              setState(() => ward = location.name);
              widget.changedDistrict(location);
            },
          );
        });
      },
      hint: ward ?? 'Nhập Phường/Xã',
      label: 'Phường/Xã*',
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
