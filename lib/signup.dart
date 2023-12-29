import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:speed_type_game/widgets.dart';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'home.dart';

String _baseURL = "https://hajeerspeedtypegame.000webhostapp.com";
int key = 123;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  EncryptedSharedPreferences encryptedSharedPreferences =
      EncryptedSharedPreferences();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  bool _loading = false;

  void clearForm() {
    _formKey.currentState!.reset();
    emailController.clear();
    passwordController.clear();
    usernameController.clear();
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
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
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
                        text: "SignUp,",
                        textSize: 30,
                        fontWeight: FontWeight.w900,
                      ),
                      TextButton(
                          style: TextButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                          onPressed: () {
                            _formKey.currentState!.reset();
                            Navigator.of(context).pop();
                          },
                          child: const MyTextWidget(
                            text: "Return to Login",
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
                              controller: usernameController,
                              label: "Username",
                              placeHolder: "ex: Mohammad",
                              icon: const Icon(Icons.email)),
                          const SizedBox(
                            height: 20,
                          ),
                          MyTextFormField(
                              controller: emailController,
                              label: "Email",
                              placeHolder: "ex: w@gmail.com",
                              icon: const Icon(Icons.person)),
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
                            text: "SignUp",
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _loading = true;
                                });

                                addUser(
                                    update,
                                    usernameController.text.toString(),
                                    emailController.text.toString(),
                                    passwordController.text.toString());
                              }
                            },
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
          Loader(loading: _loading)
        ],
      ),
    );
  }
}

void addUser(Function(String text) update, String username, String email,
    String password) async {
  try {
    final response = await http
        .post(Uri.parse('$_baseURL/signup.php'),
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
            body: convert.jsonEncode(<String, String>{
              'username': username,
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
