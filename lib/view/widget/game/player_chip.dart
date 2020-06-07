import 'package:sam/view/common.dart';
import 'package:sam/view/resource/sam_colors.dart';

class PlayerChip extends StatelessWidget {
  final String player;
  final bool isActive;

  const PlayerChip({
    Key key,
    @required this.player,
    @required this.isActive,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(player),
      backgroundColor: isActive ? SamColors.activePlayerHighlight : null,
    );
  }
}
