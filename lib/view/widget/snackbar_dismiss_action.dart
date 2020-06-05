import 'package:sam/view/common.dart';

SnackBarAction dismissSnackBarAction(BuildContext context) {
  return SnackBarAction(
    label: context.messages.common.dismiss,
    onPressed: () => Scaffold.of(context).hideCurrentSnackBar(),
  );
}
