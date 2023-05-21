import 'package:flutter/material.dart';

class RankingDataPage extends StatelessWidget {
  String title;
  Map rankMap;
  RankingDataPage(this.title, this.rankMap);

  //Todo:どのようにデータを順位付けして取り出すかを考える。
  //Todo:いつになるかは分からない。

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.purple),
      body: ListView.builder(
        itemCount: rankMap.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text((index + 1).toString()),
          );
        },
      ),
    );
  }
}
