// import 'dart:collection';

// import 'package:advent_of_code_2023/advent_of_code_2023.dart';

// void main() async {
//   List<String> puzzleInput = await Aoc.puzzleInputStrings;
//   List<String> testInput = await Aoc.testInputStrings;

//   int answer = solve(testInput);
//   print(answer);
// }

// int solve(List<String> input) {
//   Set<(int, int)> rocks = {};
//   Set<(int, int)> visitedGrid = {};
//   Set<(int, int)> destinationsGrid = {};
//   Set<(int, int)> positions = {};
//   (int, int) dimensions = (input.length, input.first.length);

//   for (var r = 0; r < input.length; r++) {
//     for (var c = 0; c < input.first.length; c++) {
//       if (input[r][c] == '#') {
//         rocks.add((r, c));
//       }
//       if (input[r][c] == 'S') {
//         visitedGrid.add((r, c));
//         positions.add((r, c));
//       }
//     }
//   }

//   for (var i = 0; i < 5000; i++) {
//     Set<(int, int)> ps = positions
//         .map((pos) {
//           List<(int, int)> ns =
//               neighbours(rocks, visitedGrid, destinationsGrid, pos, dimensions);
//           for (var n in ns) {
//             if (i % 2 == 1) {
//               destinationsGrid.add(n);
//             }
//             visitedGrid.add(n);
//           }
//           return ns;
//         })
//         .flatten()
//         .toSet();
//     positions = ps;
//   }
//   return destinationsGrid.length;
// }

// List<(int, int)> neighbours(
//   Set<(int, int)> rocks,
//   Set<(int, int)> visitedGrid,
//   Set<(int, int)> destinationGrid,
//   (int, int) position,
//   (int, int) dimensions,
// ) {
//   return [
//     position + (-1, 0),
//     position + (0, 1),
//     position + (1, 0),
//     position + (0, -1),
//   ]
//       .where((element) => !visitedGrid.contains(element))
//       .where((element) => !rocks
//           .contains((element.$1 % dimensions.$1, element.$2 % dimensions.$2)))
//       .toList();
// }

// /// Het is niet meer te doen om alles handmatig uit te rekenen.
// /// 
// /// Als we uitrekenen in hoeveel stappen hij bij de naburige S is kunnen we
// /// misschien iets slims doen.
// /// 
// /// Het is een 131x131 grid, dus waarschijnlijk moet je 2 neighbors verder
// /// kijken om iets nuttigs te kunnen zeggen.
// /// 
// /// Na 2 neighbors te bereiken weet je alles wat je weten moet.
// /// Als je vanuit S in 6 stappen 4 plaatsen bezoekt, en het duurt 100 stappen om
// /// bij de tweede buurman te komen, dan heb je in 106 stappen daar ook 4
// /// plaatsen bezocht