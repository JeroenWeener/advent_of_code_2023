import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  // int steps = 26501365;
  // int gridsToTheLeftOfStartingGrid = (steps - input.length ~/ 2) % input.length;

  List<int> steps = [
    input.length ~/ 2 + 1 * input.length,
    input.length ~/ 2 + 3 * input.length,
    input.length ~/ 2 + 5 * input.length,
  ];
  List<int> results = steps.map((e) => test(input, e)).toList();
  return lagrangeInterpolation(steps, results, 26501365).toInt();
}

int test(List<String> input, int steps) {
  Set<(int, int)> visited = {};
  Set<(int, int)> destinations = {};
  Set<(int, int)> rocks = {};

  for (var r = 0; r < input.length; r++) {
    for (var c = 0; c < input.length; c++) {
      String s = input[r][c];
      if (s == '#') {
        rocks.add((r, c));
      }
    }
  }

  Set<(int, int)> nextPositions = {(input.length ~/ 2, input.length ~/ 2)};
  for (var i = 0; i < steps + 1; i++) {
    Set<(int, int)> nss = {};
    for (var pos in nextPositions) {
      nss.addAll(
        neighbours(
          visited,
          rocks,
          pos,
          input.length,
        ),
      );

      visited.add(pos);
      if (i % 2 == 0) {
        destinations.add(pos);
      }
    }
    nextPositions = nss;
    // print(nextPositions);
  }

  return destinations.length;
}

List<(int, int)> neighbours(
  Set<(int, int)> visited,
  Set<(int, int)> rocks,
  (int, int) position,
  int dimension,
) {
  final a = [
    position + (-1, 0),
    position + (0, 1),
    position + (1, 0),
    position + (0, -1),
  ]
      .where((element) => !rocks.contains(element % dimension))
      .where((element) => !visited.contains(position))
      .toList();
  return a;
}

double lagrangeInterpolation(List<int> xValues, List<int> yValues, int x) {
  double result = 0.0;

  for (int i = 0; i < xValues.length; i++) {
    double term = yValues[i].toDouble();

    for (int j = 0; j < xValues.length; j++) {
      if (j != i) {
        term *= (x - xValues[j]) / (xValues[i] - xValues[j]);
      }
    }

    result += term;
  }

  return result;
}
