import 'dart:async';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'words_list.dart';
import 'dart:math';
import 'score.dart';
import 'widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

EncryptedSharedPreferences encryptedSharedPreferences =
EncryptedSharedPreferences();
String _baseURL = "https://hajeerspeedtypegame.000webhostapp.com";
int key = 123;

class Game extends StatefulWidget {
  const Game({super.key});

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final List _scores = [];
  int _countScore = 0;
  String _chosenWord =
  gameDifficulties[0][Random().nextInt(gameDifficulties.length)];
  String _difficulty = "easy";
  List<String> _chosenList = gameDifficulties[0].map((e) => e).toList(); // easy
  bool _startGame = false;
  double _time = 30;
  final TextEditingController _textController = TextEditingController();

  void update(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.black,
    ));
  }

  @override
  void initState() {
    encryptedSharedPreferences.getString('id').then((String value) {
      if(value.isEmpty) {
        update('Welcome, you need to login inorder to save your data');
      } else {
        update('Welcome, have fun !');
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(milliseconds: 100);

    Timer.periodic(duration, (timer) {
      if (_time > 0 && _startGame) {
        setState(() {
          _time -= 0.1;
        });
      } else {
        if (_countScore > 0) {
          showPopupMessage(context);
          addScore(update, _countScore, double.parse((30 - _time).toStringAsFixed(1)), _difficulty);
          _scores.add({
            "words": "$_countScore",
            "time": (30 - _time).toStringAsFixed(1),
            "mode": _difficulty
          });
        } else {
          resetGame();
        }
        timer.cancel();
      }
    });
  }

  void resetGame() {
    setState(() {
      _time = 30;
      _startGame = false;
      _difficulty = "easy";
      setList(0);
      _textController.text = "";
      _countScore = 0;
    });
  }

  void getNextWord() {
    setState(() {
      if (_chosenList.isNotEmpty) {
        _chosenList.remove(_chosenWord);
        if (_chosenList.isEmpty) {
          resetGame();
        } else {
          int random = Random().nextInt(_chosenList.length);
          _chosenWord = _chosenList[random];
          _textController.text = "";
        }
      } else {
        resetGame();
      }
    });
  }

  void setList(int index) {
    _chosenList = gameDifficulties[index].map((e) => e).toList();
    _chosenWord =
    gameDifficulties[index][Random().nextInt(gameDifficulties.length)];
  }

  void showPopupMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return WillPopScope(
              child: AlertDialog(
                title: const MyTextWidget(
                    text: "YOUR SCORE", textSize: 20, color: Colors.black),
                content: MyTextWidget(
                    text:
                    "$_countScore ${_countScore > 1
                        ? 'words'
                        : 'word'} in ${(30 - _time).toStringAsFixed(
                        1)} seconds",
                    textSize: 18,
                    color: Colors.black),
                actions: [
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        resetGame();
                      },
                      style: ButtonStyle(
                          backgroundColor:
                          MaterialStateProperty.all(Colors.black)),
                      child: const MyTextWidget(
                          text: "Try Again !",
                          textSize: 14,
                          color: Colors.white))
                ],
              ),
              onWillPop: () async {
                resetGame();
                return true;
              });
        });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> splitWordRow = [];
    int countSimilar = 0;
    int countDifferences = 0;

    if (_textController.text != '') {
      String word = "";
      for (var i = 0; i < _textController.text.length; i++) {
        word += _textController.text[i];
        if (_chosenWord.startsWith(word)) {
          countSimilar++;
        } else {
          countDifferences++;
        }
      }
    }

    for (var i = 0; i < _chosenWord.length; i++) {
      splitWordRow.add(Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
            color: i < countSimilar
                ? const Color.fromARGB(146, 7, 206, 123)
                : i < (countDifferences + countSimilar)
                ? const Color.fromARGB(202, 244, 67, 54)
                : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey)),
        child: Center(
          child: Text(
            _chosenWord[i],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        title: const MyTextWidget(
          text: "Speed Type Game",
          color: Colors.black,
          fontWeight: FontWeight.w900,
          textSize: 25,
        ),
        centerTitle: false,
        backgroundColor: Colors.white,
        // actions: [
        //   Container(
        //     margin: const EdgeInsets.all(5),
        //     // width: 60,
        //     decoration: BoxDecoration(
        //       color: Colors.grey.shade200,
        //       shape: BoxShape.circle,
        //     ),
        //     child: IconButton(
        //       onPressed: () {
        //         resetGame();
        //         Navigator.push(context,
        //             MaterialPageRoute(builder: (BuildContext context) {
        //               return MyScorePage(list: _scores);
        //             }));
        //       },
        //       icon: const Icon(Icons.scoreboard_rounded),
        //       color: Colors.black,
        //       tooltip: "score page",
        //     ),
        //   )
        // ],
      ),
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/keyboard_1.jpg"),
              fit: BoxFit.cover,
            )),
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: MediaQuery
                        .of(context)
                        .size
                        .width - 100,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      _difficulty,
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "OxygenMono-Regular",
                          letterSpacing: 3,
                          color: Colors.black),
                    ),
                  ),
                  PopupMenuButton(
                    enabled: !_startGame,
                    onSelected: (value) {
                      setState(() {
                        _difficulty = value;
                        switch (value) {
                          case "easy":
                            setList(0);
                            break;
                          case "normal":
                            setList(1);
                            break;
                          default:
                            setList(2);
                        }
                      });
                    },
                    itemBuilder: ((context) {
                      return [
                        PopupMenuItem(
                          value: "easy",
                          child: Text(
                            "Easy - beginner",
                            style: TextStyle(
                                backgroundColor: _difficulty == "easy"
                                    ? Colors.limeAccent
                                    : Colors.white),
                          ),
                        ),
                        PopupMenuItem(
                          value: "normal",
                          child: Text(
                            "Normal - intermediate",
                            style: TextStyle(
                                backgroundColor: _difficulty == "normal"
                                    ? Colors.orangeAccent
                                    : Colors.white),
                          ),
                        ),
                        PopupMenuItem(
                          value: "hard",
                          child: Text(
                            "Hard - proffesional",
                            style: TextStyle(
                                backgroundColor: _difficulty == "hard"
                                    ? Colors.redAccent
                                    : Colors.white),
                          ),
                        ),
                      ];
                    }),
                    icon: const Icon(
                      Icons.category,
                      color: Colors.black,
                    ),
                    tooltip: "game difficulties",
                    shadowColor: Colors.black,
                  ),
                ],
              ),
              Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Color.fromRGBO(0, 0, 0, 0.6),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)),
                    image: DecorationImage(
                        image: AssetImage('assets/bg-2.jpg'),
                        fit: BoxFit.cover,
                        opacity: 0.4,
                        alignment: Alignment.topCenter),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height: 5,
                          child: LinearProgressIndicator(
                            value: _countScore / 35,
                            backgroundColor: Colors.grey,
                            valueColor:
                            const AlwaysStoppedAnimation(Colors.black),
                          )),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              constraints: const BoxConstraints(maxWidth: 340),
                              child: Wrap(
                                runSpacing: 5,
                                spacing: 5,
                                alignment: WrapAlignment.center,
                                children: splitWordRow,
                              ),
                            )
                          ]),
                      Container(
                        width: double.infinity,
                        height: 50,
                        decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            color: Color.fromARGB(161, 0, 0, 0)),
                        padding: const EdgeInsets.only(
                            top: 3, bottom: 3, right: 10, left: 10),
                        child: Center(
                          child: Text(
                            _time.toStringAsFixed(1),
                            style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontFamily: "OxygenMono-Regular",
                                fontWeight: FontWeight.w900,
                                letterSpacing: 2),
                          ),
                        ),
                      )
                    ],
                  )),
              const SizedBox(
                height: 20,
              ),
              _startGame
                  ? Column(
                children: [
                  _textField(),
                  const SizedBox(
                    height: 10,
                  ),
                  _startAndCancelGameButton("r")
                ],
              )
                  : _startAndCancelGameButton("s")
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField() {
    return TextField(
      maxLength: _chosenWord.length,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 25,
        fontWeight: FontWeight.bold,
        letterSpacing: 3,
      ),
      autofocus: true,
      controller: _textController,
      cursorColor: Colors.white,
      decoration: InputDecoration(
          labelText: "Start writing",
          labelStyle: const TextStyle(
            color: Colors.white,
          ),
          filled: true,
          fillColor: const Color.fromARGB(174, 0, 0, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
                color: Color.fromARGB(121, 255, 255, 255), width: 5),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: const BorderSide(
                  color: Color.fromARGB(166, 255, 255, 255), width: 5)),
          floatingLabelBehavior: FloatingLabelBehavior.never),
      onChanged: (text) {
        setState(() {
          if (_textController.text == _chosenWord) {
            _countScore++;
            if (_chosenList.length == 1) {
              _startGame = false;
              _scores.add({
                "words": "$_countScore",
                "time": "${30 - _time}",
                "mode": _difficulty
              });
              showPopupMessage(context);
            } else {
              getNextWord();
            }
          }
        });
      },
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
    );
  }

  Widget _startAndCancelGameButton(String s) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: MyButton(
        onPressed: () {
          setState(() {
            s == "s" ? _startGame = true : resetGame();
          });
          if (s == "s") {
            startTimer();

          };
        },
        text: s == "s" ? "START GAME" : "CANCEL GAME",
      ),
    );
  }
}

void addScore(Function(String text) update, int wordCount, double time,
    String mode) async {
  try {
    String playerId = await encryptedSharedPreferences.getString('id');
    if(playerId.isNotEmpty) {
      final response = await http
          .post(Uri.parse('$_baseURL/addScore.php'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: convert.jsonEncode(<String, String>{
            'playerId': playerId,
            'wordCount': '$wordCount',
            'time': '$time',
            'mode': mode,
            'key': '$key'
          }))
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        update(response.body);
      }
    }
  } catch (e) {
    update("connection error");
  }
}
