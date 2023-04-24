import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_up_animation/show_up_animation.dart';

import '../components.dart';

class TimeUpPage extends StatefulWidget {
  const TimeUpPage({Key? key}) : super(key: key);

  @override
  State<TimeUpPage> createState() => _TimeUpPageState();
}

class _TimeUpPageState extends State<TimeUpPage> {
  bool isVisible = false;
  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
          appBar: AppBar(automaticallyImplyLeading: false),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Spacer(flex: 2),
            CategoryText(),
            const Spacer(flex: 15),
            ShowUpAnimation(
              delayStart: const Duration(milliseconds: 3000),
              child: Text(
                "時間切れです…",
                style: GoogleFonts.hinaMincho(fontSize: 45, color: Colors.teal),
              ),
            ),
            const Spacer(flex: 20),
            (isVisible) ? ResultButton("もういちど挑戦", "/prepare") : Container(),
            const Spacer(flex: 5),
            (isVisible) ? ResultButton("ほかの問題に挑戦", "/") : Container(),
            const Spacer(flex: 5),
            (isVisible) ? const Text("出題記事一覧") : Container(),
            (isVisible) ? UrlList() : Container(),
            const Spacer(flex: 6),
          ])),
    );
  }
}
