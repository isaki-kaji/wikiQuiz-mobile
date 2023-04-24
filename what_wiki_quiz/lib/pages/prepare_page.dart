// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../components.dart';
import '../text_style.dart';
import '../view_model.dart';

class PreparePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Scaffold(
      endDrawer: EDrawer(),
      appBar: AppBar(
        actions: [
          Builder(builder: (context) {
            return Padding(
              padding: const EdgeInsets.only(right: 5),
              child: IconButton(
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
                icon: const Icon(
                  Icons.book,
                  size: 30,
                ),
              ),
            );
          })
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          TitleFont("クイズ", 30, FontWeight.bold),
          FittedBox(
              fit: BoxFit.fitWidth,
              child: TitleFont(
                  "「${viewModelProvider.playCategory}」", 30, FontWeight.bold)),
          const Spacer(flex: 1),
          Padding(
            padding: const EdgeInsets.only(right: 10, left: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      const TextSpan(
                          text:
                              "クイズに使用される文章はクリエイティブ・コモンズ・表示・継承ライセンス3.0の下で公表されたウィキペディア日本語版の記事内の文章を利用したものです。このクイズの文章は、"),
                      TextSpan(
                        text: "クリエイティブ・コモンズ・表示・継承ライセンス3.0",
                        style: const TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            const String commons =
                                "https://creativecommons.org/licenses/by-sa/3.0/";
                            final Uri commonsUrl = Uri.parse(commons);
                            launchUrl(commonsUrl);
                          },
                      ),
                      const TextSpan(
                          text: "の下、二次利用できます。クイズに利用した記事のリンクはクイズ終了時に表示します。"),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
                "クイズに使用される文章はwikipedia本文から「()」内の文、単語を削除したものです。また記事のタイトル(問題の正解)に当たる箇所は「○○」に変換してあります。"),
          ),
          const Spacer(flex: 1),
          SizedBox(
            width: 90,
            height: 90,
            child: FloatingActionButton(
              backgroundColor: Colors.purple,
              onPressed: () async {
                viewModelProvider.shuffledList =
                    viewModelProvider.shuffleList(viewModelProvider.titleList);
                await viewModelProvider.getNextTexts();
                Navigator.pushNamed(context, "/play");
              },
              child: const Icon(
                Icons.start,
                size: 30,
              ),
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
