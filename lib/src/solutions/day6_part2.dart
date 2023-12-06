import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// As the race is about to start, you realize the piece of paper with race
/// times and record distances you got earlier actually just has very bad
/// kerning. There's really only one race - ignore the spaces between the
///numbers on each line.
///
/// So, the example from before:
///
///   Time:      7  15   30
///   Distance:  9  40  200
///
/// ...now instead means this:
///
///   Time:      71530
///   Distance:  940200
///
/// Now, you have to figure out how many ways there are to win this single race.
/// In this example, the race lasts for 71530 milliseconds and the record
/// distance you need to beat is 940200 millimeters. You could hold the button
/// anywhere from 14 to 71516 milliseconds and beat the record, a total of 71503
/// ways!
///
/// How many ways can you beat the record in this one much longer race?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 71503);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  final [time, rdis] = input
      .map((s) => s
          .split(' ')
          .map(int.tryParse)
          .whereType<int>()
          .map((n) => n.toString())
          .join())
      .map(int.parse)
      .toList();

  return range(time) //
      .map((dur) => (time - dur) * dur)
      .where((dis) => dis > rdis)
      .length;
}
