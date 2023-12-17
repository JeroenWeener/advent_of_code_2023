import 'dart:collection';

import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Day 17: Clumsy Crucible ---
///
/// The lava starts flowing rapidly once the Lava Production Facility is
/// operational. As you leave, the reindeer offers you a parachute, allowing you
/// to quickly reach Gear Island.
///
/// As you descend, your bird's-eye view of Gear Island reveals why you had
/// trouble finding anyone on your way up: half of Gear Island is empty, but the
/// half below you is a giant factory city!
///
/// You land near the gradually-filling pool of lava at the base of your new
/// lavafall. Lavaducts will eventually carry the lava throughout the city, but
/// to make use of it immediately, Elves are loading it into large crucibles on
/// wheels.
///
/// The crucibles are top-heavy and pushed by hand. Unfortunately, the crucibles
/// become very difficult to steer at high speeds, and so it can be hard to go
/// in a straight line for very long.
///
/// To get Desert Island the machine parts it needs as soon as possible, you'll
/// need to find the best way to get the crucible from the lava pool to the
/// machine parts factory. To do this, you need to minimize heat loss while
/// choosing a route that doesn't require the crucible to go in a straight line
/// for too long.
///
/// Fortunately, the Elves here have a map (your puzzle input) that uses traffic
/// patterns, ambient temperature, and hundreds of other parameters to calculate
/// exactly how much heat loss can be expected for a crucible entering any
/// particular city block.
///
/// For example:
///
///   2413432311323
///   3215453535623
///   3255245654254
///   3446585845452
///   4546657867536
///   1438598798454
///   4457876987766
///   3637877979653
///   4654967986887
///   4564679986453
///   1224686865563
///   2546548887735
///   4322674655533
///
/// Each city block is marked by a single digit that represents the amount of
/// heat loss if the crucible enters that block. The starting point, the lava
/// pool, is the top-left city block; the destination, the machine parts
/// factory, is the bottom-right city block. (Because you already start in the
/// top-left block, you don't incur that block's heat loss unless you leave that
/// block and then return to it.)
///
/// Because it is difficult to keep the top-heavy crucible going in a straight
/// line for very long, it can move at most three blocks in a single direction
/// before it must turn 90 degrees left or right. The crucible also can't
/// reverse direction; after entering each city block, it may only turn left,
/// continue straight, or turn right.
///
/// One way to minimize heat loss is this path:
///
///   2>>34^>>>1323
///   32v>>>35v5623
///   32552456v>>54
///   3446585845v52
///   4546657867v>6
///   14385987984v4
///   44578769877v6
///   36378779796v>
///   465496798688v
///   456467998645v
///   12246868655<v
///   25465488877v5
///   43226746555v>
///
/// This path never moves more than three consecutive blocks in the same
/// direction and incurs a heat loss of only 102.
///
/// Directing the crucible from the lava pool to the machine parts factory, but
/// not moving more than three consecutive blocks in the same direction, what is
/// the least heat loss it can incur?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 102);

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
    NodeWithHeat v = queue.removeFirst();
    final ((direction, momentum, (r, c)), currentHeatLoss) = v;
    int newHeatLoss = int.parse(input[r][c]) + currentHeatLoss;

    int? cachedHeatLoss = visitedNodes[(direction, momentum, (r, c))];
    if (cachedHeatLoss != null && cachedHeatLoss <= newHeatLoss) {
      continue;
    }
    visitedNodes[(direction, momentum, (r, c))] = newHeatLoss;

    Iterable<NodeWithHeat> ns = neighbours(
      ((direction, momentum, (r, c)), newHeatLoss),
      (input.length, input.first.length),
    );
    for (NodeWithHeat n in ns) {
      queue.add(n);
    }
  }
  return visitedNodes.entries
          .where((node) {
            final (_, _, (r, c)) = node.key;
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
    if (d2 == direction && momentum == 2) {
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
