import 'package:sam/domain/model/card_spec.dart';

abstract class CardSpecRepository {
  Future<void> clearSpecs();

  Future<void> replaceSpecs(Iterable<CardSpec> specs);

  Future<Set<CardSpec>> getSpecs();
}