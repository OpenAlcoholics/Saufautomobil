import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sam/view/resource/messages.i18n.dart';

export 'package:flutter/material.dart';
export 'package:provider/provider.dart';

extension MessagesAccess on BuildContext {
  Messages get messages => Provider.of<Messages>(this, listen: false);
}
