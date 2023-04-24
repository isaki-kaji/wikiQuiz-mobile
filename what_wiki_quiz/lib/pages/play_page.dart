import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';

import '../components.dart';

class PlayPage extends StatefulWidget {
  const PlayPage({Key? key}) : super(key: key);

  @override
  State<PlayPage> createState() => _PlayPageState();
}

class _PlayPageState extends State<PlayPage> {
  late Timer? _timer;
  final CountDownController _controller = CountDownController();
  Future<bool> _willPopCallback() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (elapsedTime < limitTime) {
          elapsedTime++;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: QuitButton(_timer!),
          title: Stack(children: [
            Align(
              alignment: const Alignment(0, 0),
              child: Column(
                children: [
                  CircularCountDownTimer(
                    autoStart: true,
                    isReverse: true,
                    isTimerTextShown: false,
                    controller: _controller,
                    width: 50,
                    height: 42,
                    duration: limitTime,
                    initialDuration: elapsedTime,
                    fillColor: Colors.white,
                    ringColor: Colors.teal,
                    onComplete: () {
                      Navigator.pushNamed(context, "/time");
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
            ScoreText()
          ]),
          actions: [NumberText()],
        ),
        body: Stack(
          children: [
            TextCard(),
            Column(
              children: [
                const Spacer(flex: 10),
                Row(children: [
                  const Spacer(flex: 14),
                  Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                    NextButton(),
                    Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                      PassButton(_timer!),
                      AnswerButton(_timer!),
                    ])
                  ]),
                  const Spacer(flex: 1)
                ]),
                const Spacer(flex: 1)
              ],
            ),
          ],
        ),
      ),
    );
  }
}
