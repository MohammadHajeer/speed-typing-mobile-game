import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:speed_type_game/login.dart';
import 'package:speed_type_game/score.dart';
import 'package:speed_type_game/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'player.dart';

String _baseURL = "https://hajeerspeedtypegame.000webhostapp.com";
int key = 123;

EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences();

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});

  @override
  State<AccountTab> createState() => _AccountTabState();
}

class _AccountTabState extends State<AccountTab> {
  String name = "";

  // Player player = Player(0, '', '');
  bool loading = false;
  List scores = <Score>[];
  List playerData = <Player>[];
  bool gotError = false;

  void update(List p, List s) {
    setState(() {
      playerData = p;
      loading = false;
      scores = s;
    });
  }

  void error(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(text),
      backgroundColor: Colors.black,
    ));
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    encryptedSharedPreferences.getString('id').then((String value) {
      if (value.isNotEmpty) {
        getPlayer(update, error);
        setState(() {
          loading = true;
        });
      }
    });
  }

  void logout() {
    encryptedSharedPreferences.clear();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Login()));
  }

  Future<bool> checkLogin() async {
    bool check = false;
    await encryptedSharedPreferences.getString('id').then((String value) {
      if (value.isNotEmpty) {
        check = true;
      }
    });

    return check;
  }

  void showPopupMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  size: 50,
                ),
                MyTextWidget(
                  text: playerData[0]['username'],
                ),
                MyTextWidget(
                  text: playerData[0]['email'],
                  color: Colors.grey,
                )
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: playerData.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 5),
                      color: Colors.grey.shade300,
                      child: Column(
                        children: [
                          MyTextWidget(
                            text: "Mode: ${playerData[index]['mode']}",
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          MyTextWidget(
                            text:
                                "Total Games Played: ${playerData[index]['games']}",
                            textSize: 10,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          MyTextWidget(
                            text:
                            "Best Score: ${playerData[index]['bestScore']}",
                            textSize: 10,
                          ),

                        ],
                      ));
                },
              ),
            ),
            actions: [
              MyButton(onPressed: () => Navigator.of(context).pop(), text: "Cancel")
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: checkLogin(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Stack(
              children: [
                (snapshot.data ?? false)
                    ? Container(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ListTile(
                                  title: Text(playerData.isNotEmpty
                                      ? playerData[0]['username']
                                      : ''),
                                  subtitle: Text(playerData.isNotEmpty
                                      ? playerData[0]['email']
                                      : ''),
                                  leading: const Icon(
                                    Icons.account_circle_outlined,
                                    size: 50,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.show_chart),
                                    onPressed: () {
                                      showPopupMessage(context);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: const Icon(Icons.history),
                                      title: const Text("Scores History"),
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    MyScorePage(list: scores)));
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.logout),
                                      title: const Text("Logout"),
                                      onTap: logout,
                                    ),
                                    gotError
                                        ? MyButton(
                                            onPressed: () {
                                              getPlayer(update, error);
                                              setState(() {
                                                loading = true;
                                              });
                                            },
                                            text: "Retry")
                                        : const SizedBox()
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    : Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.do_not_disturb_on_outlined,
                              size: 40,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const MyTextWidget(
                              textSize: 25,
                              text: "You are not signed in",
                            ),
                            const Divider(),
                            const SizedBox(
                              height: 10,
                            ),
                            MyButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => const Login()));
                                },
                                text: "Login Here")
                          ],
                        ),
                      ),
                Loader(loading: loading)
              ],
            );
          }
        }
      },
    );
  }
}

void getPlayer(Function(List playerData, List scores) update,
    Function(String text) error) async {
  try {
    String playerId = await encryptedSharedPreferences.getString('id');
    final response = await http
        .post(Uri.parse('$_baseURL/getPlayer.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: convert
                .jsonEncode(<String, String>{'id': playerId, 'key': '$key'}))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      List playerScores = [];
      for (var row in convert.jsonDecode(response.body)['scores']) {
        playerScores.add(row);
      }

      List playerData = [];
      for (var row in convert.jsonDecode(response.body)['data']) {
        playerData.add(row);
      }

      update(playerData, playerScores);
    }
  } catch (e) {
    error("connection error");
  }
}
