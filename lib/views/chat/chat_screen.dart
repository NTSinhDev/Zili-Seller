import 'dart:developer';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zili_coffee/utils/enums.dart';
import 'package:zili_coffee/res/res.dart';
import 'package:zili_coffee/utils/widgets/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zili_coffee/views/chat/components/message_widget.dart';
import 'package:zili_coffee/views/chat/components/picker_media_widget.dart';
part 'components/input_messages.dart';
part 'components/messages_view.dart';
part 'components/suggested_message.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget.lightAppBar(context, label: 'Tin nhắn'),
      backgroundColor: AppColors.white,
      body: SizedBox(
        width: Spaces.screenWidth(context),
        height: Spaces.screenHeight(context),
        child: const Stack(
          children: [
            _MessagesView(),
            _InputMessages(),
          ],
        ),
      ),
    );
  }
}
