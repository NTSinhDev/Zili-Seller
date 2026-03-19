import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:zili_coffee/app/app_config.dart';
import 'package:zili_coffee/app/app_wireframe.dart';
import 'package:zili_coffee/bloc/app/app_cubit.dart';

import '../data/repositories/app_repository.dart';
import '../di/dependency_injection.dart';
import '../res/res.dart';
import '../services/firebase_cloud_messaging/firebase_cloud_messaging_services.dart';
import '../services/notification_service/notification_service.dart';
import 'app_flavor_config.dart';

class ZiliSellerApp extends StatefulWidget {
  const ZiliSellerApp({super.key});

  @override
  State<ZiliSellerApp> createState() => _ZiliSellerAppState();
}

class _ZiliSellerAppState extends State<ZiliSellerApp> {
  AppCubit get _appCubit => GetIt.I<AppCubit>();
  late final FCMHandler _fcmHandler;
  final AppRepository _appRepository = di<AppRepository>();

  @override
  void initState() {
    super.initState();
    _fcmHandler = FCMHandler(notificationService: NotificationService());
    _appRepository.fcmHandler = _fcmHandler;
  }

  @override
  void dispose() {
    _appCubit.close();
    _fcmHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppCubit>(
      create: (_) => _appCubit..checkSession(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (_, child) => BlocListener<AppCubit, AppState>(
          listener: (context, state) {
            if (state is AppReadyWithAuthenticationState) {
              _appRepository.fcmHandler?.notificationService
                  .requestPermission();
            }
          },
          child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: ThemeApp.systemDefault.copyWith(
              systemNavigationBarColor: null,
              systemNavigationBarDividerColor: null,
              systemNavigationBarIconBrightness: null,
              systemNavigationBarContrastEnforced: null,
            ),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              // showPerformanceOverlay: true,
              navigatorKey: AppWireFrame.navigatorKey,
              routes: AppWireFrame.routes,
              initialRoute: AppWireFrame.rootName,
              localizationsDelegates: AppConfig.locale.delegates,
              localeResolutionCallback: AppConfig.locale.resolutionCallback,
              supportedLocales: AppConfig.locale.supportedLocales,
              theme: ThemeApp.theme,
              title: FlavorConfig.instance.env.appName,
              builder: (childContext, child) {
                SystemChannels.textInput.invokeMethod('TextInput.hide');
                _fcmHandler.handleFirebaseMessagingStates(childContext);
                if (defaultTargetPlatform == TargetPlatform.iOS) {
                  final builder = ScrollConfiguration(
                    behavior: const CommonScrollBehaviorModified(),
                    child: child ?? Container(),
                  );
                  return KeyboardContainer(child: builder);
                }
                return FocusScope(
                  // Disable automatic focus requests globally
                  // Widgets can still request focus explicitly when needed via FocusNode.requestFocus()
                  autofocus: false,
                  child: child ?? const SizedBox(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CommonScrollBehaviorModified extends ScrollBehavior {
  const CommonScrollBehaviorModified();
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return const ClampingScrollPhysics();
      case TargetPlatform.macOS:
      case TargetPlatform.android:
        return const BouncingScrollPhysics();
      case TargetPlatform.fuchsia:
      case TargetPlatform.linux:
      case TargetPlatform.windows:
        return const ClampingScrollPhysics();
    }
  }
}

class KeyboardContainer extends StatelessWidget {
  final Widget? child;
  const KeyboardContainer({this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (child != null) Expanded(child: child!),
        const CustomKeyboard(),
      ],
    );
  }
}

class CustomKeyboardHandlerData {
  bool isKeyboardShowing;
  TextEditingController controller;

  CustomKeyboardHandlerData({
    required this.isKeyboardShowing,
    required this.controller,
  });
}

enum KeyType {
  key0('0'),
  key1('1'),
  key2('2'),
  key3('3'),
  key4('4'),
  key5('5'),
  key6('6'),
  key7('7'),
  key8('8'),
  key9('9'),
  keyVirgule(','),
  keyDelete('Delete'),
  keyDone('Done');

  bool get isFunctionKey => (this == keyDelete) || (this == keyDone);

  const KeyType(this.value);

  final String value;
}

class CustomKeyboardHandler {
  CustomKeyboardHandler._();

  static final StreamController<CustomKeyboardHandlerData> _streamController =
      StreamController<CustomKeyboardHandlerData>.broadcast();

  static Stream<CustomKeyboardHandlerData> get customKeyboardStream =>
      _streamController.stream;

  static final BehaviorSubject<KeyType> onPressedDeleteKey =
      BehaviorSubject<KeyType>();

  static void onFocusChangeHandler(
    CustomKeyboardHandlerData customKeyboardHandlerData,
  ) {
    _streamController.add(customKeyboardHandlerData);
  }

  static void onChanged(KeyType keyType) {
    if (keyType == KeyType.keyDelete) {
      onPressedDeleteKey.sink.add(keyType);
    }
  }
}

void dismissKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

class CustomKeyboard extends StatefulWidget {
  const CustomKeyboard({super.key});

  @override
  State<CustomKeyboard> createState() => _CustomKeyboardState();
}

class _CustomKeyboardState extends State<CustomKeyboard> {
  final double _defaultKeyboardHeight = 280;
  bool _isKeyboardShowing = false;
  TextEditingController _controller = TextEditingController();
  final _keys = [
    KeyType.key1,
    KeyType.key2,
    KeyType.key3,
    KeyType.key4,
    KeyType.key5,
    KeyType.key6,
    KeyType.key7,
    KeyType.key8,
    KeyType.key9,
    KeyType.keyVirgule,
    KeyType.key0,
    KeyType.keyDelete,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      CustomKeyboardHandler.customKeyboardStream.listen((event) {
        setState(() {
          _isKeyboardShowing = event.isKeyboardShowing;
          _controller = event.controller;
        });
      });
    });
    super.initState();
  }

  void _handleKeyPress(KeyType keyType) {
    CustomKeyboardHandler.onChanged(keyType);
    final String currentText = _controller.text;
    String newText = currentText;
    final characterSelectedNum =
        _controller.selection.end - _controller.selection.start;
    int cursorPosition = _controller.selection.base.offset;
    if (keyType.isFunctionKey) {
      switch (keyType) {
        case KeyType.keyDelete:
          if (currentText.isNotEmpty && (_controller.selection.end > 0)) {
            int characterDeletedNum = characterSelectedNum;
            if (characterDeletedNum <= 1) {
              characterDeletedNum = 1;
            }
            final leftCursor = currentText.substring(
              0,
              _controller.selection.end - characterDeletedNum,
            );
            final rightCursor = currentText.substring(
              _controller.selection.end,
            );
            newText = '$leftCursor$rightCursor';
            cursorPosition = _controller.selection.end - characterDeletedNum;
          }
          break;
        case KeyType.keyDone:
          dismissKeyboard(context);
          break;
        default:
          break;
      }
    } else {
      final String leftCursor = currentText.substring(
        0,
        _controller.selection.end - characterSelectedNum,
      );
      final addedWord = keyType.value;
      final rightCursor = currentText.substring(_controller.selection.end);
      cursorPosition = cursorPosition + addedWord.length - characterSelectedNum;
      newText = '$leftCursor$addedWord$rightCursor';
    }
    _controller
      ..text = newText
      ..selection = TextSelection.collapsed(offset: cursorPosition);
  }

  @override
  Widget build(BuildContext context) {
    double keyboardHeight =
        _defaultKeyboardHeight - MediaQuery.of(context).viewInsets.bottom;
    if (keyboardHeight < 0) {
      keyboardHeight = 0;
    }
    return Material(
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 1,
      child: AnimatedContainer(
        height: _isKeyboardShowing ? keyboardHeight : 0,
        duration: const Duration(milliseconds: 0),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(8.w).copyWith(bottom: 0),
          child: Column(
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: _keys.map((e) => _keyWidget(e)).toList(),
              ),
              height(height: 4),
              Container(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      onPressed: () {
                        dismissKeyboard(context);
                      },
                      child: const Icon(
                        CupertinoIcons.chevron_down,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        dismissKeyboard(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 24.w,
                          vertical: 8.w,
                        ),
                        decoration: BoxDecoration(
                          color: Color(0xFF5CB44E),
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: const Icon(
                          CupertinoIcons.checkmark_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _keyWidget(KeyType keysType) {
    if (keysType == KeyType.keyDelete) {
      return InkWell(
        onTap: () => _handleKeyPress(keysType),
        child: Container(
          width: 1.sw / 4,
          height: 44.w,
          decoration: BoxDecoration(
            color: Color(0xFFEAEAEA),
            borderRadius: BorderRadius.circular(28.r),
          ),
          alignment: Alignment.center,
          child: CustomIconStyle(
            icon: CupertinoIcons.delete_left,
            style: AppStyles.text.semiBold(fSize: 30),
          ),
        ),
      );
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => _handleKeyPress(keysType),
      child: Container(
        width: 1.sw / 4,
        height: 44.w,
        decoration: BoxDecoration(
          color: Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(28.r),
        ),
        alignment: Alignment.center,
        child: Text(keysType.value, style: AppStyles.text.semiBold(fSize: 30)),
      ),
    );
  }

  // Widget _bigKeyWidget(KeyType keysType) {
  //   return GestureDetector(
  //     behavior: HitTestBehavior.translucent,
  //     onTap: () {
  //       _handleKeyPress(keysType);
  //     },
  //     child: Container(
  //       width: 100,
  //       height: 100,
  //       decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(8),
  //       ),
  //       alignment: Alignment.center,
  //       child: Text(keysType.value),
  //     ),
  //   );
  // }
}

class CustomIconStyle extends StatelessWidget {
  final IconData icon;
  final TextStyle style;
  final Color? color;
  final TextAlign? align;
  const CustomIconStyle({
    super.key,
    required this.icon,
    required this.style,
    this.color,
    this.align,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      String.fromCharCode(icon.codePoint),
      style: style.copyWith(
        inherit: false,
        fontFamily: icon.fontFamily,
        package: icon.fontPackage,
      ),
      textAlign: align,
    );
  }
}
