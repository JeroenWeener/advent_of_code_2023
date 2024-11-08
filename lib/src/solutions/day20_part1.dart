import 'dart:collection';

import 'package:advent_of_code_2023/advent_of_code_2023.dart';

void main() async {
  List<String> puzzleInput = await Aoc.puzzleInputStrings;
  List<String> testInput =
      await Aoc.testInputStrings; // Manually tweaked the test input.
  List<String> altTestInput =
      await Aoc.testInputStringsAlt; // Manually tweaked the test input.

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(List<String> input) {
  List<Module> modules = input.map((e) {
    List<String> outputs = e.split('-> ').second.split(', ');
    if (e.first == '%') {
      return FlipFlop(
        e.skip(1).take(2),
        outputs,
      );
    } else if (e.first == '&') {
      String name = e.skip(1).take(2);
      return Conjunction(
        name,
        input
            .where((element) => element.split('->').second.contains(name))
            .length,
        outputs,
      );
    } else {
      return Broadcaster(outputs);
    }
  }).toList();

  /// Bereken nieuwe state maar een keer.
  /// Let op wanneer de state van een Conjunction moet worden berekent
  /// Figure out waar de pulses het beste geteld kunnen worden
  /// Misschien dat huidige impl al werkt hoor, ff debuggen

  int highPulsesCounter = 0;
  int lowPulsesCounter = 0;

  Queue<(Module, bool)> q = Queue();
  for (var i = 0; i < 1000; i++) {
    Module button = ButtonModule();
    q.add((button, false));
    while (q.isNotEmpty) {
      final (Module module, bool pulse) = q.removeFirst();
      for (var nextModuleName in module.outputs) {
        if (pulse) {
          highPulsesCounter++;
        } else {
          lowPulsesCounter++;
        }
        Module? nextModule =
            modules.firstWhereOrNull((m) => m.name == nextModuleName);
        bool? nextPulse;
        if (nextModule is FlipFlop) {
          nextPulse = nextModule.propagate(pulse);
        } else if (nextModule is Conjunction) {
          nextPulse = nextModule.propagate(module.name, pulse);
        } else if (nextModule is Broadcaster) {
          nextPulse = pulse;
        }
        print('${module.name} -${pulse ? 'high' : 'low'}-> $nextModuleName');
        if (nextPulse != null) {
          q.add((nextModule!, nextPulse));
        }
      }
    }
  }

  print('$highPulsesCounter * $lowPulsesCounter');
  return highPulsesCounter * lowPulsesCounter;
}

abstract class Module {
  Module(this.name, this.outputs);

  final String name;
  final List<String> outputs;
}

class ButtonModule extends Module {
  ButtonModule() : super('button', ['broadcaster']);
}

class Broadcaster extends Module {
  Broadcaster(List<String> outputs) : super('broadcaster', outputs);

  @override
  String toString() {
    return 'Broadcaster -> $outputs';
  }
}

class FlipFlop extends Module {
  FlipFlop(super.name, super.outputs);
  bool state = false;
  bool? propagate(bool pulse) {
    if (!pulse) {
      state = !state;
      return state;
    }
    return null;
  }

  @override
  String toString() {
    return '%$name: $state -> $outputs';
  }
}

class Conjunction extends Module {
  Conjunction(super.name, this.numberOfInputs, super.outputs);

  final int numberOfInputs;
  final Map<String, bool> inputs = {};

  /// What if an input outputs multiple times? Counting will go wrong.
  /// We gotta see if this actually happens.
  bool? propagate(String input, bool pulse) {
    inputs[input] = pulse;
    return inputs.length != numberOfInputs ||
        !inputs.values.every((element) => element);
  }

  @override
  String toString() {
    return '&$name: ${inputs.values} out of $numberOfInputs -> $outputs';
  }
}
