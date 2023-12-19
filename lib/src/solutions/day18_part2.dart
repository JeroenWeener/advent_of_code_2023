import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// The Elves were right to be concerned; the planned lagoon would be much too
/// small.
///
/// After a few minutes, someone realizes what happened; someone swapped the
/// color and instruction parameters when producing the dig plan. They don't
/// have time to fix the bug; one of them asks if you can extract the correct
/// instructions from the hexadecimal codes.
///
/// Each hexadecimal code is six hexadecimal digits long. The first five
/// hexadecimal digits encode the distance in meters as a five-digit hexadecimal
/// number. The last hexadecimal digit encodes the direction to dig: 0 means R,
/// 1 means D, 2 means L, and 3 means U.
///
/// So, in the above example, the hexadecimal codes can be converted into the
/// true instructions:
///
///   - #70c710 = R 461937
///   - #0dc571 = D 56407
///   - #5713f0 = R 356671
///   - #d2c081 = D 863240
///   - #59c680 = R 367720
///   - #411b91 = D 266681
///   - #8ceee2 = L 577262
///   - #caa173 = U 829975
///   - #1b58a2 = L 112010
///   - #caa171 = D 829975
///   - #7807d2 = L 491645
///   - #a77fa3 = U 686074
///   - #015232 = L 5411
///   - #7a21e3 = U 500254
///
/// Digging out this loop and its interior produces a lagoon that can hold an
/// impressive 952408144115 cubic meters of lava.
///
/// Convert the hexadecimal color codes into the correct instructions; if the
/// Elves follow this new dig plan, how many cubic meters of lava could the
/// lagoon hold?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 952408144115);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  (int, int) pos = (0, 0);
  Set<(int, int)> corners = {};

  int totalDistance = 0;
  for (String line in input) {
    String hex = line.split(' ')[2];
    String direction = hex.secondLast;
    int distance = int.parse(hex.skip(2).take(5), radix: 16);

    totalDistance += distance;
    pos += deltaPos(direction) * distance;
    corners.add(pos);
  }

  return shoelace(corners.toList()) + totalDistance ~/ 2 + 1;
}

int shoelace(List<(int, int)> ns) {
  return ([...ns, ns.first].sw(2).map((n) {
            final [(x1, y1), (x2, y2)] = n;
            return (y1 + y2) * (x1 - x2);
          }).sum() ~/
          2)
      .abs();
}

(int, int) deltaPos(String direction) {
  return switch (direction) {
    '3' => (-1, 0),
    '0' => (0, 1),
    '1' => (1, 0),
    _ => (0, -1),
  };
}
