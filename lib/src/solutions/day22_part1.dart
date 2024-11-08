import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 5);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  List<
          (
            (int, int, int),
            (int, int, int),
          )> //
      bricks = input.map(
    (line) {
      final [x1, y1, z1, x2, y2, z2] = line.extractInts();
      return (
        (x1, y1, z1),
        (x2, y2, z2),
      );
    },
  ).toList()
        ..sort((a, b) => a.$1.$3 - b.$1.$3);

  final settledBricks = settleBricks(bricks);

  return settledBricks.where((brick) {
    final remainingBricks = settledBricks.where((b) => b != brick);
    final fallenBricks = settleBricks(remainingBricks);
    return remainingBricks.zip(fallenBricks).every(
          (brickPair) => brickPair.$1 == brickPair.$2,
        );
  }).length;
}

List<
    (
      (int, int, int),
      (int, int, int),
    )> settleBricks(
  Iterable<
          (
            (int, int, int),
            (int, int, int),
          )>
      bricks,
) {
  List<
      (
        (int, int, int),
        (int, int, int),
      )> fallenBricks = [];
  for (final brick in bricks) {
    (
      (int, int, int),
      (int, int, int),
    ) fallenBrick = brick;
    do {
      fallenBrick = descend(fallenBrick);
    } while (fallenBricks.every((brick) => !collision3d(fallenBrick, brick)) &&
        fallenBrick.$1.$3 >= 0);
    fallenBricks.add(
      (
        fallenBrick.$1 + (0, 0, 1),
        fallenBrick.$2 + (0, 0, 1),
      ),
    );
  }
  return fallenBricks;
}

void printXZ(
  List<
          (
            (int, int, int),
            (int, int, int),
          )>
      bricks,
) {
  int minX = bricks.map((b) => b.$1.$1).min();
  int maxX = bricks.map((b) => b.$2.$1).max();
  int minZ = bricks.map((b) => b.$1.$3).min();
  int maxZ = bricks.map((b) => b.$2.$3).max();

  for (int z = maxZ; z >= minZ; z--) {
    String line = '';
    for (int x = minX; x <= maxX; x++) {
      int index = bricks.indexWhere((brick) => inXZ(brick, (x, z)));
      line += index == -1 ? '.' : 'ABCDEFG'[(index % 10)];
    }
    print(line);
  }
}

void printYZ(
  List<
          (
            (int, int, int),
            (int, int, int),
          )>
      bricks,
) {
  int minY = bricks.map((b) => b.$1.$2).min();
  int maxY = bricks.map((b) => b.$2.$2).max();
  int minZ = bricks.map((b) => b.$1.$3).min();
  int maxZ = bricks.map((b) => b.$2.$3).max();

  for (int z = maxZ; z >= minZ; z--) {
    String line = '';
    for (int y = minY; y <= maxY; y++) {
      int index = bricks.indexWhere((brick) => inYZ(brick, (y, z)));
      line += index == -1 ? '.' : 'ABCDEFG'[(index % 10)];
    }
    print(line);
  }
}

bool inXZ(
  (
    (int, int, int),
    (int, int, int),
  ) brick,
  (int, int) point,
) {
  return collision2d(
    flattenInAxis(brick, 1),
    (point, point),
  );
}

bool inYZ(
  (
    (int, int, int),
    (int, int, int),
  ) brick,
  (int, int) point,
) {
  return collision2d(
    flattenInAxis(brick, 0),
    (point, point),
  );
}

(
  (int, int),
  (int, int),
) flattenInAxis(
  (
    (int, int, int),
    (int, int, int),
  ) brick,
  int axis,
) {
  return switch (axis) {
    0 => (
        (brick.$1.$2, brick.$1.$3),
        (brick.$2.$2, brick.$2.$3),
      ),
    1 => (
        (brick.$1.$1, brick.$1.$3),
        (brick.$2.$1, brick.$2.$3),
      ),
    _ => (
        (brick.$1.$1, brick.$1.$2),
        (brick.$2.$1, brick.$2.$2),
      ),
  };
}

bool collision2d(
  (
    (int, int),
    (int, int),
  ) planeA,
  (
    (int, int),
    (int, int),
  ) planeB,
) {
  final (
    (xMinA, yMinA),
    (xMaxA, yMaxA),
  ) = planeA;
  final (
    (xMinB, yMinB),
    (xMaxB, yMaxB),
  ) = planeB;

  bool xOverlap = xMaxA >= xMinB && xMinA <= xMaxB;
  bool yOverlap = yMaxA >= yMinB && yMinA <= yMaxB;

  return xOverlap && yOverlap;
}

bool collision3d(
  (
    (int, int, int),
    (int, int, int),
  ) brickA,
  (
    (int, int, int),
    (int, int, int),
  ) brickB,
) {
  final (
    (xMinA, yMinA, zMinA),
    (xMaxA, yMaxA, zMaxA),
  ) = brickA;
  final (
    (xMinB, yMinB, zMinB),
    (xMaxB, yMaxB, zMaxB),
  ) = brickB;

  bool xOverlap = xMaxA >= xMinB && xMinA <= xMaxB;
  bool yOverlap = yMaxA >= yMinB && yMinA <= yMaxB;
  bool zOverlap = zMaxA >= zMinB && zMinA <= zMaxB;

  return xOverlap && yOverlap && zOverlap;
}

(
  (int, int, int),
  (int, int, int),
) descend(
  (
    (int, int, int),
    (int, int, int),
  ) brick,
) {
  return (brick.$1 - (0, 0, 1), brick.$2 - (0, 0, 1));
}
