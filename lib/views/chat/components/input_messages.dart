part of '../chat_screen.dart';

class _InputMessages extends StatefulWidget {
  const _InputMessages();

  @override
  State<_InputMessages> createState() => _InputMessagesState();
}

class _InputMessagesState extends State<_InputMessages> {
  final inputController = TextEditingController();
  bool isVisible = true;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 20.h,
      left: 20.w,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w),
        width: Spaces.screenWidth(context) - 40.w,
        decoration: BoxDecoration(
          color: AppColors.lightGrey,
          borderRadius: BorderRadius.circular(56.r),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: isVisible,
              child: InkWell(
                onTap: () => _openImagePicker(context),
                child:
                    const Icon(CupertinoIcons.photo, color: AppColors.gray4B),
              ),
            ),
            width(width: 10),
            _Input(
              inputController: inputController,
              onchange: (message) {
                setState(() {
                  isVisible = message.isNotEmpty ? false : true;
                });
              },
              onSubmitted: _sendMessage,
            ),
            width(width: 10),
            InkWell(
              onTap: () => _sendMessage(inputController.text),
              child: const Icon(
                Icons.send_rounded,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (nContext) => PickerWidget(
        sendFiles: (selectedList) {
          // TODO: xử lý logic gửi file media tại đây
        },
      ),
    );
  }

  Future _openCamera() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;

      if (!mounted) return;
      // TODO: xử lý logic gửi file media tại đây
    } on PlatformException catch (e) {
      log('Pick image failed: $e');
    }
  }

  void _sendMessage(String message) {
    if (message.isEmpty) return;
    setState(() {
      isVisible = !isVisible;
    });
    inputController.clear();
  }
}

class _Input extends StatelessWidget {
  final Function(String)? onchange;
  final Function(String) onSubmitted;
  final TextEditingController inputController;
  const _Input({
    this.onchange,
    required this.inputController,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: TextField(
          maxLines: 4,
          minLines: 1,
          cursorColor: AppColors.primary,
          keyboardType: TextInputType.multiline,
          style: AppStyles.text.medium(fSize: 14.sp),
          controller: inputController,
          textCapitalization: TextCapitalization.sentences,
          textAlign: TextAlign.left,
          onSubmitted: onSubmitted,
          onChanged: onchange,
          decoration: InputDecoration(
            // contentPadding: EdgeInsets.only(bottom: 14.h),
            hintStyle: AppStyles.text.medium(
              fSize: 14.sp,
              color: AppColors.gray4B,
            ),
            border: InputBorder.none,
            hintText: 'Nội dung tin nhắn...',
          ),
        ),
      ),
    );
  }
}
