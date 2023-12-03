import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Day 3: Gear Ratios ---
///
/// You and the Elf eventually reach a gondola lift station; he says the gondola
/// lift will take you up to the water source, but this is as far as he can
/// bring you. You go inside.
///
/// It doesn't take long to find the gondolas, but there seems to be a problem:
/// they're not moving.
///
/// "Aaah!"
///
/// You turn around to see a slightly-greasy Elf with a wrench and a look of
/// surprise. "Sorry, I wasn't expecting anyone! The gondola lift isn't working
/// right now; it'll still be a while before I can fix it." You offer to help.
///
/// The engineer explains that an engine part seems to be missing from the
/// engine, but nobody can figure out which one. If you can add up all the part
/// numbers in the engine schematic, it should be easy to work out which part is
/// missing.
///
/// The engine schematic (your puzzle input) consists of a visual representation
/// of the engine. There are lots of numbers and symbols you don't really
/// understand, but apparently any number adjacent to a symbol, even diagonally,
/// is a "part number" and should be included in your sum. (Periods (.) do not
/// count as a symbol.)
///
/// Here is an example engine schematic:
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
/// In this schematic, two numbers are not part numbers because they are not
/// adjacent to a symbol: 114 (top right) and 58 (middle right). Every other
/// number is adjacent to a symbol and so is a part number; their sum is 4361.
///
/// Of course, the actual engine schematic is much larger. What is the sum of
/// all of the part numbers in the engine schematic?
void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput = await Aoc.testInputStrings;

  assert(solve(testInput) == 4361);

  int answer = solve(puzzleInput);
  print(answer);
}

RegExp reDigit = RegExp(r'\d');
RegExp reSymbol = RegExp(r'[^.\d]');

typedef PotentialPart = ({
  int partNumber,
  int position,
  int length,
});

(List<int>, List<PotentialPart>) parseLine(String line) {
  List<int> confirmedParts = [];
  List<PotentialPart> potentialParts = [];

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
          potentialParts.add((
            partNumber: partNumber,
            position: startingPoint,
            length: numberBuffer.length,
          ));
        }
        numberBuffer = '';
      }
      hasPrecedingSymbol = false;
    }
  }

  return (confirmedParts, potentialParts);
}

int solve(List<String> input) {
  input = input.map((line) => line += '.').toList();
  int lineLength = input.first.length;

  List<int> allConfirmedParts = [];
  List<(int, List<PotentialPart>)> allPotentialParts = [];

  for (int lineIndex = 0; lineIndex < input.length; lineIndex++) {
    String line = input[lineIndex];

    final (confirmedParts, potentialParts) = parseLine(line);

    allConfirmedParts.addAll(confirmedParts);
    allPotentialParts.add((lineIndex, potentialParts));
  }

  for (final (int lineNumber, List<PotentialPart> a) in allPotentialParts) {
    for (final PotentialPart(:partNumber, :position, :length) in a) {
      int xMin = [0, position - 1].max();
      int xMax = [lineLength, position + length + 1].min();

      for (int x = xMin; x < xMax; x++) {
        String? above = lineNumber > 0 ? input[lineNumber - 1][x] : null;
        String? below =
            lineNumber < input.length - 1 ? input[lineNumber + 1][x] : null;

        if (above != null && reSymbol.hasMatch(above) ||
            below != null && reSymbol.hasMatch(below)) {
          allConfirmedParts.add(partNumber);
          break;
        }
      }
    }
  }

  return allConfirmedParts.sum();
}
