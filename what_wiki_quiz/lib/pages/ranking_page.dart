import 'package:flutter/material.dart';

class RankingDataPage extends StatelessWidget {
  String title;
  List<Map<String, dynamic>>? rankList;
  RankingDataPage(this.title, this.rankList);

  //Todo:どのようにデータを順位付けして取り出すかを考える。

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: rankList?.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text((index + 1).toString()),
            title: Text(rankList![index]["name"]),
          );
        },
      ),
    );
  }
}
