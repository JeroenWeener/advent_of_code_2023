import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// You quickly reach the farthest point of the loop, but the animal never
/// emerges. Maybe its nest is within the area enclosed by the loop?
///
/// To determine whether it's even worth taking the time to search for such a
/// nest, you should calculate how many tiles are contained within the loop. For
/// example:
///
///   ...........
///   .S-------7.
///   .|F-----7|.
///   .||.....||.
///   .||.....||.
///   .|L-7.F-J|.
///   .|..|.|..|.
///   .L--J.L--J.
///   ...........
///
/// The above loop encloses merely four tiles - the two pairs of . in the
/// southwest and southeast (marked I below). The middle . tiles (marked O
/// below) are not in the loop. Here is the same loop again with those regions
/// marked:
///
///   ...........
///   .S-------7.
///   .|F-----7|.
///   .||OOOOO||.
///   .||OOOOO||.
///   .|L-7OF-J|.
///   .|II|O|II|.
///   .L--JOL--J.
///   .....O.....
///
/// In fact, there doesn't even need to be a full tile path to the outside for
/// tiles to count as outside the loop - squeezing between pipes is also
/// allowed! Here, I is still within the loop and O is still outside the loop:
///
///   ..........
///   .S------7.
///   .|F----7|.
///   .||OOOO||.
///   .||OOOO||.
///   .|L-7F-J|.
///   .|II||II|.
///   .L--JL--J.
///   ..........
///
/// In both of the above examples, 4 tiles are enclosed by the loop.
///
/// Here's a larger example:
///
///   .F----7F7F7F7F-7....
///   .|F--7||||||||FJ....
///   .||.FJ||||||||L7....
///   FJL7L7LJLJ||LJ.L-7..
///   L--J.L7...LJS7F-7L7.
///   ....F-J..F7FJ|L7L7L7
///   ....L7.F7||L7|.L7L7|
///   .....|FJLJ|FJ|F7|.LJ
///   ....FJL-7.||.||||...
///   ....L---J.LJ.LJLJ...
///
/// The above sketch has many random bits of ground, some of which are in the
/// loop (I) and some of which are outside it (O):
///
///   OF----7F7F7F7F-7OOOO
///   O|F--7||||||||FJOOOO
///   O||OFJ||||||||L7OOOO
///   FJL7L7LJLJ||LJIL-7OO
///   L--JOL7IIILJS7F-7L7O
///   OOOOF-JIIF7FJ|L7L7L7
///   OOOOL7IF7||L7|IL7L7|
///   OOOOO|FJLJ|FJ|F7|OLJ
///   OOOOFJL-7O||O||||OOO
///   OOOOL---JOLJOLJLJOOO
///
/// In this larger example, 8 tiles are enclosed by the loop.
///
/// Any tile that isn't part of the main loop can count as being enclosed by the
/// loop. Here's another example with many bits of junk pipe lying around that
/// aren't connected to the main loop at all:
///
///   FF7FSF7F7F7F7F7F---7
///   L|LJ||||||||||||F--J
///   FL-7LJLJ||||||LJL-77
///   F--JF--7||LJLJ7F7FJ-
///   L---JF-JLJ.||-FJLJJ7
///   |F|F-JF---7F7-L7L|7|
///   |FFJF7L7F-JF7|JL---7
///   7-L-JL7||F7|L7F-7F7|
///   L.L7LFJ|||||FJL7||LJ
///   L7JLJL-JLJLJL--JLJ.L
///
/// Here are just the tiles that are enclosed by the loop marked with I:
///
///   FF7FSF7F7F7F7F7F---7
///   L|LJ||||||||||||F--J
///   FL-7LJLJ||||||LJL-77
///   F--JF--7||LJLJIF7FJ-
///   L---JF-JLJIIIIFJLJJ7
///   |F|F-JF---7IIIL7L|7|
///   |FFJF7L7F-JF7IIL---7
///   7-L-JL7||F7|L7F-7F7|
///   L.L7LFJ|||||FJL7||LJ
///   L7JLJL-JLJLJL--JLJ.L
///
/// In this last example, 10 tiles are enclosed by the loop.
///
/// Figure out whether you have time to search for the nest by calculating the
/// area within the loop. How many tiles are enclosed by the loop?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 4);

  int answer = solve(puzzleInput);
  print(answer);
}

Map<String, List<int>> connectionDirections = {
  '.': [],
  '|': [0, 2],
  '-': [1, 3],
  '7': [2, 3],
  'F': [1, 2],
  'J': [3, 0],
  'L': [0, 1],
  'S': [],
};

int solve(List<String> input) {
  String emptyRow = '.' * input.first.length;
  input = [emptyRow, ...input, emptyRow].map((e) => '.$e.').toList();

  bool hasChanged;
  do {
    hasChanged = false;
    List<String> results = [input.first];
    for (int r = 1; r < input.length - 1; r++) {
      String result = '';
      for (int c = 1; c < input.first.length - 1; c++) {
        String pipe = input[r][c];
        Set<int> neededConnections = connectionDirections[pipe]!.toSet();
        Set<int> actualConnections = connectedDirections(input, r, c).toSet();

        if (!actualConnections.containsAll(neededConnections)) {
          result += '.';
          hasChanged = true;
        } else {
          result += pipe;
        }
      }
      results.add('.$result.');
    }
    results.add(input.last);
    input = results;
  } while (hasChanged);

  return shrink(reachable(expand(input))).flatten().where((e) => !e).length;
}

List<List<bool>> reachable(List<String> input) {
  List<List<bool>> results = List.generate(
    input.length,
    (e) => e == 0 || e == input.length - 1
        ? List.filled(input.first.length, true)
        : List.generate(
            input.first.length,
            (e) => e == 0 || e == input.first.length - 1,
          ),
  );

  bool hasChanges;
  do {
    hasChanges = false;
    for (int r = 1; r < results.length - 1; r++) {
      for (int c = 1; c < results.first.length - 1; c++) {
        if (input[r][c] == '.') {
          List<bool> ns = [
            results[r - 1][c],
            results[r][c + 1],
            results[r + 1][c],
            results[r][c - 1],
          ];
          if (ns.any((n) => n) && !results[r][c]) {
            results[r][c] = true;
            hasChanges = true;
          }
        }
      }
    }
  } while (hasChanges);

  for (int r = 0; r < input.length; r++) {
    for (int c = 0; c < input.first.length; c++) {
      if (input[r][c] != '.') {
        results[r][c] = true;
      }
    }
  }

  return results;
}

List<List<bool>> shrink(List<List<bool>> input) {
  List<List<bool>> results = [];
  for (int r = 0; r < input.length; r += 2) {
    List<bool> result = [];
    for (int c = 0; c < input.first.length; c += 2) {
      result.add(input[r][c]);
    }
    results.add(result);
  }
  return results;
}

List<String> expand(List<String> input) {
  return input
      .expand((r) => [
            r,
            r.map((c) => 'SF7|'.contains(c) ? '|' : '.').join(),
          ])
      .map((r) => r
          .expand((c) => [
                c,
                'SFL-'.contains(c) ? '-' : '.',
              ])
          .join())
      .toList();
}

List<int> connectedDirections(
  List<String> input,
  int r,
  int c,
) {
  return [
    if ('SF7|'.contains(input[r - 1][c])) 0,
    if ('SJ7-'.contains(input[r][c + 1])) 1,
    if ('SJL|'.contains(input[r + 1][c])) 2,
    if ('SFL-'.contains(input[r][c - 1])) 3,
  ];
}
