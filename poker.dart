import 'dart:io';
import 'dart:math';
import 'global.dart';

List<String> handPlayer = [];
List<String> handComputer = [];
List<bool> changeCardsInfoPlayer = [];
List<bool> changeCardsInfoComputer = [];
String pokerHandPlayer = '';
String pokerHandComputer = '';

List<bool> changeCardsInfoBlank = [false, false, false, false, false];

bool gamePoker() {
  printHeader('Poker - Karten ziehen');
  evalStartHands();

  int numberChangeComputer = getNumberChangeCards(changeCardsInfoComputer);
  showHand('Spieler ', handPlayer, pokerHandPlayer, numberChangeComputer);
  print('');
  print('Möglichkeit zum Kartentausch:');
  print('  gib die Nummern der Karten, die getauscht werden sollen (z.B.: 123');
  print('  wenn keine Karte getauscht werden soll, gib <Enter> ein');
  String changeStr = stdin.readLineSync() ?? '';
  fillChangeCardsInfo(changeCardsInfoPlayer, changeStr);

  changeHands();

  showHand('Spieler ', handPlayer, pokerHandPlayer, 0);
  showHand('Computer', handComputer, pokerHandComputer, 0);

  /*
  printHeader('Karten aktuell');
  printCardsCurrent('Spieler', hand, pokerHand, true);
  hand = generateNewHand(hand, keepHand);
  pokerHand = interpreteHand(hand, keepHand);
  printCardsCurrent('Getauscht', hand, pokerHand, false);
  */
  print('');
  print('To Do: 1. Vergleichen Spieler und Computer => Sieger des Spiels');
  print('       2. Statisitk über gewonnene und verlorene Spiele.\n');

  return jaNein("Möchtest Du noch ein Spiel machen?");
}

void changeHands() {
  changeHand(handPlayer, changeCardsInfoPlayer);
  changeHand(handComputer, changeCardsInfoComputer);
  evalPokerHands();
}

void changeHand(List<String> hand, List<bool> changeCardsInfo) {
  for (int i = 0; i < hand.length; i++) {
    if (changeCardsInfo[i]) {
      // Ziehe zufällige neue Karte
      hand[i] = getCard();
    }
  }
  sortHand(hand);
}

void fillChangeCardsInfo(List<bool> changeCardsInfo, String changeStr) {
  for (int i = 0; i < 5; i++) {
    changeCardsInfo[i] = false;
    String iStr = (i + 1).toString();
    for (int k = 0; k < changeStr.length; k++) {
      if (changeStr[k] == iStr) {
        changeCardsInfo[i] = true;
        break;
      }
    }
  }
}

void showHand(
    String actor, List<String> hand, String pokerHand, changeCardsComputer) {
  // Zeigt ds aktuelle Blatt des Spielers oder des Comuuters an

  String actor1 = actor.length < 8 ? actor + '   ' : actor;
  String printCards0 = "$actor1: ";
  String printCards1 = '          ';
  String printCards2 = '          ';

  String printCards3 = '          ';

  String color = '';

  for (int i = 0; i < hand.length; i++) {
    printCards3 += '${i + 1}     ';
    String rank;
    String suit;
    if (hand[i].length == 2) {
      rank = hand[i][0];
      suit = hand[i][1];
    } else {
      rank = hand[i][0] + hand[i][1];
      suit = hand[i][2];
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

  if (changeCardsComputer != 0)
    printCards2 += ' Der Computer hat $changeCardsComputer Karten getauscht.';
  print(printCards3);
  print('$printCards0 Blatt: $pokerHand');
  print(printCards1);
  print(printCards2);
  //print('');
}

int getNumberChangeCards(List<bool> changeCardsInfo) {
  int result = 0;
  for (var changeCard in changeCardsInfo) {
    if (changeCard) {
      result++;
    }
  }
  return result;
}

void evalStartHands() {
  //draws the hands of Player and Computer
  fillHand(handPlayer);
  fillHand(handComputer);
  evalPokerHands();
}

void evalPokerHands() {
  //eval Pokerhands and possible keepHands
  pokerHandPlayer = interpreteHand(handPlayer, changeCardsInfoPlayer);
  pokerHandComputer = interpreteHand(handComputer, changeCardsInfoComputer);
}

String getCard() {
  String rank = rankMapPoker.keys.elementAt(GetRandom(13));
  String suit = suitSymbols[GetRandom(4)];
  return rank + suit;
}

void fillHand(List<String> hand) {
  //Draws 5 card for a hand
  hand.clear();
  for (int i = 0; i < 5; i++) {
    hand.add(getCard());
  }
  sortHand(hand);
}

void test() {
  clearTerminal();

  List<String> hand = ["K♠", "K♦", "7♣", "5♠", "2♥"]; // Beispiel: One Pair
  // printCardsCurrent('Spieler', hand, '', false);

  List<String> newHand = exchangeCards(hand);
  //printCardsCurrent('Nachher', newHand, '', false);
}

String getCards(List<String> hand) {
  List<String> hand0;
  hand0 = ["J♥", "10♥", "Q♥", "K♥", "A♥"]; //Royal Flash

  hand0 = ["9♥", "J♥", "10♥", "Q♥", "K♥"]; // Straight Flash
  hand0 = ["8♠", "8♥", "5♦", "8♥", "8♣"]; // Four of a Kind (1)
  hand0 = ["8♠", "8♥", "A♦", "8♥", "8♣"]; // Four of a Kind (2)

  hand0 = ["2♠", "5♥", "5♦", "2♥", "5♣"]; // Full House
  hand0 = ["2♥", "A♠", "3♠", "4♠", "5♠"]; // Straight
  hand0 = ["8♠", "2♥", "2♦", "5♥", "2♣"]; // Three of a Kind (1)
  hand0 = ["5♠", "2♥", "5♦", "5♥", "8♣"]; // Three of a Kind (2)
  hand0 = ["8♠", "2♥", "8♦", "5♥", "8♣"]; // Three of a Kind (3)

  hand0 = ["2♠", "4♥", "5♦", "4♥", "5♣"]; // Two Pair (1)
  hand0 = ["2♠", "2♥", "4♦", "5♥", "5♣"]; // Two Pair (2)
  hand0 = ["2♠", "4♥", "2♦", "4♥", "5♣"]; // Two Pair (3)

  hand0 = ["8♠", "2♥", "2♦", "7♥", "5♣"]; // Pair (1)
  hand0 = ["5♠", "2♥", "A♦", "8♥", "5♣"]; // Pair (2)
  hand0 = ["8♠", "2♥", "A♦", "8♥", "5♣"]; // Pair (3)
  hand0 = ["A♠", "2♥", "A♦", "8♥", "5♣"]; // Pair (4)

  hand0 = ["2♠", "8♥", "A♦", "7♥", "5♣"]; // Heigh Card
  /*
*/

  for (int i = 0; i < 5; i++) {
    String rank = rankMapPoker.keys.elementAt(GetRandom(13));
    String suit = suitSymbols[GetRandom(4)];

    hand.add(hand0[i]);
  }
  sortHand(hand);
  List<bool> keepHand = [];
  String result = interpreteHand(hand, keepHand);
  List<String> newHand = generateNewHand(hand, keepHand);

  return result;

  //String result = determineHandRank(cards);
}

String interpreteHand(List<String> hand, List<bool> hangeCardsInfo) {
  if (isRoyalFlash(hand, hangeCardsInfo)) return 'Royal Flash';
  if (isStraightFlash(hand, hangeCardsInfo)) return 'Straight Flash';
  if (isFourOfAKind(hand, hangeCardsInfo)) return 'Four of a Kind';
  if (isFullHouse(hand, hangeCardsInfo)) return 'Full House';
  if (isFlash(hand, hangeCardsInfo)) return 'Flash';
  if (isStraight(hand, hangeCardsInfo)) return 'Straight';
  if (isThreeOfAKind(hand, hangeCardsInfo)) return 'Three of a Kind';
  if (isTwoPair(hand, hangeCardsInfo)) return 'Two Pair';
  if (isPair(hand, hangeCardsInfo)) return 'Pair';
  if (isHeighCard(hand, hangeCardsInfo)) return 'Heigh Card';
  return 'Fehler';
}

void sortHand(List<String> hand) {
  List<int> values = getValues(hand);
  List<String> suits = getSuits(hand);

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

List<String> generateNewHand(List<String> hand, List<bool> keepCard) {
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
  sortHand(newHand);
  return newHand;
}

bool isRoyalFlash(List<String> hand, List<bool> changeCardsInfo) {
  bool result =
      isStraightFlash(hand, changeCardsInfo) && getValues(hand).first == 10;
  return result;
}

bool isStraightFlash(List<String> hand, List<bool> changeCardsInfo) {
  bool _isFlash = isFlash(hand, changeCardsInfo);
  bool _isStraight = isStraight(hand, changeCardsInfo);
  return _isFlash && _isStraight;
}

bool isFourOfAKind(List<String> hand, List<bool> changeCardsInfo) {
  List<int> counts = getCounts(hand);
  bool result = counts.contains(4);
  if (result) {
    List<String> _hand = hand.clone();

    if (counts[0] == 4) {
      hand[0] = _hand[4];
      for (int i = 0; i < _hand.length - 1; i++) {
        hand[i + 1] = _hand[i];
      }
    }
  }

  if (result) {
    changeCardsInfo.replace([true, false, false, false, false]);
  }

  return result;
}

bool isFullHouse(List<String> hand, List<bool> changeCardsInfo) {
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

bool isFlash(List<String> hand, List<bool> changeCardsInfo) {
  // Überprüfe, ob alle Karten die gleiche Farbe haben
  return getSuits(hand).toSet().length == 1;
}

bool isStraight(List<String> hand, List<bool> changeCardsInfo) {
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

bool isThreeOfAKind(List<String> hand, List<bool> changeCardsInfo) {
  List<int> counts = getCounts(hand);
  bool result = counts.contains(3);

  if (result) {
    List<String> _hand = hand.clone();

    int _k = 0;
    int k = 0;
    for (int count in counts) {
      if (count == 3) {
        hand[2] = _hand[k];
        hand[3] = _hand[k + 1];
        hand[4] = _hand[k + 2];
        _k += 3;
      } else {
        hand[k] = _hand[_k];
        k++;
        _k++;
      }
    }
  }
  if (result) {
    changeCardsInfo.replace([true, true, false, false, false]);
  }
  return result;
}

bool isTwoPair(List<String> hand, List<bool> changeCardsInfo) {
  List<int> values = getValues(hand);
  List<int> counts = getCounts(hand);
  int sum = 0;
  for (int count in counts) {
    if (count == 2) sum++;
  }
  bool result = sum == 2;

  if (result) {
    List<String> _hand = hand.clone();

    int k = 0;
    int i2 = 0;
    for (int count in counts) {
      if (count == 2) {
        hand[1 + i2] = _hand[k];
        hand[2 + i2] = _hand[k + 1];
        k += 2;
        i2 += 2;
      } else {
        hand[0] = _hand[k];
        k++;
      }
    }
  }
  if (result) {
    changeCardsInfo.replace([true, false, false, false, false]);
  }

  return result;
}

bool isPair(List<String> hand, List<bool> changeCardsInfo) {
  List<int> counts = getCounts(hand);
  bool result = counts.contains(2);

  if (result) {
    List<String> _hand = hand.clone();

    int _k = 0;
    int k = 0;
    for (int count in counts) {
      if (count == 2) {
        hand[3] = _hand[k];
        hand[4] = _hand[k + 1];
        _k += 2;
      } else {
        hand[k] = _hand[_k];
        k++;
        _k++;
      }
    }
  }
  if (result) {
    changeCardsInfo.replace([true, true, true, false, false]);
  }

  return result;
}

bool isHeighCard(List<String> hand, List<bool> changeCardsInfo) {
  List<int> counts = getCounts(hand);
  int sum = 0;
  for (int count in counts) {
    if (count == 1) sum++;
  }
  bool result = sum == 5;

  if (result) {
    changeCardsInfo.replace([true, true, true, true, false]);
  }
  return result;
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

// Vergleicht, ob die übergebene Liste gkeich der Liste ist.
// Funktioniert aktuell nur für bool, int und double und nicht für Klassen!
extension ListEqual<T> on List<T> {
  bool equals(List<T> list) {
    if (length != list.length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != list[i]) return false;
    }
    return true;
  }
}
// Gibt einen Clone der Liste zurück.
// Funktioniert aktuell nur für bool, int und double und nicht für Klassen!

extension ListClone<T> on List<T> {
  List<T> clone() {
    List<T> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
    }
    return result;
  }
}

extension ListReplace<T> on List<T> {
  void replace(List<T> list) {
    this.clear();
    for (T item in list) {
      this.add(item);
    }
  }
}
