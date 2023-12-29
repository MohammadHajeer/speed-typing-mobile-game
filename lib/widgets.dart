import 'package:flutter/material.dart';

class MyTextWidget extends StatelessWidget {
  final String text;
  final double textSize;
  final Color color;
  final FontWeight fontWeight;

  const MyTextWidget(
      {this.text = "",
      this.textSize = 16,
      this.color = Colors.black,
      this.fontWeight = FontWeight.normal,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          TextStyle(color: color, fontSize: textSize, fontWeight: fontWeight),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String label;
  final String placeHolder;
  final Icon icon;
  final bool obsecure;
  final bool enableSugguestions;
  final bool autoCorrect;
  final TextEditingController controller;
  final double textSize;

  const MyTextFormField(
      {required this.label,
      required this.placeHolder,
      required this.icon,
      required this.controller,
      this.textSize = 16,
      this.obsecure = false,
      this.enableSugguestions = true,
      this.autoCorrect = true,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyTextWidget(
          text: label,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10),
          decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(10)),
          child: TextFormField(
            controller: controller,
            enableSuggestions: enableSugguestions,
            autocorrect: autoCorrect,
            obscureText: obsecure,
            cursorColor: Colors.black,
            decoration: InputDecoration(
                floatingLabelBehavior: FloatingLabelBehavior.never,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none),
                label: MyTextWidget(
                  text: placeHolder,
                  color: Colors.grey.shade400,
                ),
                icon: icon),
            style: TextStyle(letterSpacing: 1.5, fontSize: textSize),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "please fill the required field";
              }
              return null;
            },
          ),
        )
      ],
    );
  }
}

class MyButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const MyButton({required this.onPressed, required this.text, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
            backgroundColor: Colors.black,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        child: MyTextWidget(
          text: text,
          color: Colors.white,
        ),
      ),
    );
  }
}

class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: double.infinity,
      child: Column(
        children: [
          MyTextWidget(
            text: "Speed Type Game",
            textSize: 30,
            fontWeight: FontWeight.w900,
          ),
          Icon(
            Icons.keyboard_alt_outlined,
            size: 80,
          ),
        ],
      ),
    );
  }
}

class Loader extends StatelessWidget {
  final bool loading;

  const Loader({required this.loading, super.key});

  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: loading,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromRGBO(0, 0, 0, 0.5),
          child: Center(
            child: Container(
              width: 200,
              height: 200,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: const CircularProgressIndicator(
                color: Colors.black,
                strokeWidth: 5,
              ),
            ),
          ),
        ));
  }
}

class GameMode extends StatelessWidget {
  final Function() onPressed;
  final String modeName;
  final String modeDescription;

  const GameMode(
      {required this.modeName,
      required this.modeDescription,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey.shade200),
      child: Column(
        children: [
          Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                  image: const DecorationImage(
                      image: AssetImage("assets/keyboard_2.jpg"),
                      fit: BoxFit.cover,
                      opacity: 0.4),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black),
              child: TextButton(
                style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                )),
                onPressed: onPressed,
                child: MyTextWidget(
                  text: "$modeName Mode",
                  color: Colors.white,
                ),
              )),
           Padding(
            padding: const EdgeInsets.all(10),
            child: MyTextWidget(
              textSize: 12,
              text: modeDescription,
            ),
          )
        ],
      ),
    );
  }
}
