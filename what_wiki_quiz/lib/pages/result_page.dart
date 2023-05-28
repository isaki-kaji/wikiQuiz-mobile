import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:what_wiki_quiz/text_style.dart';

import '../components.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({Key? key}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool _isVisible = false;
  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: (_isVisible)
              ? Center(
                  child: AnimatedTextKit(
                    totalRepeatCount: 10,
                    animatedTexts: [
                      FadeAnimatedText("ランキングに登録  →→→",
                          textStyle: const TextStyle(fontSize: 22)),
                    ],
                  ),
                )
              : Container(),
          actions: [(_isVisible) ? AddRankButton() : Container()],
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(height: 10),
            CategoryText(),
            ShowUpAnimation(
              delayStart: const Duration(milliseconds: 1600),
              child: TitleFont("タイムは……", 30, FontWeight.normal),
            ),
            ShowUpAnimation(
              delayStart: const Duration(milliseconds: 3000),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text((elapsedTime / 60).floor().toString(),
                      style: scoreStyle),
                  Text("'", style: scoreStyle),
                  Text(
                    (elapsedTime % 60).toString().padLeft(2, '0'),
                    style: scoreStyle,
                  ),
                  const SizedBox(width: 5),
                ],
              ),
            ),
            ShowUpAnimation(
              delayStart: const Duration(milliseconds: 3000),
              child: Text(
                (elapsedTime < 120) ? "すばらしいです。とても" : "伸びしろがあります。とても。",
                style: GoogleFonts.hinaMincho(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple),
              ),
            ),
            const SizedBox(height: 20),
            (_isVisible) ? ResultButton("もういちど挑戦", "/prepare") : Container(),
            const SizedBox(height: 40),
            (_isVisible) ? ResultButton("ほかの問題に挑戦", "/") : Container(),
            const SizedBox(height: 30),
            (_isVisible) ? const Text("出題記事一覧") : Container(),
            const SizedBox(height: 10),
            (_isVisible) ? UrlList() : Container(),
            const SizedBox(height: 20)
          ]),
        ),
      ),
    );
  }
}
