import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:get/get.dart';
import 'package:gmail_sample/controllers/home_view_controller.dart';
import 'package:gmail_sample/views/email_detailed_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _textController = TextEditingController();
  final homeViewController = Get.put(HomeViewController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, value) {
            return [
              SliverAppBar(
                systemOverlayStyle: SystemUiOverlayStyle.dark,
                toolbarHeight: 50,
                backgroundColor: Colors.white,
                pinned: false,
                // snap: true,
                centerTitle: false,
                title: Container(
                  height: 52,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xffDFDFDF),
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: TextFormField(
                    controller: _textController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Padding(
                          padding: EdgeInsets.all(15.0),
                          child: Icon(Icons.search),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                        ),
                        hintText: "Search In mail",
                        hintStyle: TextStyle(
                          fontSize: 15,
                        )),
                    onChanged: (val) {},
                  ),
                ),
              ),
            ];
          },
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, top: 20),
                child: Text("ALL INBOXES"),
              ),
              Expanded(
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: homeViewController.mailListJson.length,
                  padding: const EdgeInsets.all(16),
                  itemBuilder: (context, index) {
                    final model = homeViewController.mailListJson[index];
                    return Bounceable(
                      onTap: () {
                        Get.to(
                          () => EmailDetailedView(
                            model: model,
                            index: index,
                            htmlFile: model["url"].toString(),
                          ),
                          transition: Transition.cupertino,
                        );
                      },
                      child: SizedBox(
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: homeViewController.colorList[
                                  index % homeViewController.colorList.length],
                              child: Text(
                                model["title"]![0].toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  model["title"].toString(),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  width: Get.width / 1.5,
                                  child: Text(
                                    model["sub_title"].toString(),
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
