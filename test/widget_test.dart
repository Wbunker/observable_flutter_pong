import 'package:flame/components.dart';
import 'package:flame_test/flame_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:observable_flame_pong/main.dart';

void main() {
  testWithGame<MyGame>('Hit paddle in middle', () => MyGame(Vector2(-1, 0)),
      (game) async {
    await game.loaded;
    final distanceToPaddle = game.ball.positionOfAnchor(Anchor.centerLeft).x -
        game.leftPaddle.positionOfAnchor(Anchor.centerRight).x;
    final timeToCoverDistance = (distanceToPaddle / game.ball.speed) * 1.1;
    game.update(timeToCoverDistance);

    expect(game.ball.direction.x, isPositive);
    expect(game.ball.direction.y, closeTo(0, .0001));
  });

  testWithGame<MyGame>('Hit paddle bottom left', () => MyGame(Vector2(-1, 0)),
      (game) async {
    await game.loaded;

    final bottomRightOfPaddle =
        game.leftPaddle.positionOfAnchor(Anchor.bottomRight);
    final centerLeftOfBall = game.ball.positionOfAnchor(Anchor.centerLeft);

    final Vector2 ballToCorderOfPaddle = bottomRightOfPaddle - centerLeftOfBall;

    final timeToCoverDistance =
        (ballToCorderOfPaddle.length / game.ball.speed) * 1.1;

    game.ball.direction = ballToCorderOfPaddle.normalized();

    game.update(timeToCoverDistance);

    expect(game.ball.direction.x, isPositive);
    // expect(game.ball.direction.y, closeTo(0, .0001));
  });
}
