import 'package:flutter/material.dart';

import '../category_list.dart';
import '../components.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            MCTitle("スポーツ"),
            ExpansionTile(
              title: const Text("プロ野球"),
              leading: const Icon(Icons.sports_baseball),
              children: baseballList.map((tx) {
                return CategoryCard(
                    tx["category"].toString(), tx["refCategory"].toString());
              }).toList(),
            ),
            ExpansionTile(
              title: const Text("サッカー"),
              leading: const Icon(Icons.sports_soccer),
              children: soccerList.map((tx) {
                return CategoryCard(
                    tx["category"].toString(), tx["refCategory"].toString());
              }).toList(),
            ),
            MCTitle("エンタメ"),
            ExpansionTile(
              title: const Text("女性アイドル"),
              leading: const Icon(Icons.favorite),
              children: wIdolList.map((tx) {
                return CategoryCard(
                    tx["category"].toString(), tx["refCategory"].toString());
              }).toList(),
            ),
            ExpansionTile(
              title: const Text("男性アイドル"),
              leading: const Icon(Icons.favorite_border),
              children: mIdolList.map((tx) {
                return CategoryCard(
                    tx["category"].toString(), tx["refCategory"].toString());
              }).toList(),
            ),
            ExpansionTile(
              title: const Text("声優"),
              leading: const Icon(Icons.mic),
              children: vActorList.map((tx) {
                return CategoryCard(
                    tx["category"].toString(), tx["refCategory"].toString());
              }).toList(),
            ),
            MCTitle("歴史"),
            ExpansionTile(
              title: const Text("戦国時代"),
              leading: const Icon(Icons.av_timer),
              children: sFighterList.map((tx) {
                return CategoryCard(
                    tx["category"].toString(), tx["refCategory"].toString());
              }).toList(),
            ),
            const SizedBox(height: 60)
          ],
        ),
      ),
    );
  }
}
