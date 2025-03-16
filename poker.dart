import 'dart:developer';
import 'dart:math';

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
  //test();
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

void test() {
  clearTerminal();

  List<String> hand = ["K♠", "K♦", "7♣", "5♠", "2♥"]; // Beispiel: One Pair
  printCardsCurrent('Spieler', hand, '');

  List<String> newHand = exchangeCards(hand);
  printCardsCurrent('Nachher', newHand, '');
}

String getCards(List<String> hand) {
  //List<String> hand0 = ["J♥", "10♥", "Q♥", "K♥", "A♥"]; //Royal Flash
  //List<String> hand0 = ["9♥", "J♥", "10♥", "Q♥", "K♥"]; // Straight Flash
  //List<String> hand0 = ["8♠", "8♥", "5♦", "8♥", "8♣"]; // Four of a Kind
  //List<String> hand0 = ["2♠", "5♥", "5♦", "2♥", "5♣"]; // Full House
  //List<String> hand0 = ["2♥", "A♠", "3♠", "4♠", "5♠"]; // Straight
  //List<String> hand0 = ["2♠", "2♥", "5♦", "2♥", "8♣"]; // Three of a Kind
  //List<String> hand0 = ["2♠", "4♥", "5♦", "2♥", "5♣"]; // Two Pair
  //List<String> hand0 = ["8♠", "2♥", "A♦", "8♥", "5♣"]; // Pair
  List<String> hand0 = ["2♠", "8♥", "A♦", "7♥", "5♣"]; // Heigh Card
  for (int i = 0; i < 5; i++) {
    String rank = rankMapPoker.keys.elementAt(GetRandom(13));
    String suit = suitSymbols[GetRandom(4)];
    hand.add(hand0[i]);
  }
  sortHand(hand);
  return interpreteHand(hand);
  //String result = determineHandRank(cards);
}

String interpreteHand(List<String> hand) {
  if (isRoyalFlash(hand)) return 'Royal Flash';
  if (isStraightFlash(hand)) return 'Straight Flash';
  if (isFourOfAKind(hand)) return 'Four of a Kind';
  if (isFullHouse(hand)) return 'Full House';
  if (isFlash(hand)) return 'Flash';
  if (isStraight(hand)) return 'Straight';
  if (isThreeOfAKind(hand)) return 'Three of a Kind';
  if (isTwoPair(hand)) return 'Two Pair';
  if (isPair(hand)) return 'Pair';
  if (isHeighCard(hand)) return 'Heigh Card';
  return 'Fehler';
}

void sortHand(List<String> hand) {
  List<int> values = [];
  List<String> suits = [];
  separate(hand, values, suits);

  List<int> _values = [];
  List<String> _hand = [];
  for (int i = 0; i < values.length; i++) {
    _values.add(values[i]);
    _hand.add(hand[i]);
  }

  _values.sort();
  if (_values.equals([2, 3, 4, 5, 14])) _values = [14, 2, 3, 4, 5];

  hand.clear();
  for (int i = 0; i < _values.length; i++) {
    int _value = _values[i];
    for (int k = 0; k < values.length; k++) {
      if (_value == values[k]) {
        hand.add(_hand[k]);
        values[k] = 0;
      }
    }
  }
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

List<String> getSuits(List<String> hand) {
  List<String> suits = [];
  for (String card in hand) {
    String suit = card.substring(card.length - 1); // Farbe der Karte
    suits.add(suit);
  }
  return suits;
}

List<int> getValues(List<String> hand) {
  List<int> values = [];
  for (String card in hand) {
    String value = card.substring(0, card.length - 1); // Karte ohne Farbe
    values
        .add(rankMapPoker[value]!); // Umwandlung des Kartenwertes in eine Zahl
  }
  return values;
}

bool isRoyalFlash(List<String> hand) {
  bool result = isStraightFlash(hand) && getValues(hand).first == 10;
  return result;
}

bool isStraightFlash(List<String> hand) {
  bool _isFlash = isFlash(hand);
  bool _isStraight = isStraight(hand);
  return _isFlash && _isStraight;
}

bool isFourOfAKind(List<String> hand) {
  List<int> counts = getCounts(hand);
  bool result = counts.contains(4);
  if (result && counts[0] == 4) {
    List<String> _hand = hand.clone();
    hand.clear();
    hand.add(_hand[4]);
    for (int i = 0; i < _hand.length - 1; i++) {
      hand.add(_hand[i]);
    }
  }
  return result;
}

bool isFullHouse(List<String> hand) {
  List<int> counts = getCounts(hand);
  bool result = counts.contains(3) && counts.contains(2);

  if (result && counts[0] == 3) {
    List<String> _hand = hand.clone();
    hand.clear();
    hand.add(_hand[3]);
    hand.add(_hand[4]);
    for (int i = 0; i < _hand.length - 2; i++) {
      hand.add(_hand[i]);
    }
  }
  return result;
}

bool isFlash(List<String> hand) {
  // Überprüfe, ob alle Karten die gleiche Farbe haben
  return getSuits(hand).toSet().length == 1;
}

bool isStraight(List<String> hand) {
  List<int> values = getValues(hand);
  bool _isStraight = false;
  bool isWheelStraight = values.equals([14, 2, 3, 4, 5]);
  if (!isWheelStraight) {
    _isStraight = true;
    for (int i = 1; i < values.length; i++) {
      if (values[i] != values[i - 1] + 1) {
        _isStraight = false;
        break;
      }
    }
  }

  return _isStraight || isWheelStraight;
}

bool isThreeOfAKind(List<String> hand) {
  List<int> counts = getCounts(hand);
  bool result = counts.contains(3);

  if (result && counts[0] == 3) {
    List<String> _hand = hand.clone();
    hand.clear();
    hand.add(_hand[3]);
    hand.add(_hand[4]);
    for (int i = 0; i < _hand.length - 2; i++) {
      hand.add(_hand[i]);
    }
  }
  return result;
}

bool isTwoPair(List<String> hand) {
  List<int> values = getValues(hand);
  List<int> counts = getCounts(hand);
  int sum = 0;
  for (int count in counts) {
    if (count == 2) sum++;
  }
  bool result = sum == 2;

  if (result) {
    List<int> i2 = [];
    int i1 = 0;
    for (int i = 0; i < counts.length; i++) {
      if (counts[i] == 1) i1 = i;
      if (counts[i] == 2) i2.add(i);
    }
    int i20 = 1;
    int i21 = 3;
    if (i1 == 1) {
      i20 = 0;
      i1 = 2;
      i21 = 3;
    } else if (i1 == 2) {
      i20 = 0;
      i21 = 2;
      i1 = 4;
    }

    if (values[i20] > values[i21]) {
      int ib = i21;
      i21 = i20;
      i20 = ib;
    }

    List<String> _hand = hand.clone();
    hand[0] = _hand[i1];
    hand[1] = _hand[i20];
    hand[2] = _hand[i20 + 1];
    hand[3] = _hand[i21];
    hand[4] = _hand[i21 + 1];
  }
  return result;
}

bool isPair(List<String> hand) {
  List<int> counts = getCounts(hand);
  bool result = counts.contains(2);

  if (result) {
    List<String> _hand = hand.clone();

    int i = 0;
    int k = 0;
    int p2 = 0;
    while (k < counts.length) {
      if (counts[i] == 2) {
        p2 = k;
        k += 2;
      }
      hand[i] = _hand[k];
      i++;
      k++;
    }
    hand[3] = _hand[p2];
    hand[4] = _hand[p2 + 1];
  }
  return result;
}

bool isHeighCard(List<String> hand) {
  List<int> counts = getCounts(hand);
  int sum = 0;
  for (int count in counts) {
    if (count == 1) sum++;
  }
  return sum == 5;
}

List<int> getCounts(List<String> hand) {
  List<int> values = getValues(hand);
  Map<int, int> valueCounts = values.fold(<int, int>{}, (map, value) {
    map[value] = (map[value] ?? 0) + 1;
    return map;
  });
  List<int> counts = valueCounts.values.toList();
  return counts;
}

List<String> exchangeCards(List<String> hand) {
  List<int> values = [];
  List<String> suits = [];
  List<String> cardSymbols = [];

  // Kartenwerte umwandeln

  for (String card in hand) {
    String value = card.substring(0, card.length - 1);
    String suit = card.substring(card.length - 1);
    values.add(rankMapPoker[value]!);
    suits.add(suit);
    cardSymbols.add(value);
  }

  values.sort();

  // Hand-Ranking berechnen
  Map<int, int> valueCounts = {};
  for (int value in values) {
    valueCounts[value] = (valueCounts[value] ?? 0) + 1;
  }

  List<int> counts = valueCounts.values.toList()..sort((a, b) => b - a);
  List<int> uniqueValues = valueCounts.keys.toList();

  // Entscheiden, welche Karten getauscht werden sollen
  List<bool> keepCard = List.filled(5, false);

  if (counts.contains(4)) {
    // Four of a Kind → 1 Karte tauschen
    keepCard = values.map((v) => valueCounts[v] == 4).toList();
  } else if (counts.contains(3) && counts.contains(2)) {
    // Full House → nichts tauschen
    keepCard = List.filled(5, true);
  } else if (counts.contains(3)) {
    // Three of a Kind → 2 Karten tauschen
    keepCard = values.map((v) => valueCounts[v] == 3).toList();
  } else if (counts.where((c) => c == 2).length == 2) {
    // Two Pair → 1 Karte tauschen
    keepCard = values.map((v) => valueCounts[v]! >= 2).toList();
  } else if (counts.contains(2)) {
    // One Pair → 3 Karten tauschen
    keepCard = values.map((v) => valueCounts[v] == 2).toList();
  } else {
    // High Card (schlechte Hand) → 4 Karten tauschen, nur höchste behalten
    int maxValue = values.last;
    keepCard = values.map((v) => v == maxValue).toList();
  }

  // Neue Karten für die nicht gehaltenen Positionen ziehen
  return generateNewCards(hand, keepCard);
}

List<String> generateNewCards(List<String> hand, List<bool> keepCard) {
  List<String> newHand = [];
  List<String> deck = generateDeck();
  deck.removeWhere(
      (card) => hand.contains(card)); // Entferne bereits gehaltene Karten

  Random random = Random();

  for (int i = 0; i < hand.length; i++) {
    if (keepCard[i]) {
      newHand.add(hand[i]); // Behalte die Karte
    } else {
      // Ziehe zufällige neue Karte
      newHand.add(deck.removeAt(random.nextInt(deck.length)));
    }
  }

  return newHand;
}

List<String> generateDeck() {
  List<String> suits = ["♠", "♦", "♣", "♥"];
  List<String> values = [
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "J",
    "Q",
    "K",
    "A"
  ];
  List<String> deck = [];

  for (String suit in suits) {
    for (String value in values) {
      deck.add("$value$suit");
    }
  }

  return deck;
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

extension on List<String> {
  List<String> clone() {
    List<String> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
    }
    return result;
  }
}
