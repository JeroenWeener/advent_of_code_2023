import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// The Elf says they've stopped producing snow because they aren't getting any
/// water! He isn't sure why the water stopped; however, he can show you how to
/// get to the water source to check it out for yourself. It's just up ahead!
///
/// As you continue your walk, the Elf poses a second question: in each game you
/// played, what is the fewest number of cubes of each color that could have
/// been in the bag to make the game possible?
///
/// Again consider the example games from earlier:
///
///   Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
///   Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
///   Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
///   Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
///   Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
///
/// - In game 1, the game could have been played with as few as 4 red, 2 green,
///   and 6 blue cubes. If any color had even one fewer cube, the game would
///   have been impossible.
/// - Game 2 could have been played with a minimum of 1 red, 3 green, and 4 blue
///   cubes.
/// - Game 3 must have been played with at least 20 red, 13 green, and 6 blue
///   cubes.
/// - Game 4 required at least 14 red, 3 green, and 15 blue cubes.
/// - Game 5 needed no fewer than 6 red, 3 green, and 2 blue cubes in the bag.
///
/// The power of a set of cubes is equal to the numbers of red, green, and blue
/// cubes multiplied together. The power of the minimum set of cubes in game 1
/// is 48. In games 2-5 it was 12, 1560, 630, and 36, respectively. Adding up
/// these five powers produces the sum 2286.
///
/// For each game, find the minimum set of cubes that must have been present.
/// What is the sum of the power of these sets?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 2286);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  return input.map((game) => minCubesForGame(game).values.product()).sum();
}

Map<String, int> minCubesForGame(String game) {
  List<String> sets = game.split(': ').second.split('; ');
  Iterable<Map<String, int>> minCubesPerSet = sets.map(getCubesFromSet);

  Map<String, int> minCubes = {
    'red': 0,
    'green': 0,
    'blue': 0,
  };

  for (Map<String, int> minCubesForSet in minCubesPerSet) {
    minCubes.updateAll((key, value) =>
        (minCubesForSet[key] ?? 0) > value ? minCubesForSet[key] ?? 0 : value);
  }

  return minCubes;
}

Map<String, int> getCubesFromSet(String set) {
  return set.split(', ').map((cube) {
    final [quantity, color] = cube.split(' ');
    return (color, int.parse(quantity));
  }).asMap();
}
