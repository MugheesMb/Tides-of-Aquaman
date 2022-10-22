import 'package:flutter/material.dart';
import 'package:game2/game/Home.dart';
import 'package:game2/screens/mainMenu.dart';
import 'package:game2/widgets/pause.dart';

class PauseMenu extends StatelessWidget {
  static const String ID = 'PauseMenu';
  final SpaceWater gameRef;

  const PauseMenu({Key? key, required this.gameRef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 50.0),
          child: Text(
            'Paused',
            style: TextStyle(
              fontSize: 50.0,
              fontFamily: 'BungeeInline',
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
              gameRef.resumeEngine();
              gameRef.overlays.remove(PauseMenu.ID);
              gameRef.overlays.add(PauseButton.ID);
            },
            child: Text('Resume'),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: ElevatedButton(
            onPressed: () {
              gameRef.overlays.remove(PauseMenu.ID);
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
              gameRef.overlays.remove(PauseMenu.ID);
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
