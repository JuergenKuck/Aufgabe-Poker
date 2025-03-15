import 'global.dart';

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

void gamePoker() {
  // testDetrmineHandRank();
  List<String> cards = [];
  String pokerHand = getCards(cards);
  printCardsCurrent('Spieler', cards, pokerHand);
/*
  // Spieler Karten
  List<String> playerCards = [];

  // Bank: Kommentare analog Spieler
  List<String> bankCards = [];
  cardsPoker(playerCards);
  */
}

void printCardsCurrent(String actor, List<String> cards, String pokerHand) {
  String actor1 = actor.length < 7 ? actor + '   ' : actor;
  String printCards0 = "$actor1: ";
  String printCards1 = '         ';
  String printCards2 = '         ';
  String color = '';
  for (int i = 0; i < cards.length; i++) {
    String rank;
    String suit;
    if (cards[i].length == 2) {
      rank = cards[i][0];
      suit = cards[i][1];
    } else {
      rank = cards[i][0] + cards[i][1];
      suit = cards[i][2];
    }
    switch (cards[i][1]) {
      case '♦' || '♥':
        color = '\x1B[31;47m'; // rot auf weiß
      case '♠' || '♣':
        color = '\x1B[30;47m'; // schwarz auf weiß
    }

    // printCards += ' ${suits[i]} ${cards[i]} \x1B[0m';

    if (rank.length == 1) rank += ' ';
    printCards0 += '$color ${suit} ${suit} $colorEnd ';
    printCards1 += '$color  ${rank} $colorEnd ';
    printCards2 += '$color ${suit} ${suit} $colorEnd ';
  }
  print('$printCards0 ($pokerHand)');
  print(printCards1);
  print(printCards2);
}

String getCards(List<String> cards) {
  for (int i = 0; i < 5; i++) {
    String rank = rankMapPoker.keys.elementAt(GetRandom(13));
    String suit = suitSymbols[GetRandom(4)];
    cards.add(rank + suit);
  }
  String result = determineHandRank(cards);
  return result;
}

String determineHandRank(List<String> hand) {
  // Diese Routine habe ich von CHatGPT generieren lassen, aber mit
  // den Tests überprüft!!!!

  List<int> values = [];
  List<String> suits = [];

  for (String card in hand) {
    String value = card.substring(0, card.length - 1); // Karte ohne Farbe
    String suit = card.substring(card.length - 1); // Farbe der Karte
    values
        .add(rankMapPoker[value]!); // Umwandlung des Kartenwertes in eine Zahl
    suits.add(suit);
  }

  values.sort(); // Sortiere die Werte in aufsteigender Reihenfolge

  bool isFlush = suits.toSet().length ==
      1; // Überprüfe, ob alle Karten die gleiche Farbe haben

  // Prüfen, ob die Karten eine normale Straße bilden
  bool isStraight = values
      .asMap()
      .entries
      .every((e) => e.key == 0 || values[e.key] == values[e.key - 1] + 1);

  // Prüfen, ob A-2-3-4-5 eine gültige Straße ist (Wheel-Straight)
  bool isWheelStraight = values.equals([2, 3, 4, 5, 14]);

  var valueCounts = values.fold(<int, int>{}, (map, value) {
    map[value] = (map[value] ?? 0) + 1;
    return map;
  });

  List<int> counts = valueCounts.values.toList()..sort((a, b) => b - a);

  if (isFlush && isStraight && values.last == 14) return "Royal Flush";
  if (isFlush && (isStraight || isWheelStraight)) return "Straight Flush";
  if (counts.contains(4)) return "Four of a Kind";
  if (counts.contains(3) && counts.contains(2)) return "Full House";
  if (isFlush) return "Flush";
  if (isStraight || isWheelStraight) return "Straight";
  if (counts.contains(3)) return "Three of a Kind";
  if (counts.where((c) => c == 2).length == 2) return "Two Pair";
  if (counts.contains(2)) return "One Pair";

  return "High Card (${values.last})";
}

extension on List<int> {
  bool equals(List<int> list) {
    if (length != list.length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != list[i]) return false;
    }
    return true;
  }
}

void testDetrmineHandRank() {
  List<List<String>> inputLists = [];
  List<String> requiredList = [];

  String outputString;

  inputLists.add(["J♥", "10♥", "Q♥", "K♥", "A♥"]);
  requiredList.add("Royal Flush");

  inputLists.add(["5♦", "3♦", "2♦", "4♦", "A♦"]);
  requiredList.add("Straight Flush");

  inputLists.add(["10♥", "J♥", "Q♥", "K♥", "A♥"]);
  requiredList.add("Royal Flush");

  inputLists.add(["9♦", "10♦", "J♦", "Q♦", "K♦"]);
  requiredList.add("Straight Flush");

  inputLists.add(["5♠", "5♥", "5♦", "5♣", "9♥"]);
  requiredList.add("Four of a Kind");

  inputLists.add(["3♣", "3♦", "3♥", "7♠", "7♥"]);
  requiredList.add("Full House");

  inputLists.add(["2♥", "4♥", "6♥", "8♥", "K♥"]);
  requiredList.add("Flush");

  inputLists.add(["4♣", "5♦", "6♠", "7♥", "8♥"]);
  requiredList.add("Straight");

  inputLists.add(["9♣", "9♦", "9♥", "5♠", "2♦"]);
  requiredList.add("Three of a Kind");

  inputLists.add(["8♣", "8♦", "4♠", "4♥", "2♥"]);
  requiredList.add("Two Pair");

  inputLists.add(["10♣", "10♦", "3♠", "7♥", "4♥"]);
  requiredList.add("One Pair");

  inputLists.add(["K♠", "J♦", "7♣", "5♠", "2♥"]);
  requiredList.add("High Card (13)");

  for (int i = 0; i < inputLists.length; i++) {
    String result = determineHandRank(inputLists[i]);
    String ok = result == requiredList[i] ? "OK" : "Fehler";
    print('${inputLists[i]} => $result $ok');
  }
}
