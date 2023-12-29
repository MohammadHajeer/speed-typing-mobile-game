import 'package:flutter/material.dart';
import 'package:speed_type_game/game.dart';
import 'package:speed_type_game/widgets.dart';

class ModesTab extends StatelessWidget {
  const ModesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            GameMode(
                modeName: "Word",
                modeDescription: "Test your quick reflexes and typing "
                    "speed in Word Writing Mode. Race against the"
                    " clock to type individual words accurately. This mode"
                    " is perfect for quick, bite-sized challenges, allowing"
                    " players to focus on typing speed and agility. Great for"
                    " a fast-paced and exciting typing experience.",
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const Game()));
                }),
            const SizedBox(
              height: 20,
            ),
            const MyTextWidget(
              textSize: 30,
              text: "New modes are on the way",
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
