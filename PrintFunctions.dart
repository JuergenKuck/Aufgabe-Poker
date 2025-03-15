import 'dart:io';

import 'global.dart';

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
