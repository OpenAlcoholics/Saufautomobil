import 'dart:ui';

import 'package:sam/ui/common.dart';
import 'package:sam/ui/resource/messages.i18n.dart';

class MessagesProvider extends StatelessWidget {
  final Widget child;

  const MessagesProvider({required this.child}) : super();

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => _createMessages(context),
      child: child,
    );
  }

  Messages _createMessages(BuildContext context) {
    final languageCode = window.locale.languageCode;
    switch (languageCode) {
      case 'de':
      default:
        return Messages();
    }
  }
}
