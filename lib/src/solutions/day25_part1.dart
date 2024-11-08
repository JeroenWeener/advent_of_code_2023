import 'dart:math';

import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  Set<Set<String>> nodes = input
      .map((e) => e
          .split(': ')
          .map((e) => e.split(' '))
          .reduce((value, element) => value + element))
      .reduce((value, element) => value + element)
      .map((e) => {e})
      .toSet();

  List<Edge> edges = [];
  for (var line in input) {
    String nodeA = line.split(':').first;
    List<String> otherNodes = line.split(': ').second.split(' ');
    for (var otherNode in otherNodes) {
      edges.add(Edge({nodeA}, {otherNode}));
    }
  }

  return contract(nodes, edges);
}

int contract(Set<Set<String>> nodes, List<Edge> edges) {
  int count = 0;
  while (true) {
    Set<Set<String>> v = {...nodes};
    List<Edge> e = [...edges];

    print(count++);

    while (v.length > 2) {
      Edge randomEdge = e[Random().nextInt(e.length)];

      Set<String> nodeA = randomEdge.nodeA;
      Set<String> nodeB = randomEdge.nodeB;
      Set<String> newNode = {...nodeA, ...nodeB};

      e = e
          .where((edge) => !(edge.contains(nodeA) && edge.contains(nodeB)))
          .map((edge) {
        if (edge.contains(nodeA)) {
          return Edge(newNode, edge.other(nodeA));
        } else if (edge.contains(nodeB)) {
          return Edge(newNode, edge.other(nodeB));
        }
        return edge;
      }).toList();

      v.removeWhere((element) => element.containsAll(nodeA));
      v.removeWhere((element) => element.containsAll(nodeB));
      v.add(newNode);
    }

    if (e.length == 3) {
      return v.first.length * v.second.length;
    }
  }
}

class Edge {
  const Edge(this.nodeA, this.nodeB);

  final Set<String> nodeA;
  final Set<String> nodeB;

  bool contains(Set<String> node) {
    return nodeA.containsAll(node) || nodeB.containsAll(node);
  }

  Set<String> other(Set<String> node) {
    assert(nodeA.containsAll(node) || nodeB.containsAll(node));

    return nodeA.containsAll(node) ? nodeB : nodeA;
  }

  @override
  String toString() {
    return '$nodeA-$nodeB';
  }

  @override
  operator ==(Object other) {
    return other is Edge &&
        ((other.nodeA == nodeA && other.nodeB == nodeB) ||
            (other.nodeA == nodeB && other.nodeB == nodeA));
  }

  @override
  int get hashCode => nodeA.hashCode ^ nodeB.hashCode;
}
