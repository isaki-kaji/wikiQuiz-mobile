import 'package:flutter/material.dart';

import '../category_list.dart';
import '../components.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ランキング"),
        backgroundColor: Colors.purple,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            MCTitle("スポーツ"),
            ExpansionTile(
              textColor: Colors.purple,
              iconColor: Colors.purple,
              title: const Text("プロ野球"),
              leading: const Icon(Icons.sports_baseball),
              children: baseballList.map((tx) {
                return RankingCard(tx["category"].toString());
              }).toList(),
            ),
            ExpansionTile(
              textColor: Colors.purple,
              iconColor: Colors.purple,
              title: const Text("サッカー"),
              leading: const Icon(Icons.sports_soccer),
              children: soccerList.map((tx) {
                return RankingCard(tx["category"].toString());
              }).toList(),
            ),
            MCTitle("エンタメ"),
            ExpansionTile(
              textColor: Colors.purple,
              iconColor: Colors.purple,
              title: const Text("女性アイドル"),
              leading: const Icon(Icons.favorite),
              children: wIdolList.map((tx) {
                return RankingCard(tx["category"].toString());
              }).toList(),
            ),
            ExpansionTile(
              textColor: Colors.purple,
              iconColor: Colors.purple,
              title: const Text("男性アイドル"),
              leading: const Icon(Icons.favorite_border),
              children: mIdolList.map((tx) {
                return RankingCard(tx["category"].toString());
              }).toList(),
            ),
            ExpansionTile(
              textColor: Colors.purple,
              iconColor: Colors.purple,
              title: const Text("声優"),
              leading: const Icon(Icons.mic),
              children: vActorList.map((tx) {
                return RankingCard(tx["category"].toString());
              }).toList(),
            ),
            MCTitle("歴史"),
            ExpansionTile(
              textColor: Colors.purple,
              iconColor: Colors.purple,
              title: const Text("戦国時代"),
              leading: const Icon(Icons.av_timer),
              children: sFighterList.map((tx) {
                return RankingCard(tx["category"].toString());
              }).toList(),
            ),
            const SizedBox(height: 60)
          ],
        ),
      ),
    );
  }
}
