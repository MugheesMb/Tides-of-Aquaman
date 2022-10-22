import 'package:flutter/material.dart';
import 'package:game2/game/Home.dart';
import 'package:game2/screens/mainMenu.dart';
import 'package:game2/widgets/pause.dart';

class GameOverMenu extends StatelessWidget {
  static const String ID = 'GameOverMenu';
  final SpaceWater gameRef;

  const GameOverMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Text(
            'Game Over',
            style: TextStyle(
              fontSize: 50.0,
              color: Colors.black,
              shadows: [
                Shadow(
                  blurRadius: 20.0,
                  color: Colors.white,
                  offset: Offset(0, 0),
                )
              ],
            ),
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove(GameOverMenu.ID);
              gameRef.overlays.add(PauseButton.ID);
              gameRef.reset();
              gameRef.resumeEngine();
            },
            child: Text('Restart'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove(GameOverMenu.ID);
              gameRef.reset();
              gameRef.resumeEngine();

              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const MainMenu(),
              ));
            },
            child: Text('Exit'),
          ),
        ),
      ],
    ));
  }
}
