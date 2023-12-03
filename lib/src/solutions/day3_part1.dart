import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 4361);

  int answer = solve(puzzleInput);
  print(answer);
}

RegExp reDigit = RegExp(r'\d');
RegExp reSymbol = RegExp(r'[^.\d]');

(List<int>, List<(int, int, int)>) parseLine(String line) {
  List<int> confirmedParts = [];
  // (part number, position, length)
  List<(int, int, int)> pendingParts = [];

  String numberBuffer = '';
  bool hasPrecedingSymbol = false;
  int startingPoint = 0;

  for (int characterIndex = 0; characterIndex < line.length; characterIndex++) {
    String c = line[characterIndex];

    if (reDigit.hasMatch(c)) {
      // Digit
      if (numberBuffer.isEmpty) {
        startingPoint = characterIndex;
      }
      numberBuffer += c;
    } else if (reSymbol.hasMatch(c)) {
      // Symbol
      if (numberBuffer.isNotEmpty) {
        int partNumber = int.parse(numberBuffer);
        numberBuffer = '';
        confirmedParts.add(partNumber);
      }
      hasPrecedingSymbol = true;
    } else {
      // Dot
      if (numberBuffer.isNotEmpty) {
        int partNumber = int.parse(numberBuffer);
        if (hasPrecedingSymbol) {
          confirmedParts.add(partNumber);
        } else {
          pendingParts.add((partNumber, startingPoint, numberBuffer.length));
        }
        numberBuffer = '';
      }
      hasPrecedingSymbol = false;
    }
  }

  return (confirmedParts, pendingParts);
}

int solve(List<String> input) {
  input = input.map((line) => line += '.').toList();
  int lineLength = input.first.length;

  List<int> allConfirmedParts = [];
  // (line number, [(part number, position, length)])
  List<(int, List<(int, int, int)>)> allPendingParts = [];

  for (int lineIndex = 0; lineIndex < input.length; lineIndex++) {
    String line = input[lineIndex];

    final (confirmedParts, pendingParts) = parseLine(line);

    allConfirmedParts.addAll(confirmedParts);
    allPendingParts.add((lineIndex, pendingParts));
  }

  for (final (int lineNumber, a) in allPendingParts) {
    for (final (int n, int pos, int length) in a) {
      int xMin = [0, pos - 1].max();
      int xMax = [lineLength, pos + length + 1].min();

      for (int x = xMin; x < xMax; x++) {
        String? above = lineNumber > 0 ? input[lineNumber - 1][x] : null;
        String? below =
            lineNumber < input.length - 1 ? input[lineNumber + 1][x] : null;

        if (above != null && reSymbol.hasMatch(above) ||
            below != null && reSymbol.hasMatch(below)) {
          allConfirmedParts.add(n);
          break;
        }
      }
    }
  }

  return allConfirmedParts.sum();
}
