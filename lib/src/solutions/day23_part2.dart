import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// Keep track of missed distance, which is the sum of the weights of untaken
/// edges. The maximum distance is the sum of the weights of all edges. The
/// maximum distance that is possible for an iteration is that total distance
/// minus the missed distance. If the maximum possible distance is lower than
/// the current longest distance, prune.

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  // assert(solve(testInput) == 154);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  // Find vertices.
  List<(int, int)> nodes = [
    (0, 1),
    (input.length - 1, input.first.length - 2),
  ];
  for (var r = 1; r < input.length - 1; r++) {
    for (var c = 1; c < input.first.length - 1; c++) {
      if (input[r][c] != '#') {
        bool isVertex = [
              (r - 1, c),
              (r, c + 1),
              (r + 1, c),
              (r, c - 1),
            ].where((element) => input[element.$1][element.$2] != '#').length >
            2;
        if (isVertex) {
          nodes.add((r, c));
        }
      }
    }
  }
  // print(nodes);

  // Create graph
  Map<((int, int), (int, int)), int> graph = {};
  for (final node in nodes) {
    List<((int, int), int)> rs =
        dps(input, {}, node, nodes.where((element) => element != node), 0);
    for (var r in rs) {
      graph[(node, r.$1)] = r.$2;
    }
  }
  graph = Map.fromEntries(
      graph.entries.where((element) => element.key.$1 < element.key.$2));

  maxDistanceInTheory = graph.values.sum();

  // print(maxDistanceInTheory);
  // print(graph);
  print('finished generating graph');
  print(nodes.length);

  return walk((0, 1), graph, {}, 0, 0);
}

late int maxDistanceInTheory;
int maxDistance = -1;

int walk(
  (int, int) node,
  Map<((int, int), (int, int)), int> edges,
  Set<(int, int)> visited,
  int distance,
  int missedDistance,
) {
  // print('$node $visited $distance $missedDistance');
  if (maxDistanceInTheory - missedDistance < maxDistance) {
    return 0;
  }
  if (node == (22, 21)) {
    if (maxDistance < distance) {
      maxDistance = distance;
    }
    return maxDistance;
  }
  Iterable<MapEntry<((int, int), (int, int)), int>> filteredEdges = edges
      .entries
      .where((element) => element.key.$1 == node || element.key.$2 == node)
      .where((element) =>
          !visited.contains(element.key.$1) &&
          !visited.contains(element.key.$2));
  int totalMissingExtraDistance = filteredEdges.map((e) => e.value).sum();
  // print('${filteredEdges.length} $totalMissingExtraDistance');

  final a = filteredEdges.map((e) {
    (int, int) n = e.key.$1 == node ? e.key.$2 : e.key.$1;
    int d = e.value;
    return walk(n, edges, {node, ...visited}, distance + d,
        missedDistance + totalMissingExtraDistance - d);
  });

  if (a.isEmpty) return 0;
  if (a.length == 1) return a.first;
  return a.max();
}

List<((int, int), int)> dps(
  List<String> grid,
  Set<(int, int)> visited,
  (int, int) point,
  Iterable<(int, int)> vertices,
  int distance,
) {
  if (vertices.contains(point)) return [(point, distance)];

  List<(int, int)> ns = neigbours(grid, visited, point)
      .where((element) => !visited.contains(element))
      .toList();

  final a =
      ns.map((n) => dps(grid, {...visited, point}, n, vertices, distance + 1));
  if (a.isEmpty) return [];
  if (a.length == 1) return a.first;
  return a.reduce((value, element) => value + element).toList();
}

List<(int, int)> neigbours(
  List<String> grid,
  Set<(int, int)> visited,
  (int, int) point,
) {
  (int, int) dimensions = (grid.length, grid.first.length);
  return [
    point + (-1, 0),
    point + (0, 1),
    point + (1, 0),
    point + (0, -1),
  ]
      .where((element) => isWithinBounds(dimensions, element))
      .where((element) => grid[element.$1][element.$2] != '#')
      .toList();
}

bool isWithinBounds((int, int) dimensions, (int, int) point) {
  return point.$1 >= 0 &&
      point.$2 >= 0 &&
      point.$1 < dimensions.$1 &&
      point.$2 < dimensions.$2;
}
