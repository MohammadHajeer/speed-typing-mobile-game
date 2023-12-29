import 'package:flutter/material.dart';
import 'widgets.dart';

class MyScorePage extends StatefulWidget {
  final List list;

  const MyScorePage({required this.list, super.key});

  @override
  State<MyScorePage> createState() => _MyScorePageState();
}

class _MyScorePageState extends State<MyScorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const MyTextWidget(
          text: "Scores",
        ),
        backgroundColor: Colors.grey.shade200,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_circle_left,
            color: Colors.black,
            size: 40,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/game_bg.jpg"), fit: BoxFit.cover)),
        child: widget.list.isEmpty
            ? Container(
                decoration:
                    const BoxDecoration(color: Color.fromARGB(155, 0, 0, 0)),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: const Center(
                  child: Text(
                    "NO SCORES YET !",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white),
                  ),
                ))
            : ListView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: widget.list.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(26, 255, 255, 255),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ListTile(
                      title: MyTextWidget(
                          text:
                              "${widget.list.elementAt(index)['wordsCount']} words",
                          textSize: 16,
                          color: Colors.white),
                      subtitle: MyTextWidget(
                          text:
                              "In ${widget.list.elementAt(index)['time']} seconds",
                          textSize: 16,
                          color: Colors.white),
                      leading: Container(
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          child: const Icon(
                            Icons.sports_score_sharp,
                            color: Colors.black,
                          )),
                      titleAlignment: ListTileTitleAlignment.center,
                      trailing: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.all(5),
                          child: Text(
                            widget.list.elementAt(index)['mode'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 25),
                          )),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
