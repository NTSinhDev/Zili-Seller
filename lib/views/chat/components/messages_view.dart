part of '../chat_screen.dart';

class _MessagesView extends StatelessWidget {
  const _MessagesView();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      reverse: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (int index = 0; index < 3; index++) ...[
            if (index == 0)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  height(height: 20.h),
                  const _SuggestedMessage(
                    suggestedMsg: 'Zili coffe có đang truyển dụng không ạ?',
                  ),
                  const _SuggestedMessage(
                    suggestedMsg:
                        'Mình muốn hỏi về thông tin sản phẩm dòng cà phê truyền thống ạ?',
                  ),
                  const _SuggestedMessage(
                    suggestedMsg:
                        'Mình muốn đặt hàng dòng cà phê cho quán 10kg sao ạ?',
                  ),
                ],
              )
            else
              _MessageItem(
                messages: [
                  MessageFake(
                    msg:
                        'Mình muốn hỏi thông tin sản phẩm dòng cà phê truyền thống ạ?',
                    type: MessageType.user,
                  ),
                  MessageFake(
                    msg:
                        'xin chao! cảm ơn bạn đã quan tâm đến sản phẩm của chúng tôi. Chúng tôi có thể giúp gì cho bạn ạ.',
                    type: MessageType.admin,
                  ),
                ],
              ),
            if (index == 0 || index == 2)
              height(height: 54)
            else
              _dividerByTime(context)
          ]
        ],
      ),
    );
  }

  Widget _dividerByTime(BuildContext context) {
    return Container(
      width: Spaces.screenWidth(context),
      margin: EdgeInsets.only(bottom: 28.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
              child: Divider(
            color: AppColors.lightGrey,
            height: 1.h,
            thickness: 1.sp,
          )),
          width(width: 5),
          Text(
            '12:45  15/06/2023',
            style: AppStyles.text.medium(
              fSize: 12.sp,
              color: const Color(0xFF7C7C7C),
            ),
          ),
          width(width: 5),
          Expanded(
              child: Divider(
            color: AppColors.lightGrey,
            height: 1.h,
            thickness: 1.sp,
          )),
        ],
      ),
    );
  }
}

class _MessageItem extends StatelessWidget {
  final List<MessageFake> messages;
  const _MessageItem({required this.messages});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch, // fill width
        children: messages
            .map(
              (message) => Container(
                margin: EdgeInsets.only(bottom: 28.h),
                child: MessageWidget(type: message.type, message: message.msg),
              ),
            )
            .toList(),
      ),
    );
  }
}

class MessagesFake {
  final List<MessageFake> messages;
  MessagesFake({
    required this.messages,
  });
}

class MessageFake {
  final String msg;
  final MessageType type;
  MessageFake({
    required this.msg,
    required this.type,
  });
}
