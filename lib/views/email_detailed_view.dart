import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/route_manager.dart';

class EmailDetailedView extends StatefulWidget {
  final Map<String, String> model;
  final String htmlFile;
  const EmailDetailedView(
      {super.key, required this.model, required this.htmlFile});

  @override
  State<EmailDetailedView> createState() => _EmailDetailedViewState();
}

class _EmailDetailedViewState extends State<EmailDetailedView> {
  late InAppWebViewController inAppWebViewController;

  Future<bool> _onBackPressed() async {
    if (await inAppWebViewController.canGoBack()) {
      inAppWebViewController.goBack();
      return false;
    } else {
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
              onTap: () async {
                if (await inAppWebViewController.canGoBack()) {
                  inAppWebViewController.goBack();
                  return;
                } else {
                  return Get.back();
                }
              },
              child: const Icon(Icons.arrow_back_ios),
            ),
          ),
          body: Column(
            children: [
              Flexible(
                child: InAppWebView(
                  onLoadStart: (controller, url) {
                    inAppWebViewController = controller;
                  },
                  initialFile: widget.htmlFile,
                  initialOptions: InAppWebViewGroupOptions(
                    crossPlatform: InAppWebViewOptions(
                      supportZoom: false,
                      javaScriptEnabled: true,
                      useShouldOverrideUrlLoading: true,
                      clearCache: false,
                      cacheEnabled: true,
                    ),
                  ),
                  onConsoleMessage: (controller, consoleMessage) {
                    // debugPrint("res" + jsonDecode(consoleMessage.message));
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    inAppWebViewController = controller;
                    debugPrint('message');

                    return null;
                  },
                  onWebViewCreated: (controller) {
                    inAppWebViewController = controller;
                  },
                  androidOnPermissionRequest:
                      (InAppWebViewController controller, String origin,
                          List<String> resources) async {
                    return PermissionRequestResponse(
                      resources: resources,
                      action: PermissionRequestResponseAction.GRANT,
                    );
                  },
                ),
              ),
            ],
          )),
    );
  }
}
