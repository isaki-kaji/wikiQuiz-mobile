import 'package:flutter/material.dart';

class RankingDataPage extends StatelessWidget {
  String title;
  Map<String, dynamic> rankMap;
  RankingDataPage(this.title, this.rankMap);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.purple),
      body: ListView.builder(
          itemCount: rankMap.length,
          itemBuilder: (context, index) {
            final keyList = rankMap.keys.toList();
            final order = keyList.indexOf(keyList[index]);
            return Column(
              children: [Text(rankMap[index]["time"])],
            );
          }),
    );
  }
}
