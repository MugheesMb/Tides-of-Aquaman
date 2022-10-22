import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:game2/game/Home.dart';
import 'package:game2/widgets/gameoverMenu.dart';
import 'package:game2/widgets/pause.dart';
import 'package:game2/widgets/pause_menu.dart';

SpaceWater _spaceWater = SpaceWater();

class GamePlay extends StatelessWidget {
  const GamePlay({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: GameWidget(
          game: _spaceWater,
          initialActiveOverlays: [PauseButton.ID],
          overlayBuilderMap: {
            PauseButton.ID: (BuildContext context, SpaceWater gameRef) =>
                PauseButton(
                  gameRef: gameRef,
                ),
            PauseMenu.ID: (BuildContext context, SpaceWater gameRef) =>
                PauseMenu(
                  gameRef: gameRef,
                ),
            GameOverMenu.ID: (BuildContext context, SpaceWater gameRef) =>
                GameOverMenu(
                  gameRef: gameRef,
                ),
          },
        ));
  }
}
