import 'package:sam/domain/model/card.dart';

abstract class CardRepository {
  Future<void> replaceCards(Iterable<Card> cards);

  Future<void> updateCard(Card card);
}
