import 'dart:async';

import 'package:flutter/material.dart';
import 'words_list.dart';
import 'dart:math';
import 'score.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List _scores = [];
  int _countScore = 0;
  String _chosenWord =
      gameDifficulties[0][Random().nextInt(gameDifficulties.length)];
  String _difficulty = "easy";
  List<String> _chosenList = gameDifficulties[0].map((e) => e).toList(); // easy
  bool _startGame = false;
  int _seconds = 30;
  double milliSecond = 30;
  final TextEditingController _textController = TextEditingController();

  void calculateSeconds() {}

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void startTimer() {
    const duration = Duration(milliseconds: 100);

    Timer.periodic(duration, (timer) {
      if (milliSecond > 0 && _startGame) {
        setState(() {
          milliSecond -= 0.1;
        });
      } else {
        if (_countScore > 0) {
          showPopupMessage(context);
          _scores.add({
            "words": "$_countScore",
            "time": (30 - milliSecond).toStringAsFixed(1),
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
      milliSecond = 30;
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
                        "$_countScore words in ${(30 - milliSecond).toStringAsFixed(1)} seconds",
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
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Speed Type Game",
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: "OxygenMono-Regular",
                fontWeight: FontWeight.w700),
          ),
          centerTitle: false,
          backgroundColor: Colors.black,
          actions: [
            Container(
              margin: const EdgeInsets.all(5),
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {
                  resetGame();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return MyScorePage(list: _scores);
                  }));
                },
                icon: const Icon(Icons.scoreboard_rounded),
                color: Colors.black,
                tooltip: "score page",
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.cover,
            )),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: ((context) {
                              return AlertDialog(
                                content: Container(
                                    height: 300,
                                    child: const Scrollbar(
                                      thumbVisibility: true,
                                      thickness: 5,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text("""Game Modes:

Easy: Beginner-friendly.
Normal: Balanced challenge.
Hard: Advanced, longer words.

Game Flow:

Select Mode:

Choose: Easy, Normal, Hard.
Pick your speed.

Start Game:

Press "Start" for a 30-sec challenge.

Typing:

Type quickly and accurately.
Correct words boost your score.
Cancellation:

Press "Cancel" to stop early.
Scoring:

Earn points for each correct word.
Longer words give higher scores.

End Game:

After 30 seconds, see your final score.
Move to the next page for details.
"""),
                                        ),
                                      ),
                                    )),
                              );
                            }));
                      },
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white)),
                      child: const MyTextWidget(
                        text: "Game Rules",
                        color: Colors.black,
                        textSize: 16,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.only(
                              top: 5, bottom: 5, left: 10, right: 10),
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
                            color: Colors.white,
                          ),
                          tooltip: "game difficulties",
                          shadowColor: Colors.black,
                        ),
                      ],
                    )
                  ],
                ),
                Container(
                    width: double.infinity,
                    height: 200,
                    margin: const EdgeInsets.only(top: 20),
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(155, 0, 0, 0),
                        borderRadius: BorderRadius.circular(20),
                        image: const DecorationImage(
                            image: AssetImage('assets/bg-2.jpg'),
                            fit: BoxFit.cover,
                            opacity: 0.4,
                            alignment: Alignment.bottomRight)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          _chosenWord,
                          style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: "OxygenMono-Regular",
                              letterSpacing: 5),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(
                              top: 3, bottom: 3, right: 10, left: 10),
                          child: Text(
                            milliSecond.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontFamily: "OxygenMono-Regular",
                              fontWeight: FontWeight.w900,
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
        ));
  }

  Widget _textField() {
    return TextField(
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
                "time": "${30 - _seconds}",
                "mode": _difficulty
              });
              showPopupMessage(context);
            } else {
              getNextWord();
            }
          }
        });
      },
    );
  }

  Widget _startAndCancelGameButton(String s) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              s == "s" ? _startGame = true : resetGame();
            });
            if (s == "s") startTimer();
          },
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white)),
          child: MyTextWidget(
              text: s == "s" ? "START GAME" : "CANCEL GAME",
              textSize: 20,
              color: Colors.black)),
    );
  }
}

class MyTextWidget extends StatelessWidget {
  final String text;
  final double textSize;
  final Color color;
  const MyTextWidget(
      {required this.text,
      required this.textSize,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          color: color, fontSize: textSize, fontFamily: "OxygenMono-Regular"),
    );
  }
}
