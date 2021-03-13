import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sam/ui/resource/messages.i18n.dart';

export 'package:flutter/material.dart';
export 'package:provider/provider.dart';
export 'package:sam/ui/resource/messages.i18n.dart';

extension MessagesAccess on BuildContext {
  Messages get messages => Provider.of<Messages>(this, listen: false);
}
