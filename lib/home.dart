import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:speed_type_game/account_tab.dart';
import 'package:speed_type_game/game.dart';
import 'package:speed_type_game/home_tab.dart';
import 'package:speed_type_game/login.dart';
import 'package:speed_type_game/modes_tab.dart';

EncryptedSharedPreferences encryptedSharedPreferences =
    EncryptedSharedPreferences();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _pageIndex = 1;

  // @override
  // void initState() {
  //   super.initState();
  //   checkLogin();
  // }
  //
  // void checkLogin() {
  //   encryptedSharedPreferences.getString('id').then((String value) {
  //     if (value.isNotEmpty) {
  //       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //         content: Text(value),
  //         backgroundColor: Colors.black,
  //       ));
  //     }
  //   });
  // }

  final List _tabs = <Widget>[
    const HomeTab(),
    const ModesTab(),
    const AccountTab()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _tabs[_pageIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedFontSize: 12,
          currentIndex: _pageIndex,
          items: const [
            BottomNavigationBarItem(
                label: "Home",
                icon: Icon(Icons.home),
                activeIcon: Icon(Icons.home_filled)),
            BottomNavigationBarItem(
                label: "Modes",
                icon: Icon(Icons.gamepad),
                activeIcon: Icon(Icons.gamepad_outlined)),
            BottomNavigationBarItem(
                label: "Account",
                icon: Icon(Icons.person),
                activeIcon: Icon(Icons.person_2))
          ],
          onTap: (index) => setState(() {
                _pageIndex = index;
              })),
    );
  }
}
