import 'package:flutter/material.dart';

class RankingDataPage extends StatelessWidget {
  final String _title;
  List<Map<String, dynamic>>? _rankList;
  RankingDataPage(this._title, this._rankList);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: _rankList?.length,
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
                  Text(_rankList![index]["name"]),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Text("${(_rankList![index]["time"] / 60).truncate()}:"),
                        Text(
                          ((_rankList![index]["time"] % 60).toString())
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
