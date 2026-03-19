import 'dart:async';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:zili_coffee/data/models/client_models/transaction_status.dart';
import 'package:zili_coffee/data/network/network_url.dart';
import 'package:zili_coffee/data/repositories/order_repository.dart';
import 'package:zili_coffee/di/dependency_injection.dart';
import 'package:zili_coffee/res/constant/ui_constant.dart';
import 'package:zili_coffee/utils/extension/build_context.dart';

class WebViewScreen extends StatefulWidget {
  final String webURL;
  const WebViewScreen({super.key, required this.webURL});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController webViewController;
  late final NavigationDelegate navDelegate;
  final OrderRepository orderRepository = di<OrderRepository>();
  @override
  void initState() {
    super.initState();
    navDelegate = NavigationDelegate(onNavigationRequest: onNavRequest);
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(navDelegate)
      ..loadRequest(Uri.parse(widget.webURL));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: WebViewWidget(
            controller: webViewController,
          ),
        ),
      );

  FutureOr<NavigationDecision> onNavRequest(NavigationRequest request) {
    final List<String> urlData = request.url.split('?');
    final String urlNotParam = urlData[0];
    if (urlNotParam == "zalopay://pay") {
      return NavigationDecision.prevent;
    }

    // payment success
    if (urlNotParam == NetworkUrl.order.orderURL ||
        urlNotParam == NetworkUrl.order.orderStagURL) {
      final List<String> params = urlData[1].split("&");
      _getTransactionStatus(params: params);
      context.navigator.pop();
      return NavigationDecision.prevent;
    }

    return NavigationDecision.navigate;
  }

  void _getTransactionStatus({required List<String> params}) {
    String vnpTxnref = '';
    String vnpResponsecode = '';
    String vnpTransactionstatus = '';

    for (String param in params) {
      final List<String> paramData = param.split('=');
      final String key = paramData[0];
      final String data = paramData[1];

      switch (key) {
        case OrderConstant.vnp_TxnRef:
          vnpTxnref = data;
          break;

        case OrderConstant.vnp_ResponseCode:
          vnpResponsecode = data;
          break;

        case OrderConstant.vnp_TransactionStatus:
          vnpTransactionstatus = data;
          break;

        default:
      }
    }

    if (vnpTxnref.isEmpty ||
        vnpResponsecode.isEmpty ||
        vnpTransactionstatus.isEmpty) {
      return;
    }
    orderRepository.transactionStatusStream.sink.add(
      TransactionStatus(
        vnp_TxnRef: vnpTxnref,
        vnp_ResponseCode: vnpResponsecode,
        vnp_TransactionStatus: vnpTransactionstatus,
      ),
    );
  }
}
