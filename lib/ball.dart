import 'dart:math';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

class Ball extends CircleComponent with CollisionCallbacks {
  double maxSpeed;
  Ball({
    required super.radius,
    super.position,
  })  : speed = radius! * 120,
        maxSpeed = radius * 120 * 3,
        super(anchor: Anchor.center);

  // steepness of the deflection angle
  static const maxYDeflection = (pi / 2) - 0.52;

  void increaseSpeed() {
    speed = (speed * 1.1).clamp(1, maxSpeed);
  }

  @override
  Future<void> onLoad() async {
    add(CircleHitbox());
    super.onLoad();
  }

  late Vector2 direction;
  double speed;

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    // debugPrint('Ball collided with $other');
    super.onCollisionStart(intersectionPoints, other);
  }
}
