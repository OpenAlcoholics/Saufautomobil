import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sam/view/resource/messages.i18n.dart';

class MessagesProvider extends StatelessWidget {
  final Widget child;

  const MessagesProvider({Key key, @required this.child}) : super(key: key);

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
