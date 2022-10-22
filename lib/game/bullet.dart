import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/src/spritesheet.dart';

import 'enemy.dart';

class Bullet extends SpriteComponent with CollisionCallbacks {
  double _speed = 459;

  Bullet({
    Sprite? sprite,
    Vector2? position,
    Vector2? size,
  }) : super(sprite: sprite, position: position, size: size);

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
      other.removeFromParent();
      removeFromParent();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    position.x += _speed * dt;

    if (this.position.x < 0) {
      removeFromParent();
    }
  }
}
