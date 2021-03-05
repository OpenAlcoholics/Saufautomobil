import 'package:sam/domain/api/card_spec_service.dart';
import 'package:sam/infrastructure/api/card_spec_service_github.dart';
import 'package:test/test.dart';

import '../../test_infrastructure.dart';

void main() {
  final service = configureDependencies()<CardSpecServiceGithub>();
  test("Call does not throw exception", () async {
    await service();
  });
  group("The cards", () {
    List<CardSpecDto> cards = [];
    setUpAll(() async {
      cards = await service();
    });

    test("are not null", () => expect(cards, isNotNull));
    test("exist", () => expect(cards.length, greaterThan(0)));
  });
}
