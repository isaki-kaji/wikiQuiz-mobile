import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:what_wiki_quiz/components.dart';
import 'package:what_wiki_quiz/model.dart';

final viewModel =
    ChangeNotifierProvider.autoDispose<ViewModel>((ref) => ViewModel());

class ViewModel extends ChangeNotifier {
  var db = FirebaseFirestore.instance;
  var auth = FirebaseAuth.instance;
  Player player = Player(userName: "なまえ", selfIntro: "こんにちは");
  String playCategory = "";
  String refCategory = "";
  String? uid = "";
  int titleNum = 0;
  int textNum = 0;
  int quizScore = 0;
  bool visible = false;
  bool rankVisible = true;

  List<String> titleList = [];
  List<String> shuffledList = [];
  List<String> textList = [];
  Map<String, String> urlMap = {};
  List mapValues = [];
  Map sortedMap = {};
  List<Map<String, dynamic>>? resultList = [];

  Future<void> addRank() async {
    //todo:自己ベスト更新したらってやつをつける
    Map rankMap = {"name": player.userName, "time": elapsedTime};
    await db
        .collection("Ranking")
        .doc(playCategory)
        .update({uid.toString(): rankMap});
    rankVisible = false;
    notifyListeners();
  }

  Future<void> reName(String name) async {
    db.collection("Users").doc(uid).update({"name": name});
  }

  Future<void> reIntro(String intro) async {
    db.collection("Users").doc(uid).update({"selfIntro": intro});
  }

  Future<void> getUid() async {
    uid = auth.currentUser?.uid;
  }

  Future<void> getUser() async {
    DocumentSnapshot doc = await db.collection("Users").doc(uid).get();
    final data = doc.data()! as Map<String, dynamic>;
    player.userName = data["name"];
    player.selfIntro = data["selfIntro"];
  }

  Future<void> register() async {
    db.collection("Users").doc(uid).set({"name": "なまえ", "selfIntro": "こんにちは!"});
  }

  Future<void> getRanking() async {
    await db.collection("Ranking").doc(playCategory).get().then(
      (DocumentSnapshot doc) {
        Map<String, dynamic> rankData = doc.data() as Map<String, dynamic>;
        resultList = rankData.values.cast<Map<String, dynamic>>().toList();
        resultList?.sort((a, b) => a["time"].compareTo(b["time"]));
      },
    );
  }

  Future<void> getList(String refCategory) async {
    await db.collection("List").doc(refCategory).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        titleList = (data["list"] as List).cast<String>();
      },
    );
  }

  Future<void> changeBool() async {
    visible = true;
  }

  Future<void> resetResult() async {
    urlMap = {};
    quizScore = 0;
    titleNum = 0;
    rankVisible = true;
    elapsedTime = 0;
  }

  Future<void> getNextTexts() async {
    textNum = 0;
    await db.collection(refCategory).doc(shuffledList[titleNum]).get().then(
      (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        textList = (data["text"] as List).cast<String>();
        textList = shuffleList(textList);
        urlMap[shuffledList[titleNum]] = data["url"];
      },
    );
    titleNum++;
  }

  void nextText() {
    if (textNum < 9) {
      textNum++;
    }
    notifyListeners();
  }

  List<String> shuffleList(List<String> list) {
    var random = Random();
    var shuffledList = List<String>.from(list);
    for (var i = shuffledList.length - 1; i > 0; i--) {
      var j = random.nextInt(i + 1);
      var temp = shuffledList[i];
      shuffledList[i] = shuffledList[j];
      shuffledList[j] = temp;
    }
    return shuffledList;
  }
}
