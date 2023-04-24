import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await FirebaseAuth.instance.currentUser?.delete();
                  await FirebaseAuth.instance.signOut();
                })
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 6),
              FittedBox(
                fit: BoxFit.fitWidth,
                child: AnimatedTextKit(
                  animatedTexts: [
                    WavyAnimatedText(
                      "クイズ これ何のWiki?",
                      textStyle: GoogleFonts.hinaMincho(
                        fontSize: 38,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 3),
              MainButton(title: "ゲームをはじめる", route: "/category"),
              const Spacer(flex: 1),
              MainButton(title: "ランキング", route: "/ranking"),
              const Spacer(flex: 4)
            ],
          ),
        ),
      ),
    );
  }
}
