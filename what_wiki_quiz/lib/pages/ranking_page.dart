import 'package:flutter/material.dart';

class RankingDataPage extends StatelessWidget {
  String title;
  List<Map<String, dynamic>>? rankList;
  RankingDataPage(this.title, this.rankList);

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
          return Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: Colors.purple),
              ),
            ),
            child: ListTile(
              leading: Text((index + 1).toString()),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(rankList![index]["name"]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("${(rankList![index]["time"] / 60).truncate()}:"),
                        Text(
                          ((rankList![index]["time"] % 60).toString())
                              .padLeft(2, '0'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
