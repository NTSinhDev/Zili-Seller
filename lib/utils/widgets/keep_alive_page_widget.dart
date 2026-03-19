import 'package:flutter/material.dart';

class KeepAlivePageWidget extends StatefulWidget {
  final Widget page;
  const KeepAlivePageWidget({super.key, required this.page});

  @override
  State<KeepAlivePageWidget> createState() => _KeepAlivePageWidgetState();
}

class _KeepAlivePageWidgetState extends State<KeepAlivePageWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.page;
  }
  
  @override
  bool get wantKeepAlive => true;
}
