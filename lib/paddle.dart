import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:observable_flame_pong/ball.dart';
import 'package:observable_flame_pong/main.dart';

class Paddle extends RectangleComponent
    with CollisionCallbacks, HasGameReference<MyGame> {
  double speed;
  double maxY;

  Paddle({
    required super.size,
    required this.maxY,
    super.position,
  })  : speed = size!.y * 8,
        super(anchor: Anchor.center);

  @override
  void onLoad() {
    add(RectangleHitbox());
    super.onLoad();
  }

  PaddleDirection direction = PaddleDirection.idle;

  void move(double dy) {
    position = Vector2(
        position.x, (position.y + dy).clamp(0 + size.y / 2, maxY - size.y / 2));
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    if (other is Ball) {
      final intersection = intersectionPoints.first;
      final centerY = position.y;
      final collisionDistanceFromCenter = (intersection.y - centerY) / size.y;
      double normalizeY;

      normalizeY = collisionDistanceFromCenter *
          Ball.maxYDeflection *
          (other.direction.y > 0 ? -1 : 1);
      other.direction
        ..setValues(-other.direction.x, 0)
        ..rotate(normalizeY);
      other.increaseSpeed();
    }
    super.onCollisionStart(intersectionPoints, other);
  }
}

enum PaddleDirection { up, down, idle }
