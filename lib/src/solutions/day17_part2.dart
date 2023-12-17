import 'dart:collection';

import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// The crucibles of lava simply aren't large enough to provide an adequate
/// supply of lava to the machine parts factory. Instead, the Elves are going to
/// upgrade to ultra crucibles.
///
/// Ultra crucibles are even more difficult to steer than normal crucibles. Not
/// only do they have trouble going in a straight line, but they also have
/// trouble turning!
///
/// Once an ultra crucible starts moving in a direction, it needs to move a
/// minimum of four blocks in that direction before it can turn (or even before
/// it can stop at the end). However, it will eventually start to get wobbly: an
/// ultra crucible can move a maximum of ten consecutive blocks without turning.
///
/// In the above example, an ultra crucible could follow this path to minimize
/// heat loss:
///
///   2>>>>>>>>1323
///   32154535v5623
///   32552456v4254
///   34465858v5452
///   45466578v>>>>
///   143859879845v
///   445787698776v
///   363787797965v
///   465496798688v
///   456467998645v
///   122468686556v
///   254654888773v
///   432267465553v
///
/// In the above example, an ultra crucible would incur the minimum possible
/// heat loss of 94.
///
/// Here's another example:
///
///   111111111111
///   999999999991
///   999999999991
///   999999999991
///   999999999991
///
/// Sadly, an ultra crucible would need to take an unfortunate path like this
/// one:
///
///   1>>>>>>>1111
///   9999999v9991
///   9999999v9991
///   9999999v9991
///   9999999v>>>>
///
/// This route causes the ultra crucible to incur the minimum possible heat loss
/// of 71.
///
/// Directing the ultra crucible from the lava pool to the machine parts
/// factory, what is the least heat loss it can incur?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 94);

  int answer = solve(puzzleInput);
  print(answer);
}

typedef Coordinate = (int, int);
typedef Node = (int, int, Coordinate);
typedef NodeWithHeat = (Node, int);

int solve(List<String> input) {
  Queue<NodeWithHeat> queue = Queue();
  Map<Node, int> visitedNodes = {};

  queue.add(((1, 0, (0, 0)), 0));
  queue.add(((2, 0, (0, 0)), 0));

  while (queue.isNotEmpty) {
    final v = queue.removeFirst();
    final ((d, consec, (r, c)), heatLossUntilNow) = v;
    int totalHeatLoss = int.parse(input[r][c]) + heatLossUntilNow;

    int? previousTotalHeatLoss = visitedNodes[(d, consec, (r, c))];
    if (previousTotalHeatLoss != null &&
        previousTotalHeatLoss <= totalHeatLoss) {
      continue;
    }
    visitedNodes[(d, consec, (r, c))] = totalHeatLoss;

    Iterable<NodeWithHeat> ns = neighbours(((d, consec, (r, c)), totalHeatLoss),
        (input.length, input.first.length));
    for (NodeWithHeat n in ns) {
      queue.add(n);
    }
  }

  return visitedNodes.entries
          .where((element) {
            final (_, _, (r, c)) = element.key;
            return r == input.length - 1 && c == input.first.length - 1;
          })
          .map((e) => e.value)
          .min() -
      int.parse(input[0][0]);
}

Iterable<NodeWithHeat> neighbours(
  NodeWithHeat v,
  Coordinate dimensions,
) {
  final ((direction, momentum, (r, c)), heatLoss) = v;
  return [
    (0, (r - 1, c)),
    (1, (r, c + 1)),
    (2, (r + 1, c)),
    (3, (r, c - 1)),
  ].where(((int, Coordinate) e) {
    final (d2, (r2, c2)) = e;
    if ((d2 + 2) % 4 == direction) {
      return false;
    }
    if (d2 == direction && momentum == 9) {
      return false;
    }
    if (d2 != direction && momentum < 3) {
      return false;
    }
    if (r2 < 0 || r2 >= dimensions.$1 || c2 < 0 || c2 >= dimensions.$2) {
      return false;
    }
    return true;
  }).map((e) {
    final (d3, (r3, c3)) = e;
    return ((d3, d3 == direction ? momentum + 1 : 0, (r3, c3)), heatLoss);
  });
}
