import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeViewController extends GetxController {
  final mailListJson = [
    {
      "title": "Happilo",
      "sub_title": "Thank you for your purchase!",
      "url": "assets/mailbody1.html"
    },
    {
      "title": "Hopscotch Care",
      "sub_title": "Order Shipped",
      "url": "assets/mailbody2.html"
    },
    {
      "title": "Noise",
      "sub_title": "THANK YOU FOR PLACING YOUR ORDER WITH US.",
      "url": "assets/mailbody3.html"
    }
  ];

//Custom colors for profile images
  List colorList = [
    const Color(0xFFFF8C68),
    const Color(0xFF0EC4AE),
    const Color(0xFFC038D6)
  ];
}
