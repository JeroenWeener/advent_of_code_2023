import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput, (7, 27)) == 2);

  int answer = solve(puzzleInput, (200000000000000, 400000000000000));
  print(answer);
}

int solve(List<String> input, (int, int) bounds) {
  final (min, max) = bounds;
  List<(int, int, int, int, double, double)> hailstones = input.map((e) {
    final [x, y, _, vx, vy, _] = e.extractInts();
    double a = vy / vx;
    double b = y - a * x;
    return (x, y, vx, vy, a, b);
  }).toList();

  int count = 0;
  for (int i = 0; i < hailstones.length; i++) {
    final (x1, y1, vx1, vy1, a1, b1) = hailstones[i];
    for (int j = 0; j < i; j++) {
      if (i == j) continue;
      final (x2, y2, vx2, vy2, a2, b2) = hailstones[j];
      double intersectionX = (b2 - b1) / (a1 - a2);
      double intersectionY = (b1 * a2 - b2 * a1) / (a2 - a1);
      if (inFuture(x1, y1, vx1, vy1, intersectionX, intersectionY) &&
          inFuture(x2, y2, vx2, vy2, intersectionX, intersectionY) &&
          intersectionX >= min &&
          intersectionY >= min &&
          intersectionX <= max &&
          intersectionY <= max) {
        count++;
      }
    }
  }

  return count;
}

bool inFuture(int x, int y, int vx, int vy, double xx, double yy) {
  final a = (vx < 0 ? xx < x : xx > x) && (vy < 0 ? yy < y : yy > y);
  return a;
}
