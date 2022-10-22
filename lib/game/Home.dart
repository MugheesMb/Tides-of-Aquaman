import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/material.dart';
import 'package:game2/game/animatedplayer.dart';
import 'package:game2/game/bullet.dart';
import 'package:game2/game/command.dart';
import 'package:game2/game/enemy.dart';
import 'package:game2/game/enemymanager.dart';
import 'package:game2/game/healthbar.dart';
import 'package:game2/game/knowGameSize.dart';
import 'package:game2/game/player.dart';
import 'package:game2/widgets/gameoverMenu.dart';
import 'package:game2/widgets/pause.dart';
import 'package:game2/widgets/pause_menu.dart';

class SpaceWater extends FlameGame
    with TapDetector, HasCollisionDetection, HasDraggables {
  static const _imageAssets = [
    'spritemb.png',
  ];

  late Player _player;
  late Sprite _sprite;
  late Sprite bulet;
  late Sprite mb;
  late AnimatedPlayer animated;
  late SpriteSheet enemy;
  late SpriteSheet spriteSheet;
  late EnemyManager _enemyManager;
  late TextComponent _playerScore;
  late TextComponent _PlayerHealth;
  late SpriteAnimationComponent playmb;
  // List of commands to be processed in current update.
  final _commandList = List<Command>.empty(growable: true);

  // List of commands to be processed in next update.
  final _addLaterCommandList = List<Command>.empty(growable: true);

  bool _isAlreadyLoaded = false;

  @override
  Future<void> onLoad() async {
    Flame.device.setLandscapeRightOnly();
    await loadSprite('spritemb.png');

    bulet = await loadSprite('enemy.png');
    await loadSprite('enemyspace.png');
    if (!_isAlreadyLoaded) {
      enemy = SpriteSheet.fromColumnsAndRows(
        image: images.fromCache('enemyspace.png'),
        columns: 8,
        rows: 6,
      );

      _sprite = await loadSprite('aqua.gif');

      // final stars = await ParallaxComponent.load(
      //   [ParallaxImageData('bg1.png'), ParallaxImageData('bg.png')],
      //   repeat: ImageRepeat.repeat,
      //   baseVelocity: Vector2(0, -50),
      //   velocityMultiplierDelta: Vector2(0, 1.5),
      // );
      // add(stars);

      final para = await ParallaxComponent.load(
        [
          ParallaxImageData('bg.png'),
          ParallaxImageData('far.png'),
          ParallaxImageData('sand.png'),
          ParallaxImageData('foregound-merged.png'),
        ],
        baseVelocity: Vector2(10, 0),
        velocityMultiplierDelta: Vector2(1.6, 0),
      );
      add(para);

      final _joystick = JoystickComponent(
        anchor: Anchor.bottomLeft,
        position: Vector2(30, size.y - 30),
        // size: 100,
        background: CircleComponent(
          radius: 60,
          paint: Paint()..color = Colors.white.withOpacity(0.5),
        ),
        knob: CircleComponent(radius: 30),
      );
      add(_joystick);

      _playerScore = TextComponent(
        text: 'Score: 0',
        position: Vector2(5, 5),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontFamily: 'BungeeInline',
          ),
        ),
      );
      _playerScore.positionType = PositionType.viewport;

      add(_playerScore);

      // Create text component for player health.
      _PlayerHealth = TextComponent(
        text: 'Health: 100%',
        position: Vector2(size.x - 0, 1),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Color.fromARGB(255, 245, 245, 245),
            fontSize: 32,
            fontFamily: 'BungeeInline',
          ),
        ),
      );
      _PlayerHealth.anchor = Anchor.topRight;
      _PlayerHealth.positionType = PositionType.viewport;
      add(_PlayerHealth);

      this.camera.defaultShakeIntensity = 6;

      _player = Player(
        joystick: _joystick,
        sprite: _sprite,
        size: Vector2(130, 134),
        position: size / 2,
      );

      _player.anchor = Anchor.center;

      add(_player);
      _enemyManager = EnemyManager(spriteSheet: enemy);
      add(_enemyManager);

      // animated = AnimatedPlayer(position: size / 2);
      // add(animated);

      _isAlreadyLoaded = true;
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    super.onTapDown(info);

    Bullet bullet = Bullet(
      sprite: bulet,
      size: Vector2(54, 54),
      position: this._player.position.clone(),
    );
    bullet.anchor = Anchor.center;
    add(bullet);
  }

  @override
  void update(double dt) {
    super.update(dt);

    for (var command in _commandList) {
      for (var component in children) {
        command.run(component);
      }
    }

    // Remove all the commands that are processed and
    // add all new commands to be processed in next update.
    _commandList.clear();
    _commandList.addAll(_addLaterCommandList);
    _addLaterCommandList.clear();

    _playerScore.text = 'Score: ${_player.score}';
    _PlayerHealth.text = 'Health: ${_player.health} ';

    if (_player.health <= 0 && (!camera.shaking)) {
      this.pauseEngine();
      this.overlays.remove(PauseButton.ID);
      this.overlays.add(GameOverMenu.ID);
    }
  }

  @override
  void render(Canvas canvas) {
    // Draws a rectangular health bar at top right corner.
    canvas.drawRect(
      Rect.fromLTWH(size.x - 10, 10, _player.health.truncateToDouble(), 40),
      Paint()..color = Color.fromARGB(255, 0, 0, 0),
    );
    super.render(canvas);
  }

  @override
  void lifecycleStateChange(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        if (_player.health > 0) {
          pauseEngine();
          overlays.remove(PauseButton.ID);
          overlays.add(PauseMenu.ID);
        }
        break;
    }

    super.lifecycleStateChange(state);
  }

  void addCommand(Command command) {
    _addLaterCommandList.add(command);
  }

  void reset() {
    // First reset player, enemy manager and power-up manager .
    _player.reset();
    _enemyManager.reset();

    // Now remove all the enemies, bullets and power ups
    // from the game world. Note that, we are not calling
    // Enemy.destroy() because it will unnecessarily
    // run explosion effect and increase players score.
    children.whereType<Enemy>().forEach((enemy) {
      enemy.removeFromParent();
    });

    children.whereType<Bullet>().forEach((bullet) {
      bullet.removeFromParent();
    });
  }
}
