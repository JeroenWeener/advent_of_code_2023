import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// The parabolic reflector dish deforms, but not in a way that focuses the
/// beam. To do that, you'll need to move the rocks to the edges of the
/// platform. Fortunately, a button on the side of the control panel labeled
/// "spin cycle" attempts to do just that!
///
/// Each cycle tilts the platform four times so that the rounded rocks roll
/// north, then west, then south, then east. After each tilt, the rounded rocks
/// roll as far as they can before the platform tilts in the next direction.
/// After one cycle, the platform will have finished rolling the rounded rocks
/// in those four directions in that order.
///
/// Here's what happens in the example above after each of the first few cycles:
///
///   After 1 cycle:
///   .....#....
///   ....#...O#
///   ...OO##...
///   .OO#......
///   .....OOO#.
///   .O#...O#.#
///   ....O#....
///   ......OOOO
///   #...O###..
///   #..OO#....
///
///   After 2 cycles:
///   .....#....
///   ....#...O#
///   .....##...
///   ..O#......
///   .....OOO#.
///   .O#...O#.#
///   ....O#...O
///   .......OOO
///   #..OO###..
///   #.OOO#...O
///
///   After 3 cycles:
///   .....#....
///   ....#...O#
///   .....##...
///   ..O#......
///   .....OOO#.
///   .O#...O#.#
///   ....O#...O
///   .......OOO
///   #...O###.O
///   #.OOO#...O
///
/// This process should work if you leave it running long enough, but you're
/// still worried about the north support beams. To make sure they'll survive
/// for a while, you need to calculate the total load on the north support beams
/// after 1000000000 cycles.
///
/// In the above example, after 1000000000 cycles, the total load on the north
/// support beams is 64.
///
/// Run the spin cycle for 1000000000 cycles. Afterward, what is the total load
/// on the north support beams?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 64);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  List<String> cache = [];
  int iterations = 1000000000;

  List<String> platform = input;
  late int cycle;
  late int start;

  for (int iteration = 0; iteration < iterations; iteration++) {
    platform = moveNorth(platform);
    platform = moveWest(platform);
    platform = moveSouth(platform);
    platform = moveEast(platform);

    String platformString = platform.join('*');
    if (cache.contains(platformString)) {
      start = cache.indexOf(platformString);
      cycle = iteration - start;
      break;
    }
    cache.add(platformString);
  }

  int n = (iterations - start) % cycle;
  return load(cache[start + n - 1].split('*'));
}

int load(List<String> platform) {
  return platform
      .T()
      .map((r) => r.indexed //
          .map((c) => (c.$2 == 'O' ? r.length - c.$1 : 0))
          .sum())
      .sum();
}

List<String> moveNorth(List<String> platform) {
  return move(platform.T()).T();
}

List<String> moveWest(List<String> platform) {
  return move(platform);
}

List<String> moveSouth(List<String> platform) {
  return move(platform.reversed.T()).T().reversed.toList();
}

List<String> moveEast(List<String> platform) {
  return move(platform.map((r) => r.reversed)).map((r) => r.reversed).toList();
}

List<String> move(Iterable<String> platform) {
  return platform.map((row) {
    final newRow = row.split('#').map((subrow) {
      int boulders = subrow.where((c) => c == 'O').length;
      return 'O' * boulders + '.' * (subrow.length - boulders);
    }).join('#');
    return newRow;
  }).toList();
}
