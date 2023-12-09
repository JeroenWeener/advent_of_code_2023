import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// The engineer finds the missing part and installs it in the engine! As the
/// engine springs to life, you jump in the closest gondola, finally ready to
/// ascend to the water source.
///
/// You don't seem to be going very fast, though. Maybe something is still
/// wrong? Fortunately, the gondola has a phone labeled "help", so you pick it
/// up and the engineer answers.
///
/// Before you can explain the situation, she suggests that you look out the
/// window. There stands the engineer, holding a phone in one hand and waving
/// with the other. You're going so slowly that you haven't even left the
/// station. You exit the gondola.
///
/// The missing part wasn't the only issue - one of the gears in the engine is
/// wrong. A gear is any * symbol that is adjacent to exactly two part numbers.
/// Its gear ratio is the result of multiplying those two numbers together.
///
/// This time, you need to find the gear ratio of every gear and add them all up
/// so that the engineer can figure out which gear needs to be replaced.
///
/// Consider the same engine schematic again:
///
///   467..114..
///   ...*......
///   ..35..633.
///   ......#...
///   617*......
///   .....+.58.
///   ..592.....
///   ......755.
///   ...$.*....
///   .664.598..
///
/// In this schematic, there are two gears. The first is in the top left; it has
/// part numbers 467 and 35, so its gear ratio is 16345. The second gear is in
/// the lower right; its gear ratio is 451490. (The * adjacent to 617 is not a
/// gear because it is only adjacent to one part number.) Adding up all of the
/// gear ratios produces 467835.
///
/// What is the sum of all of the gear ratios in your engine schematic?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 467835);

  int answer = solve(puzzleInput);
  print(answer);
}

RegExp reDigit = RegExp(r'\d');
RegExp reStar = RegExp(r'\*');

typedef PotentialPart = ({
  int partNumber,
  int position,
  int length,
});

typedef Part = ({
  int partNumber,
  (int, int) gearPos,
});

(List<Part>, List<PotentialPart>) parseLine(
  String line,
  int lineIndex,
) {
  List<Part> confirmedParts = [];
  List<PotentialPart> potentialParts = [];

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
        confirmedParts.add((
          partNumber: partNumber,
          gearPos: (lineIndex, characterIndex),
        ));
      }
      hasPrecedingStar = true;
    } else {
      // Dot
      if (numberBuffer.isNotEmpty) {
        int partNumber = int.parse(numberBuffer);
        if (hasPrecedingStar) {
          confirmedParts.add(
            (
              partNumber: partNumber,
              gearPos: (lineIndex, characterIndex - numberBuffer.length - 1),
            ),
          );
        } else {
          potentialParts.add((
            partNumber: partNumber,
            position: startingPoint,
            length: numberBuffer.length,
          ));
        }
        numberBuffer = '';
      }
      hasPrecedingStar = false;
    }
  }

  return (confirmedParts, potentialParts);
}

int solve(List<String> input) {
  input = input.map((line) => line += '.').toList();
  int lineLength = input.first.length;

  List<Part> allConfirmedParts = [];
  List<(int, List<PotentialPart>)> allPotentialParts = [];

  for (int lineIndex = 0; lineIndex < input.length; lineIndex++) {
    String line = input[lineIndex];

    final (confirmedParts, potentialParts) = parseLine(line, lineIndex);

    allConfirmedParts.addAll(confirmedParts);
    allPotentialParts.add((lineIndex, potentialParts));
  }

  for (final (int lineNumber, a) in allPotentialParts) {
    for (final PotentialPart(:partNumber, :position, :length) in a) {
      int xMin = [0, position - 1].max();
      int xMax = [lineLength, position + length + 1].min();

      for (int x = xMin; x < xMax; x++) {
        String? above = lineNumber > 0 ? input[lineNumber - 1][x] : null;
        String? below =
            lineNumber < input.length - 1 ? input[lineNumber + 1][x] : null;

        if (above != null && reStar.hasMatch(above)) {
          allConfirmedParts.add((
            partNumber: partNumber,
            gearPos: (lineNumber - 1, x),
          ));
        }
        if (below != null && reStar.hasMatch(below)) {
          allConfirmedParts.add((
            partNumber: partNumber,
            gearPos: (lineNumber + 1, x),
          ));
        }
      }
    }
  }

  return allConfirmedParts.map((Part part) {
        (int, int) gearCoordinates = part.gearPos;
        Iterable<Part> partsAroundGear =
            allConfirmedParts.where((part) => part.gearPos == gearCoordinates);

        if (partsAroundGear.length != 2) {
          return 0;
        }

        int first = partsAroundGear.first.partNumber;
        int last = partsAroundGear.last.partNumber;

        return first * last;
      }).sum() ~/
      2;
}
