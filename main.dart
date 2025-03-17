import 'kuck_io.dart';
import 'poker.dart';

void main() {
  clearTerminal();

  bool isGame = true;
  while (isGame) {
    isGame = gamePoker();
  }
}
