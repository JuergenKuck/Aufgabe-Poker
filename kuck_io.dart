// Ansy-Codes für das Terminal
import 'dart:io';

String colorRedWhite = '\x1B[1;31;47m'; // rot auf weiß
String colorBlackWhite = '\x1B[1;30;47m'; // schwarz auf weiß
String colorBlackGreen = '\x1B[1;97;42m'; // Dunkel auf grün
String colorBlackRed = '\x1B[1;97;41m'; // weiß auf rot
String colorBlackYellow = '\x1B[1;30;43m'; // dunkel auf gelb

String colorEnd = '\x1B[0m';

void printHeader(String header) {
  // Cleart das Terminal und gib einen Text "header" aus
  // Mit Linien vor und nach dem header.
  clearTerminal();
  printLine();
  print(header);
  printLine();
}

void printLine() {
  // Gibt eine Linie aus
  print(
      '----------------------------------------------------------------------------');
}

bool jaNein(String header) {
  // Fragt nach <J>a oden <N>ein ab (groß oder klein spiel hierbe keine Rolle)

  print("$header <J>a oder <N>ein?");

  String answerStr = stdin.readLineSync() ?? 'J';
  bool answer;
  //print('');
  switch (answerStr) {
    case 'N' || 'n':
      answer = false;
    case 'J' || 'j':
    default:
      answer = true;
  }
  return answer;
}

void clearTerminal() {
  // ANSI-Escape-Sequenz zum Löschen des Bildschirms und Zurücksetzen des Cursors
  stdout.write('\ec \x1bc');
}
