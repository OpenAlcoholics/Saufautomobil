import 'package:sam/view/common.dart';

class RetryButton extends StatelessWidget {
  final Function() onPressed;

  const RetryButton({
    Key key,
    @required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: onPressed,
          ),
          Text(context.messages.common.retry),
        ],
      ),
    );
  }
}
