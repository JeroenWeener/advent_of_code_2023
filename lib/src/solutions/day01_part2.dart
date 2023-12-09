import 'package:advent_of_code_2023/src/aoc.dart';
import 'package:advent_of_code_2023/src/number_extensions.dart';

/// --- Part Two ---
///
/// Your calculation isn't quite right. It looks like some of the digits are
/// actually spelled out with letters: one, two, three, four, five, six, seven,
/// eight, and nine also count as valid "digits".
///
/// Equipped with this new information, you now need to find the real first and
/// last digit on each line. For example:
///
///   	two1nine
///   	eightwothree
///   	abcone2threexyz
///   	xtwone3four
///   	4nineeightseven2
///   	zoneight234
///   	7pqrstsixteen
///
/// In this example, the calibration values are 29, 83, 13, 24, 42, 14, and 76.
/// Adding these together produces 281.
///
/// What is the sum of all of the calibration values?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStringsAlt;

  assert(solve(testInput) == 281);

  int answer = solve(puzzleInput);
  print(answer);
}

Map<String, int> m = {
  'one': 1,
  'two': 2,
  'three': 3,
  'four': 4,
  'five': 5,
  'six': 6,
  'seven': 7,
  'eight': 8,
  'nine': 9,
};

int solve(List<String> input) {
  return input.map((String s) {
    int first = firstDigit(s);
    int last = lastDigit(s);
    return 10 * first + last;
  }).sum();
}

int? digitInString(String s) {
  int? d = s.split('').map(int.tryParse).whereType<int>().firstOrNull;
  if (d != null) {
    return d;
  }

  for (String k in m.keys) {
    if (s.contains(k)) {
      return m[k];
    }
  }

  return null;
}

int firstDigit(String s) {
  String buffer = '';
  for (int i = 0; i < s.length; i++) {
    buffer += s[i];
    int? d = digitInString(buffer);
    if (d != null) {
      return d;
    }
  }
  throw Exception('No digit found');
}

int lastDigit(String s) {
  String buffer = '';
  for (int i = 0; i < s.length; i++) {
    buffer = s[s.length - 1 - i] + buffer;
    int? d = digitInString(buffer);
    if (d != null) {
      return d;
    }
  }
  throw Exception('No digit found');
}
