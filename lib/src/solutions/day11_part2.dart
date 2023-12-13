import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// The galaxies are much older (and thus much farther apart) than the
/// researcher initially estimated.
///
/// Now, instead of the expansion you did before, make each empty row or column
/// one million times larger. That is, each empty row should be replaced with
/// 1000000 empty rows, and each empty column should be replaced with 1000000
/// empty columns.
///
/// (In the example above, if each empty row or column were merely 10 times
/// larger, the sum of the shortest paths between every pair of galaxies would
/// be 1030. If each empty row or column were merely 100 times larger, the sum
/// of the shortest paths between every pair of galaxies would be 8410. However,
/// your universe will need to expand far beyond these values.)
///
/// Starting with the same initial image, expand the universe according to these
/// new rules, then find the length of the shortest path between every pair of
/// galaxies. What is the sum of these lengths?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput, 10) == 1030);
  assert(solve(testInput, 100) == 8410);

  int answer = solve(puzzleInput, 1000000);
  print(answer);
}

int solve(List<String> input, int expansionRange) {
  List<(int, int)> galaxies = [];
  for (int r = 0; r < input.length; r++) {
    for (int c = 0; c < input.first.length; c++) {
      if (input[r][c] == '#') {
        galaxies.add((r, c));
      }
    }
  }

  List<int> gIndexesToMove = [];
  for (int r = 0; r < input.length; r++) {
    if (input[r].every((s) => s == '.')) {
      for (int gIndex = 0; gIndex < galaxies.length; gIndex++) {
        if (galaxies[gIndex].$1 > r) {
          gIndexesToMove.add(gIndex);
        }
      }
    }
  }
  for (int gIndex in gIndexesToMove) {
    galaxies[gIndex] = (
      galaxies[gIndex].$1 + expansionRange - 1,
      galaxies[gIndex].$2,
    );
  }

  gIndexesToMove.clear();
  for (int c = 0; c < input.first.length; c++) {
    if (input.map((r) => r[c]).every((s) => s == '.')) {
      for (int gIndex = 0; gIndex < galaxies.length; gIndex++) {
        if (galaxies[gIndex].$2 > c) {
          gIndexesToMove.add(gIndex);
        }
      }
    }
  }
  for (int galaxyIndex in gIndexesToMove) {
    galaxies[galaxyIndex] = (
      galaxies[galaxyIndex].$1,
      galaxies[galaxyIndex].$2 + expansionRange - 1,
    );
  }

  return galaxies //
      .combinations()
      .map((e) => distance(e.$1, e.$2))
      .sum();
}

int distance(
  (int, int) a,
  (int, int) b,
) {
  return (a.$1 - b.$1).abs() + (a.$2 - b.$2).abs();
}
