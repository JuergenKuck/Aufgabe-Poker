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
    switch (suit) {
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
  print('');
  print('$printCards0 ($pokerHand)');
  print(printCards1);
  print(printCards2);
  print('');
}

String getCards(List<String> hand) {
  //List<String> hand0 = ["J♥", "10♥", "Q♥", "K♥", "A♥"]; //Royal Flash
  //List<String> hand0 = ["9♥", "J♥", "10♥", "Q♥", "K♥"]; // Straight Flash
  //List<String> hand0 = ["5♠", "5♥", "5♦", "2♥", "5♣"]; // Four of a Kind
  //List<String> hand0 = ["2♠", "5♥", "5♦", "2♥", "5♣"]; // Full House
  //List<String> hand0 = ["10♠", "2♠", "J♠", "A♠", "8♠"]; // Four of a Kind
  //List<String> hand0 = ["A♠", "2♥", "3♠", "4♠", "5♠"]; // Straight
  //List<String> hand0 = ["5♠", "5♥", "5♦", "2♥", "8♣"]; // Three of a Kind
  //List<String> hand0 = ["2♠", "8♥", "5♦", "2♥", "5♣"]; // Two Pair
  //List<String> hand0 = ["2♠", "8♥", "A♦", "2♥", "5♣"]; // Pair
  List<String> hand0 = ["2♠", "8♥", "A♦", "7♥", "5♣"]; // Heigh Card
  for (int i = 0; i < 5; i++) {
    String rank = rankMapPoker.keys.elementAt(GetRandom(13));
    String suit = suitSymbols[GetRandom(4)];
    hand.add(hand0[i]);
  }
  return interpreteHand(hand);
  //String result = determineHandRank(cards);
}

String interpreteHand(List<String> hand) {
  List<int> values = [];
  List<String> suits = [];
  separate(hand, values, suits);
  if (isRoyalFlash(hand, values, suits)) return 'Royal Flash';
  if (isStraightFlash(hand, values, suits)) return 'Straight Flash';
  if (isFourOfAKind(hand, values, suits)) return 'Four of a Kind';
  if (isFullHouse(hand, values, suits)) return 'Full House';
  if (isFlash(hand, values, suits)) return 'Flash';
  if (isStraight(hand, values, suits)) return 'Straight';
  if (isThreeOfAKind(hand, values, suits)) return 'Three of a Kind';
  if (isTwoPair(hand, values, suits)) return 'Two Pair';
  if (isPair(hand, values, suits)) return 'Pair';
  if (isHeighCard(hand, values, suits)) return 'Heigh Card';
  return 'Fehler';
}

void separate(List<String> hand, List<int> values, List<String> suits) {
  values.clear();
  suits.clear();
  for (String card in hand) {
    String value = card.substring(0, card.length - 1); // Karte ohne Farbe
    String suit = card.substring(card.length - 1); // Farbe der Karte
    values
        .add(rankMapPoker[value]!); // Umwandlung des Kartenwertes in eine Zahl
    suits.add(suit);
  }
}

bool isRoyalFlash(List<String> hand, List<int> values, List<String> suits) {
  return isStraightFlash(hand, values, suits) && values.first == 10;
}

bool isStraightFlash(List<String> hand, List<int> values, List<String> suits) {
  bool _isFlash = isFlash(hand, values, suits);
  bool _isStraight = isStraight(hand, values, suits);
  return _isFlash && _isStraight;
}

bool isFourOfAKind(List<String> hand, List<int> values, List<String> suits) {
  handSort;
  List<int> counts = getCounts(hand, values, suits);
  return counts.contains(4);
}

bool isFullHouse(List<String> hand, List<int> values, List<String> suits) {
  handSort(hand, values, suits);
  List<int> counts = getCounts(hand, values, suits);
  return counts.contains(3) && counts.contains(2);
}

bool isFlash(List<String> hand, List<int> values, List<String> suits) {
  // Überprüfe, ob alle Karten die gleiche Farbe haben
  handSort(hand, values, suits);
  return suits.toSet().length == 1;
}

bool isStraight(List<String> hand, List<int> values, List<String> suits) {
  List<int> _values = [];
  List<String> _hand = [];
  for (int i = 0; i < values.length; i++) {
    _values.add(values[i]);
    _hand.add(hand[i]);
  }

  values.sort();
  bool isWheelStraight = values.equals([2, 3, 4, 5, 14]);
  bool _isStraight = values
      .asMap()
      .entries
      .every((e) => e.key == 0 || values[e.key] == values[e.key - 1] + 1);
  _isStraight = _isStraight || isWheelStraight;
  if (_isStraight) {
    hand.clear();
    for (int value in values) {
      for (int i = 0; i < values.length; i++) {
        if (_values[i] == value) {
          hand.add(_hand[i]);
        }
      }
    }
  }

  return _isStraight;
}

bool isThreeOfAKind(List<String> hand, List<int> values, List<String> suits) {
  handSort;
  List<int> counts = getCounts(hand, values, suits);
  return counts.contains(3);
}

bool isTwoPair(List<String> hand, List<int> values, List<String> suits) {
  handSort(hand, values, suits);
  List<int> counts = getCounts(hand, values, suits);
  int sum = 0;
  for (int count in counts) {
    if (count == 2) sum++;
  }
  return sum == 2;
}

bool isPair(List<String> hand, List<int> values, List<String> suits) {
  handSort(hand, values, suits);
  List<int> counts = getCounts(hand, values, suits);
  return counts.contains(2);
}

bool isHeighCard(List<String> hand, List<int> values, List<String> suits) {
  handSort(hand, values, suits);
  List<int> counts = getCounts(hand, values, suits);
  int sum = 0;
  for (int count in counts) {
    if (count == 1) sum++;
  }
  return sum == 5;
}

List<int> getCounts(List<String> hand, List<int> values, List<String> suits) {
  Map<int, int> valueCounts = values.fold(<int, int>{}, (map, value) {
    map[value] = (map[value] ?? 0) + 1;
    return map;
  });
  List<int> _values = [];
  List<String> _hand = [];
  for (int i = 0; i < values.length; i++) {
    _values.add(values[i]);
    _hand.add(hand[i]);
  }
  hand.clear();
  for (int i = 0; i < valueCounts.keys.length; i++) {
    int value = valueCounts.keys.elementAt(i);
    int number = valueCounts.values.elementAt(i);
    print('$value $number');
    for (int k = 0; k < number; k++) {
      for (int l = 0; l < _hand.length; l++) {
        if (_values[l] == value) {
          hand.add(_hand[l]);
          _values[l] = 0;
        }
      }
    }
  }

  List<int> counts = valueCounts.values.toList()..sort((a, b) => b - a);
  return counts;
}

void handSort(List<String> hand, List<int> values, List<String> suits) {
  List<int> _values = [];
  List<String> _hand = [];
  for (int i = 0; i < values.length; i++) {
    _values.add(values[i]);
    _hand.add(hand[i]);
  }
  values.sort();
  hand.clear();
  for (int value in values) {
    for (int i = 0; i < values.length; i++) {
      if (_values[i] == value) {
        hand.add(_hand[i]);
        _values[i] = 0;
      }
    }
  }
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
