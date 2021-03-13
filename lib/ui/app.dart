import 'package:sam/ui/common.dart';
import 'package:sam/ui/init/page.dart';
import 'package:sam/ui/resource/sam_colors.dart';
import 'package:sam/ui/widget/messages_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp._();

  static void launch() {
    runApp(const MyApp._());
  }

  @override
  Widget build(BuildContext context) {
    return MessagesProvider(
      child: Builder(
        builder: (context) => MaterialApp(
          title: context.messages.common.appName,
          theme: ThemeData(
            backgroundColor: SamColors.primary,
            primaryTextTheme: Typography.blackMountainView.apply(
              displayColor: SamColors.primaryText,
              bodyColor: SamColors.primaryText,
            ),
            primaryColor: SamColors.primary,
            accentColor: SamColors.accent,
            snackBarTheme: SnackBarThemeData(
              actionTextColor: SamColors.primary,
            ),
            bottomNavigationBarTheme: const BottomNavigationBarThemeData(
              selectedItemColor: Colors.orangeAccent,
            ),
            accentTextTheme: Typography.whiteMountainView,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const InitPage(),
        ),
      ),
    );
  }
}
