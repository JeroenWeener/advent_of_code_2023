import 'dart:convert';
import 'dart:io';

import 'package:advent_of_code_2023/src/utils.dart';

class Aoc {
  static int year = 2023;
  static final int day = getDayInt();
  static final String _dayString = day.toString().padLeft(2, '0');
  static final String _sessionId = getSessionId();
  static final String _puzzleInputFileName =
      'puzzle_inputs/$_dayString/input.txt';
  static final String _puzzleTestInputFileName =
      'puzzle_inputs/$_dayString/test_input.txt';
  static final String _puzzleTestAltInputFileName =
      'puzzle_inputs/$_dayString/test_input_alt.txt';

  static Future<List<String>> get puzzleInput async {
    final File inputFile = File(_puzzleInputFileName);

    if (!inputFile.existsSync()) {
      await _downloadPuzzleInput();
    }
    if (inputFile
        .readAsStringSync()
        .startsWith('Puzzle inputs differ by user.')) {
      await _downloadPuzzleInput();
    }
    return _getCachedPuzzleInput();
  }

  static Future<List<String>> get puzzleInputStrings => puzzleInput;

  static Future<String> get puzzleInputString async =>
      (await puzzleInputStrings).first;

  static Future<List<int>> get puzzleInputInts async =>
      (await puzzleInputStrings).map(int.parse).toList();

  static Future<List<String>> _testInput(String filePath) async {
    final File inputFile = File(filePath);

    if (!inputFile.existsSync()) {
      final bool success = await _downloadTestInput(filePath);
      if (!success) {
        throw Exception('Could not download test input.');
      }
    }
    return _getCachedTestInput(filePath);
  }

  static Future<List<String>> get testInput async =>
      _testInput(_puzzleTestInputFileName);
  static Future<List<String>> get testInputStrings => testInput;
  static Future<String> get testInputString async =>
      (await testInputStrings).first;

  static Future<List<int>> get testInputInts async =>
      (await testInputStrings).map(int.parse).toList();

  static Future<List<String>> get testInputAlt async =>
      _testInput(_puzzleTestAltInputFileName);
  static Future<List<String>> get testInputStringsAlt => testInputAlt;
  static Future<String> get testInputStringAlt async =>
      (await testInputStringsAlt).first;
  static Future<List<int>> get testInputIntsAlt async =>
      (await testInputStringsAlt).map(int.parse).toList();

  static Future<void> upload1(Object solution) {
    return _upload(solution, 1);
  }

  static Future<void> upload2(Object solution) {
    return _upload(solution, 2);
  }

  static Future<void> _upload(Object solution, int level) async {
    assert(solution.runtimeType == int || solution.runtimeType == String);

    final String url = 'https://adventofcode.com/$year/day/$day/answer';
    final HttpClient client = HttpClient();
    final HttpClientRequest request = await client.postUrl(Uri.parse(url));
    request.cookies.add(Cookie('session', _sessionId));
    request.headers.add('Content-Type', 'application/x-www-form-urlencoded');
    request.write('level=$level&answer=${solution.toString()}');
    final HttpClientResponse response = await request.close();
    final String html = await response.transform(utf8.decoder).join();
    client.close();

    if (html.contains('your answer is too high')) {
      print(highlight('Your answer is too high.', HighlightColor.red));
    } else if (html.contains('That\'s the right answer!')) {
      print(highlight('That\'s the right answer!', HighlightColor.green));
    } else {
      print(highlight('That\'s not the right answer.', HighlightColor.red));
    }
  }

  static Future<bool> _downloadTestInput(String filePath) async {
    final String url = 'https://adventofcode.com/$year/day/$day';
    final HttpClient client = HttpClient();
    final HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.cookies.add(Cookie('session', _sessionId));
    final HttpClientResponse response = await request.close();
    final String html = await response.transform(utf8.decoder).join();
    try {
      final String testInput = html
          .split('example')[1]
          .split('<pre><code>')[1]
          .split('</code></pre>')[0]
          .replaceAll('<em>', '')
          .replaceAll('</em>', '')
          .replaceAll('&lt;', '<')
          .replaceAll('&gt;', '>');
      final File file = File(filePath);
      file.createSync(recursive: true);
      file.writeAsStringSync(testInput);
    } on Error {
      print(highlight('Error parsing test input.', HighlightColor.red));
      client.close();
      return false;
    } finally {
      client.close();
    }
    return true;
  }

  static List<String> _getCachedTestInput(String filePath) {
    return File(filePath).readAsLinesSync();
  }

  static Future<void> _downloadPuzzleInput() async {
    final String url = 'https://adventofcode.com/$year/day/$day/input';
    final HttpClient client = HttpClient();
    final HttpClientRequest request = await client.getUrl(Uri.parse(url));
    request.cookies.add(Cookie('session', _sessionId));
    final HttpClientResponse response = await request.close();
    final File file = File(_puzzleInputFileName);
    file.createSync(recursive: true);
    await response.pipe(file.openWrite());
    client.close();
  }

  static List<String> _getCachedPuzzleInput() {
    return File(_puzzleInputFileName).readAsLinesSync();
  }
}
