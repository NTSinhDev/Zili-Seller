part of '../change_information_screen.dart';

class _GroupRadioGender extends StatefulWidget {
  final Gender? gender;
  final Function(Gender) changedGender;
  const _GroupRadioGender({required this.gender, required this.changedGender});

  @override
  State<_GroupRadioGender> createState() => __GroupRadioGenderState();
}

class __GroupRadioGenderState extends State<_GroupRadioGender> {
  Gender? gender;
  @override
  void initState() {
    super.initState();
    gender = widget.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _radioItem(label: 'Nam', value: Gender.male),
        width(width: 30),
        _radioItem(label: 'Nữ', value: Gender.female),
        width(width: 30),
        _radioItem(label: 'Khác', value: Gender.other),
      ],
    );
  }

  Widget _radioItem({required String label, required Gender value}) {
    return Row(
      children: [
        InkWell(
          onTap: () {
            if (gender == value) return;
            setState(() {
              gender = value;
            });
            widget.changedGender(gender!);
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: CustomRadioBtnWidget(isActive: gender == value),
          ),
        ),
        width(width: 8),
        Text(
          label,
          style: AppStyles.text.medium(fSize: 14.sp),
        )
      ],
    );
  }
}
