import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameWidget(game: MyGame()),
    );
  }
}

class MyGame extends FlameGame with KeyboardEvents {
  late final Paddle leftPaddle;
  late final Paddle rightPaddle;
  late final Ball ball;
  final Random rnd = Random();
  late final double ballMinX;
  late final double ballMaxX;
  late final double ballMinY;
  late final double ballMaxY;

  @override
  Future<void> onLoad() async {
    leftPaddle = Paddle(
      size: Vector2(size.x * .005, size.y * 0.1),
      position: Vector2(size.x * .025, size.y / 2),
    );
    add(leftPaddle);
    rightPaddle = Paddle(
      size: Vector2(size.x * .005, size.y * 0.1),
      position: Vector2(size.x * .975, size.y / 2),
    );
    add(rightPaddle);

    ball = Ball(
      radius: size.x * .005,
      position: size / 2,
    );
    ball.movement = randomVec2();
    add(ball);
  }

  Vector2 randomVec2() => Vector2(
        rnd.nextDouble(),
        rnd.nextDouble(),
      );

  @override
  void update(double dt) {
    super.update(dt);
    if (leftPaddle.movement != PaddleMovement.idle) {
      final dy = dt *
          leftPaddle.speed *
          (leftPaddle.movement == PaddleMovement.up ? -1 : 1);
      // debugPrint('dy: $dy');
      leftPaddle.move(dy);
    }
    if (rightPaddle.movement != PaddleMovement.idle) {
      final dy = dt *
          rightPaddle.speed *
          (rightPaddle.movement == PaddleMovement.up ? -1 : 1);
      rightPaddle.move(dy);
    }
    ball.position += Vector2(
      ball.movement.x * dt * ball.speed,
      ball.movement.y * dt * ball.speed,
    );
    ball.position = Vector2(
        ball.position.x.clamp(0 + ball.radius, size.x - ball.radius),
        ball.position.y.clamp(0 + ball.radius, size.y - ball.radius));
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    bool isKeyDown = event is KeyDownEvent;

    if (event.logicalKey == LogicalKeyboardKey.keyW) {
      leftPaddle.movement = isKeyDown ? PaddleMovement.up : PaddleMovement.idle;
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      leftPaddle.movement =
          isKeyDown ? PaddleMovement.down : PaddleMovement.idle;
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      rightPaddle.movement =
          isKeyDown ? PaddleMovement.up : PaddleMovement.idle;
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      rightPaddle.movement =
          isKeyDown ? PaddleMovement.down : PaddleMovement.idle;
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

class Paddle extends RectangleComponent {
  double speed;

  Paddle({
    required super.size,
    super.position,
  })  : speed = size!.y * 6,
        super(anchor: Anchor.center);

  PaddleMovement movement = PaddleMovement.idle;

  void move(double dy) {
    position = Vector2(position.x, position.y + dy);
  }
}

class Ball extends CircleComponent {
  Ball({
    required super.radius,
    super.position,
  })  : speed = radius! * 50,
        super(anchor: Anchor.center);

  late Vector2 movement;
  double speed;
}

enum PaddleMovement { up, down, idle }
