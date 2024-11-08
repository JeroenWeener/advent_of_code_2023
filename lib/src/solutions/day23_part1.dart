import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 94);

  int answer = solve(puzzleInput);
  print(answer);
}

late List<List<int>> costs;

int solve(List<String> input) {
  costs = List.generate(
    input.length,
    (_) => List.filled(input.first.length, 0),
  );

  dps(input, {}, (0, 1), 0);

  return costs.last.secondLast;
}

void dps(
  List<String> grid,
  Set<(int, int)> visited,
  (int, int) point,
  int currentCost,
) {
  if (visited.contains(point)) return;

  if (costs[point.$1][point.$2] < currentCost) {
    costs[point.$1][point.$2] = currentCost;
  }

  List<(int, int)> neigbors = neigbours(grid, visited, point);
  for (var n in neigbors) {
    dps(grid, {...visited, point}, n, currentCost + 1);
  }
}

List<(int, int)> neigbours(
    List<String> grid, Set<(int, int)> visited, (int, int) point) {
  List<(int, int)> deltas = [
    (-1, 0),
    (0, 1),
    (1, 0),
    (0, -1),
  ];
  (int, int) dimensions = (grid.length, grid.first.length);

  List<(int, int)> ns = [];

  final up = point + deltas[0];
  if (isWithinBounds(dimensions, up)) {
    String c = grid[up.$1][up.$2];
    if (c == '.' || c == '^') {
      ns.add(up);
    }
  }

  final right = point + deltas[1];
  if (isWithinBounds(dimensions, right)) {
    String c = grid[right.$1][right.$2];
    if (c == '.' || c == '>') {
      ns.add(right);
    }
  }

  final down = point + deltas[2];
  if (isWithinBounds(dimensions, down)) {
    String c = grid[down.$1][down.$2];
    if (c == '.' || c == 'v') {
      ns.add(down);
    }
  }

  final left = point + deltas[3];
  if (isWithinBounds(dimensions, left)) {
    String c = grid[left.$1][left.$2];
    if (c == '.' || c == '<') {
      ns.add(left);
    }
  }

  return ns;
}

bool isWithinBounds((int, int) dimensions, (int, int) point) {
  return point.$1 >= 0 &&
      point.$2 >= 0 &&
      point.$1 < dimensions.$1 &&
      point.$2 < dimensions.$2;
}
