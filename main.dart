import 'kuck_io.dart';
import 'poker.dart';

void main() {
  clearTerminal();

  bool isGame = true;

  //Erstellen eines Standard-Pokerdecks (52 Karten)
  generateDeck();
  while (isGame) {
    isGame = gamePoker();
  }
}
