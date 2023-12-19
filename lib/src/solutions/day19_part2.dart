import 'package:advent_of_code_2023/advent_of_code_2023.dart';

/// --- Part Two ---
///
/// Even with your help, the sorting process still isn't fast enough.
///
/// One of the Elves comes up with a new plan: rather than sort parts
/// individually through all of these workflows, maybe you can figure out in
/// advance which combinations of ratings will be accepted or rejected.
///
/// Each of the four ratings (x, m, a, s) can have an integer value ranging from
/// a minimum of 1 to a maximum of 4000. Of all possible distinct combinations
/// of ratings, your job is to figure out which ones will be accepted.
///
/// In the above example, there are 167409079868000 distinct combinations of
/// ratings that will be accepted.
///
/// Consider only your list of workflows; the list of part ratings that the
/// Elves wanted you to sort is no longer relevant. How many distinct
/// combinations of ratings will be accepted by the Elves' workflows?
void main() async {
  String puzzleInput = await Aoc.puzzleInputString;
  String testInput = await Aoc.testInputString;

  assert(solve(testInput) == 167409079868000);

  int answer = solve(puzzleInput);
  print(answer);
}

int solve(String input) {
  Iterable<Workflow> workflows =
      input.split('\n\n').first.split('\n').map(Workflow.parse);
  Condition condition = workflows.firstWhere((w) => w.name == 'in').condition;
  MachinePartRange range = MachinePartRange(
    (1, 4000),
    (1, 4000),
    (1, 4000),
    (1, 4000),
  );

  return dfs(
    range,
    condition,
    workflows,
  );
}

int dfs(
  MachinePartRange range,
  Statement statement,
  Iterable<Workflow> workflows,
) {
  if (statement is AcceptingStatement) {
    return range.options;
  }
  if (statement is Condition) {
    (MachinePartRange, MachinePartRange) ranges = range.splitAt(
      statement.value,
      statement.operator,
      statement.property,
    );
    return dfs(ranges.$1, statement.a, workflows) +
        dfs(ranges.$2, statement.b, workflows);
  }
  if (statement is MovingStatement) {
    return dfs(
      range,
      workflows.firstWhere((w) => w.name == statement.name).condition,
      workflows,
    );
  }
  return 0;
}

class MachinePartRange {
  const MachinePartRange(
    this.xs,
    this.ms,
    this.as,
    this.ss,
  );

  final (int, int) xs;
  final (int, int) ms;
  final (int, int) as;
  final (int, int) ss;

  (MachinePartRange, MachinePartRange) splitAt(
    int i,
    String operation,
    String property,
  ) {
    return switch (property) {
      'x' => splitAtX(i, operation),
      'm' => splitAtM(i, operation),
      'a' => splitAtA(i, operation),
      _ => splitAtS(i, operation),
    };
  }

  (MachinePartRange, MachinePartRange) splitAtX(int x, String operation) {
    if (operation == '<') {
      return (
        MachinePartRange((xs.$1, x - 1), ms, as, ss),
        MachinePartRange((x, xs.$2), ms, as, ss),
      );
    } else {
      return (
        MachinePartRange((x + 1, xs.$2), ms, as, ss),
        MachinePartRange((xs.$1, x), ms, as, ss),
      );
    }
  }

  (MachinePartRange, MachinePartRange) splitAtM(int m, String operation) {
    if (operation == '<') {
      return (
        MachinePartRange(xs, (ms.$1, m - 1), as, ss),
        MachinePartRange(xs, (m, ms.$2), as, ss),
      );
    } else {
      return (
        MachinePartRange(xs, (m + 1, ms.$2), as, ss),
        MachinePartRange(xs, (ms.$1, m), as, ss),
      );
    }
  }

  (MachinePartRange, MachinePartRange) splitAtA(int a, String operation) {
    if (operation == '<') {
      return (
        MachinePartRange(xs, ms, (as.$1, a - 1), ss),
        MachinePartRange(xs, ms, (a, as.$2), ss),
      );
    } else {
      return (
        MachinePartRange(xs, ms, (a + 1, as.$2), ss),
        MachinePartRange(xs, ms, (as.$1, a), ss),
      );
    }
  }

  (MachinePartRange, MachinePartRange) splitAtS(int s, String operation) {
    if (operation == '<') {
      return (
        MachinePartRange(xs, ms, as, (ss.$1, s - 1)),
        MachinePartRange(xs, ms, as, (s, ss.$2)),
      );
    } else {
      return (
        MachinePartRange(xs, ms, as, (s + 1, ss.$2)),
        MachinePartRange(xs, ms, as, (ss.$1, s)),
      );
    }
  }

  int get options => [
        (xs.$2 - xs.$1 + 1),
        (ms.$2 - ms.$1 + 1),
        (as.$2 - as.$1 + 1),
        (ss.$2 - ss.$1 + 1),
      ].product();
}

class Workflow {
  const Workflow(
    this.name,
    this.condition,
  );

  factory Workflow.parse(String instruction) {
    return Workflow(
      instruction.split('{').first,
      Condition.parse(instruction.split('{').second),
    );
  }

  final String name;
  final Condition condition;
}

abstract class Statement {
  factory Statement.parse(String instruction) {
    instruction = instruction.split('}').first;

    if (instruction == 'A') {
      return AcceptingStatement();
    } else if (instruction == 'R') {
      return RejectingStatement();
    } else if (!instruction.contains('>') && !instruction.contains('<')) {
      return MovingStatement(instruction);
    } else {
      return Condition.parse(instruction);
    }
  }
}

class Condition implements Statement {
  const Condition(
    this.property,
    this.operator,
    this.value,
    this.a,
    this.b,
  );

  factory Condition.parse(String instruction) {
    String property = instruction.first;
    String operator = instruction.second;
    int value = int.parse(instruction.skip(2).split(':').first);
    String sa = instruction.split(':').second.split(',').first;
    int commaIndex = instruction.indexOf(',');
    String sb = instruction.skip(commaIndex + 1);
    Statement a = Statement.parse(sa);
    Statement b = Statement.parse(sb);

    return Condition(
      property,
      operator,
      value,
      a,
      b,
    );
  }

  final String property;
  final String operator;
  final int value;
  final Statement a;
  final Statement b;
}

class MovingStatement implements Statement {
  const MovingStatement(this.name);

  final String name;
}

class AcceptingStatement implements Statement {}

class RejectingStatement implements Statement {}
