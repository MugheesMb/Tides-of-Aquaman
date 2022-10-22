import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game2/game/Home.dart';
import 'package:game2/game/command.dart';
import 'package:game2/game/knowGameSize.dart';
import 'package:game2/game/player.dart';
import 'package:game2/models/enemy_details.dart';

import 'bullet.dart';

class Enemy extends SpriteComponent
    with KnowsGameSize, CollisionCallbacks, HasGameRef<SpaceWater> {
  double _speed = 250;
  final EnemyData enemyData;

  Enemy({
    required Sprite? sprite,
    required this.enemyData,
    required Vector2? position,
    required Vector2? size,
  }) : super(sprite: sprite, position: position, size: size) {
    angle = 300;
    _speed = enemyData.speed;
  }
  final _random = Random();

  // This method generates a random vector such that
  // its x component lies between [-100 to 100] and
  // y component lies between [200, 400]
  Vector2 getRandomVector() {
    return (Vector2.random(_random) - Vector2(0.5, -1)) * 200;
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

    if (other is Bullet) {
      other.removeFromParent();
      removeFromParent();
      final command = Command<Player>(action: (player) {
        // Use the correct killPoint to increase player's score.
        player.addToScore(1);
      });
      gameRef.addCommand(command);
    }
    final particleComponent = ParticleSystemComponent(
      particle: Particle.generate(
        count: 10,
        lifespan: 0.1,
        generator: (i) => AcceleratedParticle(
          acceleration: getRandomVector(),
          speed: getRandomVector(),
          position: (position.clone()),
          child: CircleParticle(
            radius: 2,
            paint: Paint()..color = Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    // this.position += Vector2(-1, 1) * _speed * dt;
    position.x -= _speed * dt;
    if (this.position.x > gameRef.size.x) {
      removeFromParent();
    }
  }
}
