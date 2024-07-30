import 'dart:math';

import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:observable_flame_pong/ball.dart';
import 'package:observable_flame_pong/paddle.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GameWidget(game: MyGame(randomVec2(Random()))),
    );
  }
}

class MyGame extends FlameGame with KeyboardEvents, HasCollisionDetection {
  late final Paddle leftPaddle;
  late final Paddle rightPaddle;
  late final Ball ball;
  late final double ballMinX;
  late final double ballMaxX;
  late final double ballMinY;
  late final double ballMaxY;
  Vector2 startingBallDirection;

  MyGame(this.startingBallDirection);

  @override
  Future<void> onLoad() async {
    leftPaddle = Paddle(
      size: Vector2(size.x * .005, size.y * 0.1),
      maxY: size.y,
      position: Vector2(size.x * .025, size.y / 2),
    );
    add(leftPaddle);
    rightPaddle = Paddle(
      size: Vector2(size.x * .005, size.y * 0.1),
      maxY: size.y,
      position: Vector2(size.x * .975, size.y / 2),
    );
    add(rightPaddle);

    ball = Ball(
      radius: size.x * .005,
      position: size / 2,
    );
    ball.direction = startingBallDirection;
    add(ball);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (leftPaddle.direction != PaddleDirection.idle) {
      final dy = dt *
          leftPaddle.speed *
          (leftPaddle.direction == PaddleDirection.up ? -1 : 1);
      // debugPrint('dy: $dy');
      leftPaddle.move(dy);
    }
    if (rightPaddle.direction != PaddleDirection.idle) {
      final dy = dt *
          rightPaddle.speed *
          (rightPaddle.direction == PaddleDirection.up ? -1 : 1);
      rightPaddle.move(dy);
    }

    ball.position += Vector2(
      ball.direction.x * dt * ball.speed,
      ball.direction.y * dt * ball.speed,
    );

    final minX = 0 + ball.radius;
    final maxX = size.x - ball.radius;
    final minY = 0 + ball.radius;
    final maxY = size.y - ball.radius;

    ball.position = Vector2(
        ball.position.x.clamp(minX, maxX), ball.position.y.clamp(minY, maxY));

    if (ball.position.x == minX || ball.position.x == maxX) {
      ball.direction = Vector2(-ball.direction.x, ball.direction.y);
    }

    if (ball.position.y == minY || ball.position.y == maxY) {
      ball.direction = Vector2(ball.direction.x, -ball.direction.y);
    }
  }

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    bool isKeyUp = event is KeyUpEvent;

    debugPrint('isKeyDown: $isKeyUp');
    debugPrint('event.logicalKey: ${event.logicalKey}');
    if (event.logicalKey == LogicalKeyboardKey.keyW) {
      leftPaddle.direction =
          isKeyUp ? PaddleDirection.idle : PaddleDirection.up;
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.keyS) {
      leftPaddle.direction =
          isKeyUp ? PaddleDirection.idle : PaddleDirection.down;
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      rightPaddle.direction =
          isKeyUp ? PaddleDirection.idle : PaddleDirection.up;
      return KeyEventResult.handled;
    } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      rightPaddle.direction =
          isKeyUp ? PaddleDirection.idle : PaddleDirection.down;
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }
}

Vector2 randomVec2(rnd) => Vector2(
      rnd.nextDouble().clamp(0.2, 0.8),
      rnd.nextDouble(),
    );
