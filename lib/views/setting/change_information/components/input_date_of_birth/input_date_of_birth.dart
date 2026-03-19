part of '../../change_information_screen.dart';

class _InputDateOfBirth extends StatefulWidget {
  final DateTime? dateOfBirth;
  final Function(DateTime? dateOfBirth) onChangedDate;
  const _InputDateOfBirth({
    required this.onChangedDate,
    required this.dateOfBirth,
  });

  @override
  State<_InputDateOfBirth> createState() => _InputDateOfBirthState();
}

class _InputDateOfBirthState extends State<_InputDateOfBirth> {
  late final List<FocusNode> _focusNodes;
  late String _day;
  late String _month;
  late String _year;
  bool validator = true;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(3, (index) => FocusNode());
    _fetchDataDateOfBirth();
  }

  @override
  Widget build(BuildContext context) {
    return _frameInput(
      children: [
        Expanded(
          child: InkWell(
            onTap: () => _focusNodes[0].requestFocus(),
            child: Row(
              children: [
                width(width: 20),
                _InputDay(
                  onChangedDate: (day) {
                    _focusNodes[1].requestFocus();
                    _day = day;
                    _onSubmitDateOfBirth(_day, _month, _year);
                  },
                  focusNode: _focusNodes[0],
                  value: _day,
                ),
                _dateDivider(),
                _InputMonth(
                  onChangedMonth: (month) {
                    _focusNodes[2].requestFocus();
                    _month = month;
                    _onSubmitDateOfBirth(_day, _month, _year);
                  },
                  whenUnfocus: (currentNode) {
                    currentNode.unfocus();
                    _focusNodes[0].requestFocus();
                  },
                  focusNode: _focusNodes[1],
                  value: _month,
                ),
                _dateDivider(),
                _InputYear(
                  onChangedYear: (year) {
                    context.focus.unfocus();
                    _year = year;
                    _onSubmitDateOfBirth(_day, _month, _year);
                  },
                  whenUnfocus: (currentNode) {
                    currentNode.unfocus();
                    _focusNodes[1].requestFocus();
                  },
                  focusNode: _focusNodes[2],
                  value: _year,
                ),
              ],
            ),
          ),
        ),
        InkWell(
          onTap: () async => await _pickedDate(context),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 20.w,
              vertical: 12.w,
            ),
            child: Icon(
              Icons.calendar_month_outlined,
              color: Colors.black,
              size: 22.r,
            ),
          ),
        ),
      ],
    );
  }

  void _fetchDataDateOfBirth() {
    String fetchData(int? data, {int? padLeft}) {
      return data == null
          ? ''
          : padLeft != null
              ? data.toString().padLeft(padLeft, '0')
              : data.toString();
    }

    _day = fetchData(widget.dateOfBirth?.day, padLeft: 2);
    _month = fetchData(widget.dateOfBirth?.month, padLeft: 2);
    _year = fetchData(widget.dateOfBirth?.year);
  }

  void _onSubmitDateOfBirth(String day, String month, String year) {
    if (day.isEmpty || month.isEmpty || year.isEmpty) return;

    final DateTime dob = DateTime(
      int.parse(_year),
      int.parse(_month),
      int.parse(_day),
    );
    final bool val1 = int.parse(_day) == dob.day;
    final bool val2 = int.parse(_month) == dob.month;
    final bool val3 = DateTime.now().year - 100 <= dob.year &&
        dob.year <= DateTime.now().year;
    validator = val1 && val2 && val3;
    if (validator) {
      widget.onChangedDate(dob);
    }else{
      widget.onChangedDate(null);
    }
    setState(() {});
  }

  Future<void> _pickedDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    final DateTime firstDate = DateTime(DateTime.now().year - 100, 1, 1);
    if (_day.isNotEmpty && _month.isNotEmpty && _year.isNotEmpty) {
      try {
        initialDate = DateFormat("dd/MM/yyyy").parse("$_day/$_month/$_year");
        if (initialDate.isAfter(DateTime.now())) {
          initialDate = DateTime.now();
        } else if (initialDate.isBefore(firstDate)) {
          initialDate = firstDate;
        }
        // ignore: empty_catches
      } catch (e) {}
    }
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: DateTime.now(),
      fieldHintText: 'Ngày / Tháng / Năm',
      locale: const Locale('vi', 'VN'),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: Colors.red,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                textStyle: AppStyles.text.bold(
                  fSize: 16.sp,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        _day = pickedDate.day.toString().padLeft(2, '0');
        _month = pickedDate.month.toString().padLeft(2, '0');
        _year = pickedDate.year.toString();
      });
      widget.onChangedDate(pickedDate);
    }
  }

  Widget _dateDivider() =>
      Text('/', style: _textInputStyle.copyWith(color: AppColors.grey));

  Widget _frameInput({required List<Widget> children}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Ngày tháng năm sinh',
              style: AppStyles.text.medium(fSize: 16.sp),
            ),
            if (!validator)
              Padding(
                padding: EdgeInsets.only(right: 4.w),
                child: Text(
                  'Mốc thời gian không hợp lệ!',
                  style: AppStyles.text.medium(
                    fSize: 11.sp,
                    color: AppColors.scarlet,
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
          ],
        ),
        height(height: 10),
        Container(
          height: 55.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: validator ? AppColors.black : AppColors.red,
              width: 1.5.r,
            ),
            color: AppColors.white,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ],
    );
  }
}
