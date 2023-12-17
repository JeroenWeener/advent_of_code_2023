import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// You resume walking through the valley of mirrors and - SMACK! - run directly
/// into one. Hopefully nobody was watching, because that must have been pretty
/// embarrassing.
///
/// Upon closer inspection, you discover that every mirror has exactly one
/// smudge: exactly one . or # should be the opposite type.
///
/// In each pattern, you'll need to locate and fix the smudge that causes a
/// different reflection line to be valid. (The old reflection line won't
/// necessarily continue being valid after the smudge is fixed.)
///
/// Here's the above example again:
///
///   #.##..##.
///   ..#.##.#.
///   ##......#
///   ##......#
///   ..#.##.#.
///   ..##..##.
///   #.#.##.#.
///
///   #...##..#
///   #....#..#
///   ..##..###
///   #####.##.
///   #####.##.
///   ..##..###
///   #....#..#
///
/// The first pattern's smudge is in the top-left corner. If the top-left # were
/// instead ., it would have a different, horizontal line of reflection:
///
///   1 ..##..##. 1
///   2 ..#.##.#. 2
///   3v##......#v3
///   4^##......#^4
///   5 ..#.##.#. 5
///   6 ..##..##. 6
///   7 #.#.##.#. 7
///
/// With the smudge in the top-left corner repaired, a new horizontal line of
/// reflection between rows 3 and 4 now exists. Row 7 has no corresponding
/// reflected row and can be ignored, but every other row matches exactly: row 1
/// matches row 6, row 2 matches row 5, and row 3 matches row 4.
///
/// In the second pattern, the smudge can be fixed by changing the fifth symbol
/// on row 2 from . to #:
///
///   1v#...##..#v1
///   2^#...##..#^2
///   3 ..##..### 3
///   4 #####.##. 4
///   5 #####.##. 5
///   6 ..##..### 6
///   7 #....#..# 7
///
/// Now, the pattern has a different horizontal line of reflection between rows
/// 1 and 2.
///
/// Summarize your notes as before, but instead use the new different reflection
/// lines. In this example, the first pattern's new horizontal line has 3 rows
/// above it and the second pattern's new horizontal line has 1 row above it,
/// summarizing to the value 400.
///
/// In each pattern, fix the smudge and find the different line of reflection.
/// What number do you get after summarizing the new reflection line in each
/// pattern in your notes?
void main() async {
  String puzzleInput = await Aoc.puzzleInputString;
  String testInput = await Aoc.testInputString;

  assert(solve(testInput) == 400);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(String input) {
  Iterable<List<String>> patterns = input //
      .split('\n\n')
      .map((t) => t.split('\n'));
  Iterable<int> horizontalReflections = patterns.map(horizontalReflection);
  Iterable<int> verticalReflections =
      patterns.map((p) => horizontalReflection(p //
          .T()
          .toList()));

  return 100 *
          horizontalReflections //
              .where((r) => r != -1)
              .sum() +
      verticalReflections //
          .where((c) => c != -1)
          .sum();
}

int differencesBetweenRows(String rowA, String rowB) {
  int differences = 0;
  for (int i = 0; i < rowA.length; i++) {
    if (rowA[i] != rowB[i]) {
      differences++;
    }
  }
  return differences;
}

int horizontalReflection(List<String> pattern) {
  for (int i = 0; i < pattern.length - 1; i++) {
    bool fixedSmudge = false;
    String rowA = pattern[i];
    String rowB = pattern[i + 1];
    int differences = differencesBetweenRows(rowA, rowB);
    if (differences < 2) {
      if (differences == 1) {
        fixedSmudge = true;
      }
      bool areMatching = true;
      for (int j = 1; j < [i + 1, pattern.length - i - 1].min(); j++) {
        String rowA = pattern[i - j];
        String rowB = pattern[i + j + 1];
        int differences = differencesBetweenRows(rowA, rowB);
        if (differences > 1 || differences == 1 && fixedSmudge) {
          areMatching = false;
          break;
        }
        if (differences == 1) {
          fixedSmudge = true;
        }
      }
      if (areMatching && fixedSmudge) {
        return i + 1;
      }
    }
  }
  return -1;
}
