import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 467835);

  int answer = solve(puzzleInput);
  print(answer);
}

RegExp reDigit = RegExp(r'\d');
RegExp reStar = RegExp(r'\*');

(List<(int, (int, int))>, List<(int, int, int)>) parseLine(
  String line,
  int lineIndex,
) {
  // (part number, gear coordinates)
  List<(int, (int, int))> confirmedParts = [];
  // (part number, position, length)
  List<(int, int, int)> pendingParts = [];

  String numberBuffer = '';
  bool hasPrecedingStar = false;
  int startingPoint = 0;

  for (int characterIndex = 0; characterIndex < line.length; characterIndex++) {
    String c = line[characterIndex];

    if (reDigit.hasMatch(c)) {
      // Digit
      if (numberBuffer.isEmpty) {
        startingPoint = characterIndex;
      }
      numberBuffer += c;
    } else if (reStar.hasMatch(c)) {
      // Star
      if (numberBuffer.isNotEmpty) {
        int partNumber = int.parse(numberBuffer);
        numberBuffer = '';
        confirmedParts.add((partNumber, (lineIndex, characterIndex)));
      }
      hasPrecedingStar = true;
    } else {
      // Dot
      if (numberBuffer.isNotEmpty) {
        int partNumber = int.parse(numberBuffer);
        if (hasPrecedingStar) {
          confirmedParts.add(
            (partNumber, (lineIndex, characterIndex - numberBuffer.length - 1)),
          );
        } else {
          pendingParts.add((partNumber, startingPoint, numberBuffer.length));
        }
        numberBuffer = '';
      }
      hasPrecedingStar = false;
    }
  }

  return (confirmedParts, pendingParts);
}

int solve(List<String> input) {
  input = input.map((line) => line += '.').toList();
  int lineLength = input.first.length;

  // (part, gear coordinates)
  List<(int, (int, int))> allConfirmedParts = [];
  // (line number, [(part number, position, length)])
  List<(int, List<(int, int, int)>)> allPendingParts = [];

  for (int lineIndex = 0; lineIndex < input.length; lineIndex++) {
    String line = input[lineIndex];

    final (confirmedParts, pendingParts) = parseLine(line, lineIndex);

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

        if (above != null && reStar.hasMatch(above)) {
          allConfirmedParts.add((n, (lineNumber - 1, x)));
        }
        if (below != null && reStar.hasMatch(below)) {
          allConfirmedParts.add((n, (lineNumber + 1, x)));
        }
      }
    }
  }

  return allConfirmedParts.map((part) {
        (int, int) gearCoordinates = part.$2;
        Iterable<(int, (int, int))> partsAroundGear =
            allConfirmedParts.where((part) => part.$2 == gearCoordinates);

        if (partsAroundGear.length != 2) {
          return 0;
        }

        int first = partsAroundGear.first.$1;
        int last = partsAroundGear.last.$1;

        return first * last;
      }).sum() ~/
      2;
}
