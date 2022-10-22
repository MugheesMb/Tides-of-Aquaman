import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:game2/game/Home.dart';
import 'package:game2/game/bullet.dart';
import 'package:game2/game/enemy.dart';
import 'package:game2/game/knowGameSize.dart';

class Player extends SpriteComponent
    with
        KnowsGameSize,
        CollisionCallbacks,
        HasGameRef<SpaceWater>,
        KeyboardHandler {
  Vector2 _moveDirection = Vector2.zero();

  JoystickComponent joystick;

  double _speed = 400;
  int _score = 0;
  int get score => _score;
  int _health = 1000;
  int get health => _health;

  final _random = Random();

  // This method generates a random vector such that
  // its x component lies between [-100 to 100] and
  // y component lies between [200, 400]
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(1, 0.5)) * 230;
  }

  Player({
    required this.joystick,
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    angle = 220;
  }

  @override
  void onMount() {
    super.onMount();

    // Adding a circular hitbox with radius as 0.4 times
    //  the smallest dimension of this components size.
    final shape = CircleHitbox();
    add(shape);
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);

    // If the other Collidable is Enemy, remove this bullet.
    if (other is Enemy) {
      gameRef.camera.shake();

      _health -= 1;
      if (_health <= 0) {
        _health = 0;
      }
    }
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (event is RawKeyDownEvent &&
        !event.repeat &&
        event.logicalKey == LogicalKeyboardKey.space) {
      // pew pew!
      joystickAction();
    }

    return false;
  }

  @override
  void update(double dt) {
    super.update(dt);
    this.position += _moveDirection.normalized() * _speed * dt;

    if (!joystick.delta.isZero()) {
      position.add(joystick.relativeDelta * 200 * dt);
    }

    position.clamp(
      Vector2.zero() + size / 2,
      gameRef.size - size / 2,
    );

    // Adds thruster particles.
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 10,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: (position.clone() + Vector2(2, size.y / 27)),
          child: CircleParticle(
            radius: 1,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );

    gameRef.add(particleComponent);
  }

  void joystickAction() {
    Bullet bullet = Bullet(
      sprite: gameRef.bulet,
      size: Vector2(64, 64),
      position: this.position.clone(),
    );

    // Anchor it to center and add to game world.
    bullet.anchor = Anchor.center;
    gameRef.add(bullet);

    // If multiple bullet is on, add two more
    // bullets rotated +-PI/6 radians to first bullet.
    // if (_shootMultipleBullets) {
    //   for (int i = -1; i < 2; i += 2) {
    //     Bullet bullet = Bullet(
    //       sprite: gameRef.spriteSheet.getSpriteById(28),
    //       size: Vector2(64, 64),
    //       position: position.clone(),
    //       level: _spaceship.level,
    //     );

    //     // Anchor it to center and add to game world.
    //     bullet.anchor = Anchor.center;
    //     bullet.direction.rotate(i * pi / 6);
    //     gameRef.add(bullet);
    //}
    //}
  }

  void addToScore(int points) {
    _score += points;
  }

  void reset() {
    this._score = 0;
    this._health = 1000;
    this.position = gameRef.size / 2;
  }
}
