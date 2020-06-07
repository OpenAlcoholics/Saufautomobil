import 'package:sam/view/common.dart';
import 'package:sam/view/resource/sam_colors.dart';
import 'package:sam/view/widget/init/init_button.dart';

class InitContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      color: SamColors.primary,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Spacer(),
              Expanded(
                flex: 2,
                child: Image.asset("assets/logo_transparent.png"),
              ),
              Spacer(),
            ],
          ),
          SizedBox(height: 40),
          Container(
            height: 48,
            alignment: AlignmentDirectional.topCenter,
            child: InitControl(),
          ),
        ],
      ),
    );
  }
}
