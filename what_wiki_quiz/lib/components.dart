// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchfield/searchfield.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:what_wiki_quiz/text_style.dart';
import 'package:what_wiki_quiz/view_model.dart';

const int limitTime = 180;
int elapsedTime = 0;
int rankingTime = 120;

class MainButton extends ConsumerWidget {
  final String title;
  final String route;
  MainButton({required this.title, required this.route});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      width: deviceWidth * 0.8,
      child: ElevatedButton(
        onPressed: () async {
          if (route == "/category") {
            if (viewModelProvider.auth.currentUser == null) {
              await viewModelProvider.auth.signInAnonymously();
              await viewModelProvider.getUid();
              await viewModelProvider.register();
              viewModelProvider.getUser();
              print("nullです");
            } else {
              await viewModelProvider.getUid();
              viewModelProvider.getUser();
            }
          }
          print(viewModelProvider.uid);
          Navigator.of(context).pushNamed(route);
        },
        child: TitleFont(title, 25, FontWeight.bold),
      ),
    );
  }
}

class MCTitle extends StatelessWidget {
  String category;
  MCTitle(this.category);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Center(
        child: Text(
          category,
          textAlign: TextAlign.center,
          style: GoogleFonts.hinaMincho(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class CategoryCard extends ConsumerWidget {
  final String category;
  final String refCategory;
  CategoryCard(this.category, this.refCategory);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final viewModelProvider = ref.watch(viewModel);
    return GestureDetector(
      onTap: () async {
        viewModelProvider.playCategory = category;
        viewModelProvider.refCategory = refCategory;
        await viewModelProvider.getList(category);
        Navigator.of(context).pushNamed("/prepare");
      },
      child: SizedBox(
        height: 60,
        width: deviceWidth,
        child: Card(
          child: Row(
            children: [
              const Checkbox(
                value: false,
                onChanged: print,
              ),
              Text(category)
            ],
          ),
        ),
      ),
    );
  }
}

class RankingCard extends ConsumerWidget {
  final String category;
  RankingCard(this.category);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final viewModelProvider = ref.watch(viewModel);
    return GestureDetector(
      onTap: () async {
        viewModelProvider.playCategory = category;
        await viewModelProvider.getRanking();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) =>
        //         RankingDataPage(category, viewModelProvider.rankMap),
        //   ),
        // );
      },
      child: SizedBox(
        height: 60,
        width: deviceWidth,
        child: Card(
          child: Row(
            children: [
              const Checkbox(
                value: false,
                onChanged: print,
              ),
              Text(category)
            ],
          ),
        ),
      ),
    );
  }
}

class EDrawer extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Align(
                alignment: Alignment.bottomCenter,
                child: TitleFont("出題記事一覧", 25, FontWeight.bold)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: viewModelProvider.titleList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  height: 45,
                  child: ListTile(
                    title: Center(
                      child: Text(
                        viewModelProvider.titleList[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class AnswerButton extends ConsumerWidget {
  Timer timer;
  AnswerButton(this.timer);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.teal),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: SizedBox(
                height: 150,
                width: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SearchField(
                          hasOverlay: true,
                          suggestionItemDecoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          suggestionState: Suggestion.hidden,
                          suggestions: viewModelProvider.titleList
                              .map((e) => SearchFieldListItem(e))
                              .toList(),
                          searchInputDecoration: const InputDecoration(
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            labelText: '回答する',
                            border: OutlineInputBorder(),
                          ),
                          hint: '',
                          maxSuggestionsInViewPort: 3,
                          suggestionDirection: SuggestionDirection.down,
                          itemHeight: 50,
                          onSubmit: (x) {
                            String answer = x;
                            if (answer ==
                                viewModelProvider.shuffledList[
                                    viewModelProvider.titleNum - 1]) {
                              viewModelProvider.quizScore += 1;
                              if (viewModelProvider.quizScore < 5) {
                                AwesomeDialog(
                                  dismissOnTouchOutside: false,
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.topSlide,
                                  title: '正解です!!',
                                  btnOkOnPress: () async {
                                    timer.cancel();
                                    await viewModelProvider.getNextTexts();
                                    Navigator.pushNamed(context, "/play");
                                  },
                                ).show();
                              } else {
                                timer.cancel();
                                Navigator.pushNamed(context, "/result");
                              }
                            } else {
                              AwesomeDialog(
                                dismissOnTouchOutside: false,
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.topSlide,
                                title: '不正解です…',
                                desc:
                                    '正解:${viewModelProvider.shuffledList[viewModelProvider.titleNum - 1]}',
                                btnOkOnPress: () async {
                                  timer.cancel();
                                  await viewModelProvider.getNextTexts();
                                  Navigator.pushNamed(context, "/play");
                                },
                              ).show();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
      child: Container(
        height: 100,
        width: 100,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(80),
          boxShadow: const [
            BoxShadow(
                spreadRadius: 1,
                blurRadius: 2,
                color: Colors.grey,
                offset: Offset(1, 1))
          ],
        ),
        alignment: Alignment.center,
        child: ButtonFont("答"),
      ),
    );
  }
}

class TextCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Card(
      child: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
                top: 20, bottom: 200, left: 20, right: 20),
            child: Text(
              viewModelProvider.textList[viewModelProvider.textNum],
              style: const TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}

class ScoreText extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Align(
      alignment: const Alignment(0, 0),
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(viewModelProvider.quizScore.toString()),
      ),
    );
  }
}

class NumberText extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Center(
      child: Row(
        children: [
          Text(
            (viewModelProvider.textNum + 1).toString(),
            style: numberStyle,
          ),
          const Text(
            "/",
            style: TextStyle(fontSize: 25),
          ),
          Text(
            "10",
            style: numberStyle,
          ),
          const SizedBox(
            width: 20,
          )
        ],
      ),
    );
  }
}

class PassButton extends ConsumerWidget {
  Timer timer;
  PassButton(this.timer);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 5),
      child: ElevatedButton(
        child: ButtonFont("パス"),
        onPressed: () {
          showConfirmDialog(
            context,
            title: "",
            content: "パスしますか?",
            onApproved: () async {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(
                      "正解は……「${viewModelProvider.shuffledList[viewModelProvider.titleNum - 1]}」"),
                ),
              );
              await viewModelProvider.getNextTexts();
              Navigator.pushNamed(context, "/play");
              timer.cancel();
            },
          );
        },
      ),
    );
  }
}

class QuitButton extends ConsumerWidget {
  Timer timer;
  QuitButton(this.timer);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return IconButton(
      icon: const Icon(Icons.backspace_outlined),
      onPressed: () {
        showConfirmDialog(
          context,
          title: "",
          content: "中止しますか?",
          onApproved: () async {
            viewModelProvider.urlMap = {};
            timer.cancel();
            await Navigator.pushNamed(context, "/");
          },
        );
      },
    );
  }
}

class NextButton extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return Padding(
      padding: const EdgeInsets.only(right: 15, bottom: 10),
      child: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          backgroundColor:
              (viewModelProvider.textNum < 9) ? Colors.teal : Colors.grey,
          child: const Icon(
            Icons.arrow_forward,
            size: 35,
          ),
          onPressed: () {
            viewModelProvider.nextText();
          },
        ),
      ),
    );
  }
}

class CategoryText extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return ShowUpAnimation(
      delayStart: const Duration(milliseconds: 800),
      child: FittedBox(
          fit: BoxFit.fitWidth,
          child: TitleFont(
              "${viewModelProvider.playCategory} クイズ", 35, FontWeight.normal)),
    );
  }
}

class UrlList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          height: 50,
          width: 380,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Row(
                children: [
                  for (int i = 0; i < viewModelProvider.urlMap.length; i++) ...{
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: viewModelProvider.shuffledList[i],
                            style: const TextStyle(
                                color: Colors.teal, fontSize: 18),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Uri url = Uri.parse(viewModelProvider.urlMap[
                                    viewModelProvider.shuffledList[i]]!);
                                launchUrl(url);
                              },
                          ),
                          const TextSpan(text: "  "),
                        ],
                      ),
                    )
                  }
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ResultButton extends ConsumerWidget {
  String title;
  String route;
  ResultButton(this.title, this.route);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    return SizedBox(
      height: 50,
      width: 340,
      child: ElevatedButton(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          if (route == "/prepare") {
            viewModelProvider.shuffledList =
                viewModelProvider.shuffleList(viewModelProvider.titleList);
          }
          await viewModelProvider.resetResult();
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}

class AddRankButton extends ConsumerWidget {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModelProvider = ref.watch(viewModel);
    _nameController.text = viewModelProvider.player.userName;
    return (viewModelProvider.rankVisible)
        ? Row(
            children: [
              IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Container(
                            height: 230.0,
                            width: 300.0,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal, width: 3),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 20),
                                const Text(
                                  "ランキングに登録",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 220,
                                  child: TextFormField(
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: "名前を入力する(2~9文字)",
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                FloatingActionButton(
                                  onPressed: () async {
                                    if (_nameController.text.length > 1 &&
                                        _nameController.text.length < 10) {
                                      viewModelProvider.player.userName =
                                          _nameController.text;
                                      await viewModelProvider
                                          .reName(_nameController.text);
                                      await viewModelProvider.addRank();
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: const Icon(Icons.add),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.star)),
              const SizedBox(
                width: 8,
              )
            ],
          )
        : Container();
  }
}

// class Profile extends ConsumerWidget {
//   final _profNameController = TextEditingController();
//   final _selfIntroController = TextEditingController();
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final viewModelProvider = ref.watch(viewModel);
//     _profNameController.text = viewModelProvider.player.userName;
//     _selfIntroController.text = viewModelProvider.player.selfIntro;
//     return Row(
//       children: [
//         IconButton(
//             onPressed: () async {
//               showDialog(
//                 context: context,
//                 barrierDismissible: true,
//                 builder: (BuildContext context) {
//                   return Dialog(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10.0),
//                     ),
//                     child: Container(
//                       height: 350.0,
//                       width: 300.0,
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.teal, width: 3),
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           const Spacer(flex: 2),
//                           SizedBox(
//                             width: 250,
//                             child: TextFormField(
//                                 controller: _profNameController,
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: "名前を入力する(2~9文字)",
//                                 ),
//                                 onChanged: (_) async {
//                                   if (_profNameController.text.length > 1 &&
//                                       _profNameController.text.length < 10) {
//                                     viewModelProvider.player.userName =
//                                         _profNameController.text;
//                                     await viewModelProvider
//                                         .reName(_profNameController.text);
//                                     Navigator.pop(context);
//                                   }
//                                 }),
//                           ),
//                           const Spacer(flex: 1),
//                           SizedBox(
//                             height: 200,
//                             width: 250,
//                             child: TextFormField(
//                                 controller: _selfIntroController,
//                                 decoration: const InputDecoration(
//                                   border: OutlineInputBorder(),
//                                   labelText: "自己紹介(100文字以内)",
//                                 ),
//                                 onChanged: (_) async {
//                                   if (_selfIntroController.text.length < 101) {
//                                     viewModelProvider.player.selfIntro =
//                                         _selfIntroController.text;
//                                     await viewModelProvider
//                                         .reIntro(_profNameController.text);
//                                     Navigator.pop(context);
//                                   }
//                                 }),
//                           ),
//                           const Spacer(flex: 2),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               );
//             },
//             icon: const Icon(Icons.account_circle, size: 30)),
//         const SizedBox(width: 10)
//       ],
//     );
//   }
// }

Future showConfirmDialog(
  context, {
  required String title,
  required String content,
  required onApproved,
}) async {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          width: 300.0,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.teal, width: 3),
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Text(
                  title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Center(
                  child: Text(
                    content,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: const BorderSide(
                        width: 1.0,
                        color: Colors.teal,
                      ),
                      shadowColor: Colors.grey,
                      elevation: 5,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      child: Text('いいえ'),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.grey,
                      elevation: 5,
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: onApproved,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 16, horizontal: 18),
                      child: Text('はい'),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
            ],
          ),
        ),
      );
    },
  );
}
