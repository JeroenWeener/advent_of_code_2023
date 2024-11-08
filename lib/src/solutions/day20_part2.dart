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

  Module moduleToEnd =
      modules.firstWhere((element) => element.outputs.contains('rx'));
  Module broadcaster = modules.firstWhere((e) => e is Broadcaster);
  List<Module> startingModules = broadcaster.outputs
      .map((e) => modules.firstWhere((element) => element.name == e))
      .toList();

  List<Module> endModules = startingModules.map((e) {
    return findEnd(e, moduleToEnd.name, modules, {})!;
  }).toList();

  /// Vind startpunten
  /// Vind eindpunten
  /// Bereken de lengte van een cycle
  /// Pak de lcm van de cycles

  Iterable<int> pressesPerCycle = startingModules.zip(endModules).map((e) {
    final (startingModule, endingModule) = e;
    Set<Module> selectedModules =
        selectModules(startingModule, endingModule, modules);
    print(selectedModules.map((e) => e.name));
    Broadcaster bc = Broadcaster([startingModule.name]);
    return press(bc, endingModule, selectedModules);
  });
  return pressesPerCycle.lcm();
}

Set<Module> selectModules(
  Module currentModule,
  Module endingModule,
  Iterable<Module> modules,
) {
  if (currentModule == endingModule) return {};
  return {
    currentModule,
    ...modules
        .where((e) => currentModule.outputs.contains(e.name))
        .map((e) => selectModules(
            e, endingModule, modules.where((e) => e != currentModule)))
        .map((e) => e.toSet())
        .toSet()
        .flatten()
        .toSet()
  };
}

int press(
  Module startModule,
  Module endModule,
  Set<Module> modules,
) {
  Queue<(Module, bool)> q = Queue();
  int presses = 0;
  while (true) {
    presses++;
    q.add((startModule, false));
    while (q.isNotEmpty) {
      final (Module module, bool pulse) = q.removeFirst();
      // print(module.outputs);
      for (String nextModuleName in module.outputs) {
        if (nextModuleName == endModule.name && pulse) {
          if (modules.every(moduleIsInitial)) {
            print(modules);
            return presses;
          }
        }
        Module? nextModule = modules
            .firstWhereOrNull((element) => element.name == nextModuleName);
        // print(nextModule?.name);
        bool? nextPulse;
        if (nextModule is FlipFlop) {
          nextPulse = nextModule.propagate(pulse);
        } else if (nextModule is Conjunction) {
          nextPulse = nextModule.propagate(module.name, pulse);
        } else if (nextModule is Broadcaster) {
          nextPulse = pulse;
        }

        if (nextPulse != null) {
          q.add((nextModule!, nextPulse));
        }
      }
    }
  }
}

bool moduleIsInitial(Module m) {
  if (m is FlipFlop) {
    return !m.state;
  } else if (m is Conjunction) {
    return m.inputs.length == m.numberOfInputs &&
        m.inputs.values.every((element) => !element);
  }
  throw Exception();
}

Module? findEnd(
  Module m,
  String moduleToEnd,
  List<Module> modules,
  Set<String> visitedModules,
) {
  for (String m2
      in m.outputs.where((element) => !visitedModules.contains(element))) {
    if (m2 == moduleToEnd) {
      return m;
    }
    if (m2 == 'rx') {
      return null;
    }
    Module module2 = modules.firstWhere((m3) => m3.name == m2);
    Module? found =
        findEnd(module2, moduleToEnd, modules, visitedModules..add(m.name));
    if (found != null) {
      return found;
    }
  }
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
