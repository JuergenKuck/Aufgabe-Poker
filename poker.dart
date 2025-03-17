import 'dart:io';
import 'global.dart';

import 'kuck_io.dart';

List<String> handPlayer = [];
List<String> handComputer = [];
List<bool> changeCardsInfoPlayer = [];
List<bool> changeCardsInfoComputer = [];
PokerHand pokerHandPlayer = PokerHand.none;
PokerHand pokerHandComputer = PokerHand.none;

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

  print('');
  String resultOfGame =
      "Du hast " + (playerIsWinner() ? "gewonnen!" : "leider verloren!");
  print(resultOfGame);
  print('');

  return jaNein("Möchtest Du noch ein Spiel machen?");
}

bool playerIsWinner() {
  bool result = false;
  // 1. Check: Wer der Spieler die höhere PokerHand hat
  //    (z.B. ist RoyalFlash besser als FullHouse)
  if (pokerHandPlayer.index < pokerHandComputer.index) {
    return true;
  }
  // 2. Wenn beide die gleiche PokerHand haben, werden die einzelnen Karten
  //    verglichen. Da beide Hände von klein nach groß sortiert sind,
  //    ist dass nicht sehr aufwendig.
  if (pokerHandPlayer.index == pokerHandComputer.index) {
    List<int> ValuesPlayer = getValues(handPlayer);
    List<int> ValuesComputer = getValues(handComputer);
    for (var i = 4; i >= 0; i--) {
      if (ValuesPlayer[i] != ValuesComputer[i]) {
        result = ValuesPlayer[i] > ValuesComputer[i];
        return result;
      }
    }
  }
  // 3. Spieler hat verloren.
  return result;
}

PokerHand interpreteHand(List<String> hand, List<bool> changeCardsInfo) {
  // Es gestartet von der bestmöglichen PokerHand bis zur schlechtmöglichen
  // untersucht, welche PokerHand das das Balatt (hand) hat und
  // das zugehörige enum zurückgegeben.

  if (isRoyalFlash(hand, changeCardsInfo)) return PokerHand.RoyalFlash;
  if (isStraightFlash(hand, changeCardsInfo)) return PokerHand.StraightFlash;
  if (isFourOfAKind(hand, changeCardsInfo)) return PokerHand.FourOfAKind;
  if (isFullHouse(hand, changeCardsInfo)) return PokerHand.FullHouse;
  if (isFlash(hand, changeCardsInfo)) return PokerHand.Flash;
  if (isStraight(hand, changeCardsInfo)) return PokerHand.Straight;
  if (isThreeOfAKind(hand, changeCardsInfo)) return PokerHand.ThreeOfAKind;
  if (isTwoPair(hand, changeCardsInfo)) return PokerHand.TwoPair;
  if (isPair(hand, changeCardsInfo)) return PokerHand.Pair;
  if (isHeighCard(hand, changeCardsInfo)) return PokerHand.HeighCard;
  return PokerHand.none;
}

void changeHands() {
  // Es werden die Karten der Blätter so ausgetauscht, wie es in
  // den changeCardsInfos vorgegeben ist.
  // Dann werden die sich hieraus ergebenen PokerHands neu bestimmt.
  changeHand(handPlayer, changeCardsInfoPlayer);
  changeHand(handComputer, changeCardsInfoComputer);
  evalPokerHands();
}

void changeHand(List<String> hand, List<bool> changeCardsInfo) {
  // Es werden die Karten eines Blattes so ausgetauscht, wie es in
  // der changeCardsInfo vorgegeben ist.
  for (int i = 0; i < hand.length; i++) {
    if (changeCardsInfo[i]) {
      // Ziehe zufällige neue Karte
      hand[i] = getCard();
    }
  }
  sortHand(hand);
}

void fillChangeCardsInfo(List<bool> changeCardsInfo, String changeStr) {
  // es wird der vom Player eingegeben String zu Kartentausch ausgewertet
  // und das Ergebnis in das changeCardsInfo zurückgeschrieben.
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
    // Zeigt ds aktuelle Blatt des Akteurs (Spielers oder Computers) an.

    String actor,
    List<String> hand,
    PokerHand pokerHand,
    changeCardsComputer) {
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
  print('$printCards0 Blatt: ${pokerHand.name}');
  print(printCards1);
  print(printCards2);
  //print('');
}

int getNumberChangeCards(List<bool> changeCardsInfo) {
  // Berechnet die Anzahl der in der changeCardInfo vorgegebenen Kartenzüge.
  int result = 0;
  for (var changeCard in changeCardsInfo) {
    if (changeCard) {
      result++;
    }
  }
  return result;
}

void evalStartHands() {
  //Zieht neue Blätter(Hands) für Player and Computer
  //und bestimmt deren PokerHands.
  fillHand(handPlayer);
  fillHand(handComputer);
  evalPokerHands();
}

void evalPokerHands() {
  //Bestimmt die PokerHands für Player and Computer
  pokerHandPlayer = interpreteHand(handPlayer, changeCardsInfoPlayer);
  pokerHandComputer = interpreteHand(handComputer, changeCardsInfoComputer);
}

String getCard() {
  //Zieht eine Karte
  String rank = rankMapPoker.keys.elementAt(GetRandom(13));
  String suit = suitSymbols[GetRandom(4)];
  return rank + suit;
}

void fillHand(List<String> hand) {
  // Zieht die 5 Karten füür ein Blatt(Hand) und sortiert sie,
  hand.clear();
  for (int i = 0; i < 5; i++) {
    hand.add(getCard());
  }
  sortHand(hand);
}

void sortHand(List<String> hand) {
  //Sortiert das Blatt(Hand)

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
  // Gibt die Farben('♦', '♥', '♠', '♣') des Blatts(Hand) zurück.
  List<String> suits = [];
  for (String card in hand) {
    String suit = card.substring(card.length - 1); // Farbe der Karte
    suits.add(suit);
  }
  return suits;
}

List<int> getValues(List<String> hand) {
  // Gibt die Werte (2-14) des Blatts(Hand) zurück.
  List<int> values = [];
  for (String card in hand) {
    String value = card.substring(0, card.length - 1); // Karte ohne Farbe
    values
        .add(rankMapPoker[value]!); // Umwandlung des Kartenwertes in eine Zahl
  }
  return values;
}

bool isRoyalFlash(List<String> hand, List<bool> changeCardsInfo) {
  // Überprüft auf RoyalFlash (Höchste Straße in einer Farbe)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall keine.

  bool result =
      isStraightFlash(hand, changeCardsInfo) && getValues(hand).first == 10;
  return result;
}

bool isStraightFlash(List<String> hand, List<bool> changeCardsInfo) {
  // Überprüft auf StraightFlash
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall keine.

  bool _isFlash = isFlash(hand, changeCardsInfo);
  bool _isStraight = isStraight(hand, changeCardsInfo);
  return _isFlash && _isStraight;
}

bool isFourOfAKind(List<String> hand, List<bool> changeCardsInfo) {
  // Überprüft auf FourOfAKind (Vierling)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall eine.

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
  // Überprüft auf FullHouse
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall keine.

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
  // Überprüft auf Flash (alle Karten gleiche Farbe)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall keine.

  return getSuits(hand).toSet().length == 1;
}

bool isStraight(List<String> hand, List<bool> changeCardsInfo) {
  // Überprüft auf Straight(Straße)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall keine.

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
  // Überprüft auf ThreeOfAKind(Drilling)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall zwei.

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
  //Überprüft auf TwoPair(2 Pärchen)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall eine.

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
  // Überprüft auf Pair(Pärchen)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall 3.

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
  // Überprüft auf HeighCard(Höchste Karte)
  // und ermittelt, welche Karten sinnvol ausgetauscht werden können,
  // 'changeCardsInfo' in diesem Fall vier, alle, bis auf die höchste.

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
  // Bestimmt, wieviele Karten jeweils den gleichen Wert haben.

  List<int> values = getValues(hand);
  Map<int, int> valueCounts = values.fold(<int, int>{}, (map, value) {
    map[value] = (map[value] ?? 0) + 1;
    return map;
  });
  List<int> counts = valueCounts.values.toList();
  return counts;
}

// Es follgen 3 List-Extensions, die in obigen Routinen verwendet werden:
// Die Extensions funktionieren für bool, int und double!

extension ListEqual<T> on List<T> {
  // Vergleicht, ob die Elemente der übergebene Liste gleich denen der Liste ist.

  bool equals(List<T> list) {
    if (length != list.length) return false;
    for (int i = 0; i < length; i++) {
      if (this[i] != list[i]) return false;
    }
    return true;
  }
}

extension ListClone<T> on List<T> {
  // Gibt einen Clone der Liste zurück.

  List<T> clone() {
    List<T> result = [];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
    }
    return result;
  }
}

extension ListReplace<T> on List<T> {
  // Ersetzt die Elemente der Liste durch die übergebene Liste.

  void replace(List<T> list) {
    this.clear();
    for (T item in list) {
      this.add(item);
    }
  }
}
