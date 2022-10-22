import 'package:flame/components.dart';

class AnimatedPlayer extends SpriteAnimationComponent with HasGameRef {
  AnimatedPlayer({
    required super.position,
  }) : super(size: Vector2(60, 120), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    animation = SpriteAnimation.fromFrameData(
      gameRef.images.fromCache('spritemb.png'),
      SpriteAnimationData.sequenced(
        amount: 5,
        textureSize: Vector2(310, 180),
        stepTime: 0.12,
      ),
    );
  }
}
