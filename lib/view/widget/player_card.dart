import 'package:sam/view/common.dart';

class PlayerCard extends StatelessWidget {
  final String player;
  final Widget trailing;

  const PlayerCard(this.player, {this.trailing}) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(player),
        trailing: trailing,
      ),
    );
  }
}
