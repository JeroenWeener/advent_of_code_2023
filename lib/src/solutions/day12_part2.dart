import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// As you look out at the field of springs, you feel like there are way more
/// springs than the condition records list. When you examine the records, you
/// discover that they were actually folded up this whole time!
///
/// To unfold the records, on each row, replace the list of spring conditions
/// with five copies of itself (separated by ?) and replace the list of
/// contiguous groups of damaged springs with five copies of itself (separated
/// by ,).
///
/// So, this row:
///
///   .# 1
///
/// Would become:
///
///   .#?.#?.#?.#?.# 1,1,1,1,1
///
/// The first line of the above example would become:
///
///   ???.###????.###????.###????.###????.### 1,1,3,1,1,3,1,1,3,1,1,3,1,1,3
///
/// In the above example, after unfolding, the number of possible arrangements
/// for some rows is now much larger:
///
/// - ???.### 1,1,3 - 1 arrangement
/// - .??..??...?##. 1,1,3 - 16384 arrangements
/// - ?#?#?#?#?#?#?#? 1,3,1,6 - 1 arrangement
/// - ????.#...#... 4,1,1 - 16 arrangements
/// - ????.######..#####. 1,6,5 - 2500 arrangements
/// - ?###???????? 3,2,1 - 506250 arrangements
///
/// After unfolding, adding all of the possible arrangement counts together
/// produces 525152.
///
/// Unfold your condition records; what is the new sum of possible arrangement
/// counts?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 525152);

  int answer = solve(puzzleInput);
  print(answer);
}

Map<String, int> cache = {};

int solve(List<String> input) {
  return input.map((line) {
    final [sequence, lengths] = line.split(' ');
    return dfs(sequence.repeat(5).join('?'),
        lengths.split(',').map(int.parse).repeat(5));
  }).sum();
}

int dfs(String sequence, Iterable<int> lengths) {
  int? cachedValue = cache[sequence + lengths.join('*')];
  if (cachedValue != null) {
    return cachedValue;
  }

  if (lengths.isEmpty) {
    return sequence.contains('#') ? 0 : 1;
  }

  int score = 0;
  for (int index = 0; index < sequence.length - lengths.first + 1; index++) {
    if (!sequence.substring(index, index + lengths.first).contains('.')) {
      if (sequence.length - index == lengths.first) {
        score += dfs('', lengths.skip(1));
      } else if (sequence[index + lengths.first] != '#') {
        score +=
            dfs(sequence.substring(index + lengths.first + 1), lengths.skip(1));
      }
    }
    if (sequence[index] == '#') {
      break;
    }
  }

  cache[sequence + lengths.join('*')] = score;
  return score;
}
