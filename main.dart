import 'blackjack.dart';
import 'global.dart';
import 'poker.dart';

void main() {
  clearTerminal();

  bool isGame = true;
  while (isGame) {
    isGame = gamePoker();
  }

  /* BlackJack:
  bool isGame = true;
  while (isGame) {
    isGame = blackjack();
  }
  */
}
