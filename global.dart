import 'dart:math';

// Enum, welches die Ergebnisse für ein Blatt(Hand wiedergibt)
enum PokerHand {
  RoyalFlash,
  StraightFlash,
  FourOfAKind,
  FullHouse,
  Flash,
  Straight,
  ThreeOfAKind,
  TwoPair,
  Pair,
  HeighCard,
  none
}

// Wertigkeit einer Pokerkarte
Map<String, int> rankMapPoker = {
  "2": 2,
  "3": 3,
  "4": 4,
  "5": 5,
  "6": 6,
  "7": 7,
  "8": 8,
  "9": 9,
  "10": 10,
  "J": 11,
  "Q": 12,
  "K": 13,
  "A": 14
};

// Spielfarben
List<String> suitSymbols = ['♦', '♥', '♠', '♣'];

int GetRandom(int nRandom) {
  // Gibt einen Zufallswert (0..nRandom-1) zurück
  Random random = Random();
  int result = random.nextInt(nRandom);
  return result;
}
