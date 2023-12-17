import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// As you try to work out what might be wrong, the reindeer tugs on your shirt
/// and leads you to a nearby control panel. There, a collection of buttons lets
/// you align the contraption so that the beam enters from any edge tile and
/// heading away from that edge. (You can choose either of two directions for
/// the beam if it starts on a corner; for instance, if the beam starts in the
/// bottom-right corner, it can start heading either left or upward.)
///
/// So, the beam could start on any tile in the top row (heading downward), any
/// tile in the bottom row (heading upward), any tile in the leftmost column
/// (heading right), or any tile in the rightmost column (heading left). To
/// produce lava, you need to find the configuration that energizes as many
/// tiles as possible.
///
/// In the above example, this can be achieved by starting the beam in the
/// fourth tile from the left in the top row:
///
///   .|<2<\....
///   |v-v\^....
///   .v.v.|->>>
///   .v.v.v^.|.
///   .v.v.v^...
///   .v.v.v^..\
///   .v.v/2\\..
///   <-2-/vv|..
///   .|<<<2-|.\
///   .v//.|.v..
///
/// Using this configuration, 51 tiles are energized:
///
///   .#####....
///   .#.#.#....
///   .#.#.#####
///   .#.#.##...
///   .#.#.##...
///   .#.#.##...
///   .#.#####..
///   ########..
///   .#######..
///   .#...#.#..
///
/// Find the initial beam configuration that energizes the largest number of
/// tiles; how many tiles are energized in that configuration?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 51);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  List<(int, (int, int))> beams = [
    ...range(input.first.length).map((c) => (2, (0, c))),
    ...range(input.first.length).map((c) => (0, (input.length - 1, c))),
    ...range(input.length).map((r) => (1, (r, 0))),
    ...range(input.length).map((r) => (3, (r, input.first.length - 1))),
  ];

  return beams.map((beam) => subsolve(input, [beam])).max();
}

int subsolve(
  List<String> input,
  List<(int, (int, int))> beams,
) {
  (int, int) dimensions = (input.length, input.first.length);

  for (int i = 0; i < beams.length; i++) {
    Iterable<(int, (int, int))> newBeams =
        step(input, beams[i], dimensions).where((s) => !beams.contains(s));
    beams.addAll(newBeams);
  }
  return beams.map((s) => s.$2).toSet().length;
}

Iterable<(int, (int, int))> step(
  List<String> grid,
  (int, (int, int)) situation,
  (int, int) dimensions,
) {
  int currentDirection = situation.$1;
  (int, int) currentPosition = situation.$2;

  String tile = grid[currentPosition.$1][currentPosition.$2];
  if (tile == '.') {
    (int, int) newPosition = currentPosition + positionDelta(currentDirection);
    return isWithinBounds(newPosition, dimensions)
        ? [(currentDirection, newPosition)]
        : [];
  } else if (tile == '/') {
    int newDirection = forwardSlash(currentDirection);
    (int, int) newPosition = currentPosition + positionDelta(newDirection);
    return isWithinBounds(newPosition, dimensions)
        ? [(newDirection, newPosition)]
        : [];
  } else if (tile == '\\') {
    int newDirection = backwardSlash(currentDirection);
    (int, int) newPosition = currentPosition + positionDelta(newDirection);
    return isWithinBounds(newPosition, dimensions)
        ? [(newDirection, newPosition)]
        : [];
  } else if (tile == '-') {
    List<int> newDirections = dash(currentDirection);
    Iterable<(int, int)> newPositions =
        newDirections.map((int d) => currentPosition + positionDelta(d));
    return newDirections
        .zip(newPositions)
        .where((s) => isWithinBounds(s.$2, dimensions));
  } else {
    List<int> newDirections = pipe(currentDirection);
    Iterable<(int, int)> newPosition =
        newDirections.map((int d) => currentPosition + positionDelta(d));
    return newDirections
        .zip(newPosition)
        .where((s) => isWithinBounds(s.$2, dimensions));
  }
}

List<int> dash(int direction) {
  return direction % 2 == 1 ? [direction] : [1, 3];
}

List<int> pipe(int direction) {
  return direction % 2 == 0 ? [direction] : [0, 2];
}

int forwardSlash(int direction) {
  return switch (direction) {
    2 => 3,
    1 => 0,
    0 => 1,
    _ => 2,
  };
}

int backwardSlash(int direction) {
  return switch (direction) {
    2 => 1,
    1 => 2,
    0 => 3,
    _ => 0,
  };
}

(int, int) positionDelta(int direction) {
  return switch (direction) {
    0 => (-1, 0),
    1 => (0, 1),
    2 => (1, 0),
    _ => (0, -1),
  };
}

bool isWithinBounds((int, int) pos, (int, int) dimensions) {
  return pos.$1 >= 0 &&
      pos.$2 >= 0 &&
      pos.$1 < dimensions.$1 &&
      pos.$2 < dimensions.$2;
}
