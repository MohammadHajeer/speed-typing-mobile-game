import 'package:flutter/material.dart';
import 'package:speed_type_game/player.dart';
import 'package:speed_type_game/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String _baseURL = "hajeerspeedtypegame.000webhostapp.com";

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

List playerScores = [];

class _HomeTabState extends State<HomeTab> {
  List scores = <LeaderBoardScore>[];
  bool loading = false;
  List filters = <String>[];
  bool errorMessage = false;

  void filter(String filter) {
    setState(() {
      if (filters.contains(filter)) {
        filters.remove(filter);
      } else {
        filters.add(filter);
      }

      scores.clear();
      for (var row in playerScores) {
        if (filters.contains(row['mode'])) {
          scores.add(row);
        }
      }
      if (scores.isEmpty) scores.addAll(playerScores);
    });
  }

  @override
  void initState() {
    getLeaderBoard(update, error);
    setState(() {
      loading = true;
    });
    super.initState();
  }

  void update(List scores) {
    setState(() {
      this.scores = scores;
      loading = false;
      errorMessage = false;
    });
  }

  void error(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.black,
    ));
    setState(() {
      loading = false;
      errorMessage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
                width: double.infinity,
                height: 200,
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const MyTextWidget(
                      text: "1st Player",
                      color: Colors.white,
                      textSize: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                          size: 50,
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyTextWidget(
                              text: scores.isNotEmpty
                                  ? scores[0]['username']
                                  : '',
                              color: Colors.white,
                            ),
                            MyTextWidget(
                              text:
                                  "${scores.isNotEmpty ? scores[0]['score'] : ''} words",
                              color: Colors.white,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
            Container(
              height: 70,
              color: Colors.grey.shade200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          activeColor: Colors.black,
                          value: filters.contains('easy') ? true : false,
                          onChanged: (check) {
                            filter('easy');
                          }),
                      const MyTextWidget(text: "easy", textSize: 12),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          activeColor: Colors.black,
                          value: filters.contains('normal') ? true : false,
                          onChanged: (check) {
                            filter('normal');
                          }),
                      const MyTextWidget(text: "normal", textSize: 12),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Checkbox(
                          activeColor: Colors.black,
                          value: filters.contains('hard') ? true : false,
                          onChanged: (check) {
                            filter('hard');
                          }),
                      const MyTextWidget(
                        text: "hard",
                        textSize: 12,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            errorMessage
                ? SizedBox(
                height: MediaQuery.of(context).size.height - 330,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MyTextWidget(
                      text: "Connection Error",
                      textSize: 40,
                      color: Colors.grey.shade400,
                    ),
                    Icon(
                      Icons.signal_wifi_connected_no_internet_4_rounded,
                      size: 50,
                      color: Colors.grey.shade400,
                    )
                  ],
                ))
                : scores.isNotEmpty
                    ? Expanded(
                        child: ListView.builder(
                          itemCount: scores.length,
                          itemBuilder: (context, index) {
                            if (true) {
                              return ListTile(
                                title: Text(scores[index]['username']),
                                subtitle:
                                    Text("${scores[index]['score']} words"),
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Colors.grey.shade200,
                                  ),
                                  child: Center(
                                    child: Text(
                                        '${index > 0 && index < scores.length && scores[index]['score'] == scores[index - 1]['score'] ? index : index + 1}'),
                                  ),
                                ),
                                trailing: Text(scores[index]['mode']),
                              );
                            }
                          },
                        ),
                      )
                    : SizedBox(
                        height: MediaQuery.of(context).size.height - 330,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            MyTextWidget(
                              text: "Empty",
                              textSize: 40,
                              color: Colors.grey.shade400,
                            ),
                            Icon(
                              Icons.hourglass_empty,
                              size: 50,
                              color: Colors.grey.shade400,
                            )
                          ],
                        )),
          ],
        ),
        Loader(loading: loading)
      ],
    );
  }
}

void getLeaderBoard(
    Function(List s) update, Function(String text) error) async {
  try {
    final url = Uri.https(_baseURL, 'getLeaderBoard.php');
    final response = await http.get(url).timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      List scores = [];
      for (var row in jsonResponse) {
        scores.add(row);
        playerScores.add(row);
      }
      update(scores);
    }
  } catch (e) {
    error("Unable to load data");
  }
}
