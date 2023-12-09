import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// To make things a little more interesting, the Elf introduces one additional
/// rule. Now, J cards are jokers - wildcards that can act like whatever card
/// would make the hand the strongest type possible.
///
/// To balance this, J cards are now the weakest individual cards, weaker even
/// than 2. The other cards stay in the same order: A, K, Q, T, 9, 8, 7, 6, 5,
/// 4, 3, 2, J.
///
/// J cards can pretend to be whatever card is best for the purpose of
/// determining hand type; for example, QJJQ2 is now considered four of a kind.
/// However, for the purpose of breaking ties between two hands of the same
/// type, J is always treated as J, not the card it's pretending to be: JKKK2 is
/// weaker than QQQQ2 because J is weaker than Q.
///
/// Now, the above example goes very differently:
///
///   32T3K 765
///   T55J5 684
///   KK677 28
///   KTJJT 220
///   QQQJA 483
///
/// - 32T3K is still the only one pair; it doesn't contain any jokers, so its
///   strength doesn't increase.
/// - KK677 is now the only two pair, making it the second-weakest hand.
/// - T55J5, KTJJT, and QQQJA are now all four of a kind! T55J5 gets rank 3,
///   QQQJA gets rank 4, and KTJJT gets rank 5.
///
/// With the new joker rule, the total winnings in this example are 5905.
///
/// Using the new joker rule, find the rank of every hand in your set. What are
/// the new total winnings?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 5905);

  int answer = solve(puzzleInput);
  print(answer);
}

List<String> order = 'A, K, Q, T, 9, 8, 7, 6, 5, 4, 3, 2, J'.split(', ');
int jCodeUnit = 'J'.codeUnits.first;

int solve(List<String> input) {
  List<String> hands = input //
      .map((line) => line.split(' ').first)
      .toList()
    ..sort(sortOnType);
  return hands.indexed.map((p) {
    final (index, hand) = p;
    return (index + 1) *
        int.parse(
          input //
              .firstWhere((line) => line.startsWith(hand))
              .split(' ')
              .second,
        );
  }).sum();
}

bool hasFiveOfAKind(String hand) {
  return hand.codeUnits.where((c) => c != jCodeUnit).toSet().length <= 1;
}

bool hasFourOfAKind(String hand) {
  Map<int, int> nonJokerCounts = hand.codeUnits //
      .where((c) => c != jCodeUnit)
      .countsMap();
  return nonJokerCounts.length == 2 &&
      nonJokerCounts.entries.any(
        (element) => element.value == 1,
      );
}

bool hasFullHouse(String hand) {
  return hand.codeUnits.where((c) => c != jCodeUnit).toSet().length == 2;
}

bool hasThreeOfAKind(String hand) {
  int jokerCount = hand.codeUnits //
      .where((c) => c == jCodeUnit)
      .length;
  List<MapEntry<int, int>> nonJokerCounts = hand.codeUnits
      .where((c) => c != jCodeUnit)
      .countsMap()
      .entries
      .toList()
    ..sort((a, b) => b.value - a.value);
  return jokerCount + nonJokerCounts.first.value == 3;
}

bool hasTwoPair(String hand) {
  return hand.codeUnits.toSet().length == 3;
}

bool hasOnePair(String hand) {
  return hand.codeUnits.toSet().length == 4 ||
      hand.codeUnits.contains(jCodeUnit);
}

int getTypeScore(String hand) {
  List<bool Function(String)> fs = [
    hasFiveOfAKind,
    hasFourOfAKind,
    hasFullHouse,
    hasThreeOfAKind,
    hasTwoPair,
    hasOnePair,
  ];

  for (int i = 0; i < fs.length; i++) {
    if (fs[i](hand)) {
      return fs.length - i;
    }
  }
  return 0;
}

int sortOnType(String handA, String handB) {
  int typeScore = getTypeScore(handA) - getTypeScore(handB);

  if (typeScore != 0) {
    return typeScore;
  }
  return sortOnLabel(handA, handB);
}

int sortOnLabel(String a, String b) {
  final c1 = a[0];
  final c2 = b[0];

  if (c1 != c2) {
    return order.indexOf(c2) - order.indexOf(c1);
  }
  return sortOnLabel(a.substring(1), b.substring(1));
}
