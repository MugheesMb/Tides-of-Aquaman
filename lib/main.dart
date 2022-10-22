import 'package:flame/components.dart';
import 'package:flutter/material.dart';
//import 'package:game/home/Home.dart';
import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:game2/game/Home.dart';
import 'package:game2/screens/mainMenu.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // This opens the app in fullscreen mode.
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();
  runApp(
    MaterialApp(
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'BungeeInline',
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const MainMenu(),
    ),
  );
}
