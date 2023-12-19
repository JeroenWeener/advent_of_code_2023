import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Day 18: Lavaduct Lagoon ---
///
/// Thanks to your efforts, the machine parts factory is one of the first
/// factories up and running since the lavafall came back. However, to catch up
/// with the large backlog of parts requests, the factory will also need a large
/// supply of lava for a while; the Elves have already started creating a large
/// lagoon nearby for this purpose.
///
/// However, they aren't sure the lagoon will be big enough; they've asked you
/// to take a look at the dig plan (your puzzle input). For example:
///
///   R 6 (#70c710)
///   D 5 (#0dc571)
///   L 2 (#5713f0)
///   D 2 (#d2c081)
///   R 2 (#59c680)
///   D 2 (#411b91)
///   L 5 (#8ceee2)
///   U 2 (#caa173)
///   L 1 (#1b58a2)
///   U 2 (#caa171)
///   R 2 (#7807d2)
///   U 3 (#a77fa3)
///   L 2 (#015232)
///   U 2 (#7a21e3)
///
/// The digger starts in a 1 meter cube hole in the ground. They then dig the
/// specified number of meters up (U), down (D), left (L), or right (R),
/// clearing full 1 meter cubes as they go. The directions are given as seen
/// from above, so if "up" were north, then "right" would be east, and so on.
/// Each trench is also listed with the color that the edge of the trench should
/// be painted as an RGB hexadecimal color code.
///
/// When viewed from above, the above example dig plan would result in the
/// following loop of trench (#) having been dug out from otherwise ground-level
/// terrain (.):
///
///   #######
///   #.....#
///   ###...#
///   ..#...#
///   ..#...#
///   ###.###
///   #...#..
///   ##..###
///   .#....#
///   .######
///
/// At this point, the trench could contain 38 cubic meters of lava. However,
/// this is just the edge of the lagoon; the next step is to dig out the
/// interior so that it is one meter deep as well:
///
///   #######
///   #######
///   #######
///   ..#####
///   ..#####
///   #######
///   #####..
///   #######
///   .######
///   .######
///
/// Now, the lagoon can contain a much more respectable 62 cubic meters of lava.
/// While the interior is dug out, the edges are also painted according to the
/// color codes in the dig plan.
///
/// The Elves are concerned the lagoon won't be large enough; if they follow
/// their dig plan, how many cubic meters of lava could it hold?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 62);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  (int, int) pos = (0, 0);
  Set<(int, int)> holes = {pos};

  for (String line in input) {
    final [direction, distanceString, _] = line.split(' ');
    int distance = int.parse(distanceString);

    for (int i = 0; i < distance; i++) {
      pos += deltaPos(direction);
      holes.add(pos);
    }
  }
  List<String> grid = setToGrid(holes);

  grid = grid.map((e) => '.$e.').toList();
  grid = [
    '.' * grid.first.length,
    ...grid,
    '.' * grid.first.length,
  ];

  List<List<bool>> reachable = List.generate(
    grid.length,
    (e) => e == 0 || e == grid.length - 1
        ? List.filled(grid.first.length, true)
        : List.generate(
            grid.first.length,
            (e) => e == 0 || e == grid.first.length - 1,
          ),
  );

  bool hasChanges;
  do {
    hasChanges = false;
    for (int r = 1; r < reachable.length - 1; r++) {
      for (int c = 1; c < reachable.first.length - 1; c++) {
        if (grid[r][c] == '.') {
          List<bool> ns = [
            reachable[r - 1][c],
            reachable[r][c + 1],
            reachable[r + 1][c],
            reachable[r][c - 1],
          ];
          if (ns.any((n) => n) && !reachable[r][c]) {
            reachable[r][c] = true;
            hasChanges = true;
          }
        }
      }
    }
  } while (hasChanges);

  return grid.length * grid.first.length -
      reachable.map((e) => e.where((e) => e).length).sum();
}

(int, int) deltaPos(String direction) {
  return switch (direction) {
    'U' => (-1, 0),
    'R' => (0, 1),
    'D' => (1, 0),
    _ => (0, -1),
  };
}

List<String> setToGrid(Set<(int, int)> holes) {
  int minR = holes.map((e) => e.$1).min();
  int maxR = holes.map((e) => e.$1).max();
  int minC = holes.map((e) => e.$2).min();
  int maxC = holes.map((e) => e.$2).max();

  List<String> result = [];
  for (int r = minR; r <= maxR; r++) {
    String s = '';
    for (int c = minC; c <= maxC; c++) {
      s += holes.contains((r, c)) ? '#' : '.';
    }
    result.add(s);
  }
  return result;
}
