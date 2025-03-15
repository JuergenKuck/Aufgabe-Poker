import 'dart:io';
import 'dart:math';

List<String> suitSymbols = ['♦', '♥', '♠', '♣'];

String colorRedWhite = '\x1B[1;31;47m'; // rot auf weiß
String colorBlackWhite = '\x1B[1;30;47m'; // schwarz auf weiß
String colorBlackGreen = '\x1B[1;97;42m'; // Dunkel auf grün
String colorBlackRed = '\x1B[1;97;41m'; // weiß auf rot
String colorBlackYellow = '\x1B[1;30;43m'; // dunkel auf gelb

String colorEnd = '\x1B[0m';

int GetRandom(int nRandom) {
  Random random = Random();
  int result = random.nextInt(nRandom);
  return result;
}

void printHeader(String header) {
  clearTerminal();
  printLine();
  print(header);
  printLine();
}

void printLine() {
  print(
      '----------------------------------------------------------------------------');
}

void printWin(String text) {
  sleep(Duration(seconds: 1)); // Hält das Programm für 1 Sekunden an
  printLine();
  print('$colorBlackGreen Glückwunsch, Du hast gewonnen! $text $colorEnd');
  printLine();
}

void printLost(String text) {
  sleep(Duration(seconds: 1)); // Hält das Programm für 1 Sekunden an
  printLine();
  print('$colorBlackRed Schade, Du hast verloren! $text $colorEnd');
  printLine();
}

void printDraw() {
  sleep(Duration(seconds: 1)); // Hält das Programm für 1 Sekunden an
  printLine();
  print(
      '$colorBlackYellow Noch mal gutgegangen! Ihr habt unentschieden gespielt!$colorEnd');
  printLine();
}

void clearTerminal() {
  // ANSI-Escape-Sequenz zum Löschen des Bildschirms und Zurücksetzen des Cursors
  stdout.write('\x1B[2J\x1B[0;0H');
}
