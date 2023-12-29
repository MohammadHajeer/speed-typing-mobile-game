import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:speed_type_game/game.dart';
import 'package:speed_type_game/home.dart';
import 'package:speed_type_game/signup.dart';
import 'package:speed_type_game/widgets.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

String _baseURL = "https://hajeerspeedtypegame.000webhostapp.com";
int key = 123;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _loading = true;

  void checkLogin() {
    encryptedSharedPreferences.getString('id').then((String value) {
      if (value.isNotEmpty) {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const Home()));
      }
    });
    _loading = false;
  }

  void clearForm() {
    _formKey.currentState!.reset();
    emailController.clear();
    passwordController.clear();
  }

  void update(String text) {
    try {
      int id = int.parse(text);
      clearForm();
      encryptedSharedPreferences.setString('id', '$id').then((bool success) {
        if (success) {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Home()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Failed to sign user"),
            backgroundColor: Colors.black,
          ));
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(text),
        backgroundColor: Colors.black,
      ));
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/game_bg.jpg"),
                  opacity: 0.4,
                  fit: BoxFit.cover)),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const GameHeader(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const MyTextWidget(
                      text: "Welcome,",
                      textSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        onPressed: () {
                          _formKey.currentState!.reset();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const Signup()));
                        },
                        child: const MyTextWidget(
                          text: "SignUp",
                        ))
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        MyTextFormField(
                            controller: emailController,
                            label: "Email",
                            placeHolder: "ex: w@gmail.com",
                            icon: const Icon(Icons.email)),
                        const SizedBox(
                          height: 20,
                        ),
                        MyTextFormField(
                          controller: passwordController,
                          label: "Password",
                          placeHolder: "**********",
                          enableSugguestions: false,
                          autoCorrect: false,
                          icon: const Icon(Icons.lock),
                          obsecure: true,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        MyButton(
                          text: "Login",
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _loading = true;
                              });
                              addUser(update, emailController.text.toString(),
                                  passwordController.text.toString());
                            }
                          },
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      color: Colors.grey.shade800,
                      height: 3,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                    const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: MyTextWidget(
                          text: "OR",
                          fontWeight: FontWeight.bold,
                        )),
                    Container(
                      color: Colors.grey.shade800,
                      height: 3,
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                MyButton(
                  text: "Continue as Guest",
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Home()));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        Loader(loading: _loading)
      ],
    ));
  }
}

void addUser(
    Function(String text) update, String email, String password) async {
  try {
    final response = await http
        .post(Uri.parse('$_baseURL/login.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: convert.jsonEncode(<String, String>{
              'email': email,
              'password': password,
              'key': '$key'
            }))
        .timeout(const Duration(seconds: 5));
    if (response.statusCode == 200) {
      update(response.body);
    }
  } catch (e) {
    update("connection error");
  }
}
