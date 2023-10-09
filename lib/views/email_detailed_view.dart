import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:gmail_sample/controllers/home_view_controller.dart';
import 'package:gmail_sample/views/pdf_view.dart';

class EmailDetailedView extends StatefulWidget {
  final Map<String, String> model;
  final int index;
  final String htmlFile;
  const EmailDetailedView(
      {super.key,
      required this.model,
      required this.htmlFile,
      required this.index});

  @override
  State<EmailDetailedView> createState() => _EmailDetailedViewState();
}

class _EmailDetailedViewState extends State<EmailDetailedView> {
  final homeViewController = Get.find<HomeViewController>();
  late InAppWebViewController inAppWebViewController;

  final ScrollController _scrollController = ScrollController();
  int scrollY = 0;

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
          backgroundColor: Colors.white,
          body: NestedScrollView(
            physics: const NeverScrollableScrollPhysics(),
            headerSliverBuilder: (context, value) {
              return [
                value == true
                    ? const SizedBox()
                    : SliverAppBar(
                        systemOverlayStyle: SystemUiOverlayStyle.dark,
                        toolbarHeight: 50,
                        backgroundColor: Colors.white,
                        pinned: true,
                        // snap: true,
                        centerTitle: false,
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
              ];
            },
            body: Stack(
              children: [
                Column(
                  children: [
                    scrollY > 20
                        ? AnimatedContainer(
                            duration: const Duration(milliseconds: 300))
                        : AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            height: 80),
                    Flexible(
                      child: InAppWebView(
                        gestureRecognizers: {}..add(
                            Factory<LongPressGestureRecognizer>(
                              () => LongPressGestureRecognizer(),
                            ),
                          ),
                        onLoadStart: (controller, url) {
                          inAppWebViewController = controller;
                        },
                        onScrollChanged: (controller, x, y) {
                          print(x.toString());
                          print(y.toString());
                          setState(() {
                            scrollY = y;
                          });
                        },
                        initialFile: widget.htmlFile,
                        initialOptions: InAppWebViewGroupOptions(
                          android: AndroidInAppWebViewOptions(
                            useHybridComposition: true,
                          ),
                          crossPlatform: InAppWebViewOptions(
                            useShouldOverrideUrlLoading: true,
                            mediaPlaybackRequiresUserGesture: false,
                            supportZoom: true,
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
                ),
                Visibility(
                  visible: scrollY > 30 ? false : true,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Thank you for your purchase!',
                            style: TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          color: Colors.white,
                          height: 60,
                          width: Get.width,
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: homeViewController.colorList[
                                    widget.index == 0
                                        ? 0
                                        : widget.index == 1
                                            ? 1
                                            : 2 %
                                                homeViewController
                                                    .colorList.length],
                                child: Text(
                                  widget.model["title"]![0].toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        widget.model["title"].toString(),
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(width: 5),
                                      const Text(
                                        "10 Oct",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: Get.width / 1.5,
                                    child: const Text(
                                      "to me",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // const SizedBox(height: 20),
                Visibility(
                  visible: scrollY > 2600 ? true : false,
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Bounceable(
                      onTap: () {
                        Get.to(() => const PDFViewerPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5, left: 10),
                          height: 70,
                          width: 120,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(4)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Attachment.pdf"),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: const Text(
                                      "PDF",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    "PDF",
                                    style: TextStyle(color: Colors.grey),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
