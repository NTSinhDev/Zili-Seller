import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/res/res.dart';

class RadioTagListWidget extends StatefulWidget {
  final String? initialData;
  final List<String> options;
  final Function(int) onChanged;
  final List<String>? disableValue;

  const RadioTagListWidget({
    super.key,
    this.initialData,
    required this.options,
    this.disableValue,
    required this.onChanged,
  });

  @override
  State<RadioTagListWidget> createState() => _RadioTagListWidgetState();
}

class _RadioTagListWidgetState extends State<RadioTagListWidget> {
  int? _selectedIndex;

  @override
  void initState() {
    if (widget.initialData != null) {
      _selectedIndex = widget.options.indexOf(widget.initialData!);
    } else {
      _selectedIndex = null;
    }

    super.initState();
  }

  @override
  void didUpdateWidget(covariant RadioTagListWidget oldWidget) {
    if (widget.initialData != null) {
      _selectedIndex = widget.options.indexOf(widget.initialData!);
    } else {
      _selectedIndex = null;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      runSpacing: 8.w,
      spacing: 16.w,
      children: List.generate(widget.options.length, (index) {
        return CustomRadioButton(
          text: widget.options[index],
          index: index,
          isSelected: _selectedIndex == index,
          isDisable:
              widget.disableValue?.contains(widget.options[index]) ?? false,
          onTap: () {
            if (_selectedIndex == index) return;
            setState(() {
              _selectedIndex = index;
            });
            widget.onChanged(index);
          },
        );
      }),
    );
  }
}

class CustomRadioButton extends StatelessWidget {
  final String text;
  final int index;
  final bool isSelected;
  final bool isDisable;
  final VoidCallback onTap;

  const CustomRadioButton({
    super.key,
    required this.text,
    required this.index,
    required this.isSelected,
    this.isDisable = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isDisable ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDisable
              ? AppColors.greyC0
              : (isSelected ? AppColors.primary : AppColors.lightGrey),
          borderRadius: BorderRadius.circular(4).r,
          border: Border.all(
              color: isDisable ? AppColors.greyC0 : AppColors.primary),
        ),
        padding: REdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Text(
          text,
          style: AppStyles.text.medium(
              fSize: 14.sp,
              color: isSelected ? AppColors.white : AppColors.primary),
        ),
      ),
    );
  }
}
