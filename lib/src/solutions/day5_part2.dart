import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// Everyone will starve if you only plant such a small number of seeds.
/// Re-reading the almanac, it looks like the seeds: line actually describes
/// ranges of seed numbers.
///
/// The values on the initial seeds: line come in pairs. Within each pair, the
/// first value is the start of the range and the second value is the length of
/// the range. So, in the first line of the example above:
///
///   seeds: 79 14 55 13
///
/// This line describes two ranges of seed numbers to be planted in the garden.
/// The first range starts with seed number 79 and contains 14 values: 79, 80,
/// ..., 91, 92. The second range starts with seed number 55 and contains 13
/// values: 55, 56, ..., 66, 67.
///
/// Now, rather than considering four seed numbers, you need to consider a total
/// of 27 seed numbers.
///
/// In the above example, the lowest location number can be obtained from seed
/// number 82, which corresponds to soil 84, fertilizer 84, water 84, light 77,
/// temperature 45, humidity 46, and location 46. So, the lowest location number
/// is 46.
///
/// Consider all of the initial seed numbers listed in the ranges on the first
/// line of the almanac. What is the lowest location number that corresponds to
/// any of the initial seed numbers?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 46);

  int answer = solve(puzzleInput);
  print(answer);
}

RegExp reNumber = RegExp(r'\d+');

int solve(List<String> input) {
  List<int> ns = reNumber
      .allMatches(input.first)
      .map((e) => e.group(0)!)
      .map(int.parse)
      .toList();

  Iterable<Iterable<List<int>>> mss = parseMaps(input);

  List<int> locations = [];
  for (int i = 0; i < ns.length / 2; i++) {
    int start = ns[2 * i];
    int length = ns[2 * i + 1];

    for (int n = start; n < start + length; n++) {
      int location = mapMultipleTimes(n, mss);
      locations.add(location);
    }
  }
  return locations.min();
}

int mapMultipleTimes(
  int n,
  Iterable<Iterable<List<int>>> mss,
) {
  for (Iterable<List<int>> ms in mss) {
    n = map(n, ms);
  }
  return n;
}

int map(int n, Iterable<List<int>> ms) {
  for (List<int> m in ms) {
    final [dst, src, size] = m;
    if (n >= src && n < src + size) {
      return n - src + dst;
    }
  }
  return n;
}

Iterable<Iterable<List<int>>> parseMaps(List<String> input) {
  List<List<String>> tss = [];
  List<String> ts = [];

  for (String line in input.skip(2)) {
    if (line.isEmpty) {
      tss.add(ts);
      ts = [];
    } else if (!line.endsWith(':')) {
      ts.add(line);
    }
  }
  tss.add(ts);

  return tss.map(
    (ts) => ts.map(
      (t) => reNumber
          .allMatches(t)
          .map((e) => e.group(0)!)
          .map(int.parse)
          .toList(),
    ),
  );
}
