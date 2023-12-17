import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Day 16: The Floor Will Be Lava ---
///
/// With the beam of light completely focused somewhere, the reindeer leads you
/// deeper still into the Lava Production Facility. At some point, you realize
/// that the steel facility walls have been replaced with cave, and the doorways
/// are just cave, and the floor is cave, and you're pretty sure this is
/// actually just a giant cave.
///
/// Finally, as you approach what must be the heart of the mountain, you see a
/// bright light in a cavern up ahead. There, you discover that the beam of
/// light you so carefully focused is emerging from the cavern wall closest to
/// the facility and pouring all of its energy into a contraption on the
/// opposite side.
///
/// Upon closer inspection, the contraption appears to be a flat,
/// two-dimensional square grid containing empty space (.), mirrors (/ and \),
/// and splitters (| and -).
///
/// The contraption is aligned so that most of the beam bounces around the grid,
/// but each tile on the grid converts some of the beam's light into heat to
/// melt the rock in the cavern.
///
/// You note the layout of the contraption (your puzzle input). For example:
///
///   .|...\....
///   |.-.\.....
///   .....|-...
///   ........|.
///   ..........
///   .........\
///   ..../.\\..
///   .-.-/..|..
///   .|....-|.\
///   ..//.|....
///
/// The beam enters in the top-left corner from the left and heading to the
/// right. Then, its behavior depends on what it encounters as it moves:
///
/// - If the beam encounters empty space (.), it continues in the same
///   direction.
/// - If the beam encounters a mirror (/ or \), the beam is reflected 90 degrees
///   depending on the angle of the mirror. For instance, a rightward-moving
///   beam that encounters a / mirror would continue upward in the mirror's
///   column, while a rightward-moving beam that encounters a \ mirror would
///   continue downward from the mirror's column.
/// - If the beam encounters the pointy end of a splitter (| or -), the beam
///   passes through the splitter as if the splitter were empty space. For
///   instance, a rightward-moving beam that encounters a - splitter would
///   continue in the same direction.
/// - If the beam encounters the flat side of a splitter (| or -), the beam is
///   split into two beams going in each of the two directions the splitter's
///   pointy ends are pointing. For instance, a rightward-moving beam that
///   encounters a | splitter would split into two beams: one that continues
///   upward from the splitter's column and one that continues downward from the
///   splitter's column.
///
/// Beams do not interact with other beams; a tile can have many beams passing
/// through it at the same time. A tile is energized if that tile has at least
/// one beam pass through it, reflect in it, or split in it.
///
/// In the above example, here is how the beam of light bounces around the
/// contraption:
///
///   >|<<<\....
///   |v-.\^....
///   .v...|->>>
///   .v...v^.|.
///   .v...v^...
///   .v...v^..\
///   .v../2\\..
///   <->-/vv|..
///   .|<<<2-|.\
///   .v//.|.v..
///
/// Beams are only shown on empty tiles; arrows indicate the direction of the
/// beams. If a tile contains beams moving in multiple directions, the number of
/// distinct directions is shown instead. Here is the same diagram but instead
/// only showing whether a tile is energized (#) or not (.):
///
///   ######....
///   .#...#....
///   .#...#####
///   .#...##...
///   .#...##...
///   .#...##...
///   .#..####..
///   ########..
///   .#######..
///   .#...#.#..
///
/// Ultimately, in this example, 46 tiles become energized.
///
/// The light isn't energizing enough tiles to produce lava; to debug the
/// contraption, you need to start by analyzing the current situation. With the
/// beam starting in the top-left heading right, how many tiles end up being
/// energized?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 46);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  List<(int, (int, int))> beams = [(1, (0, 0))];
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
