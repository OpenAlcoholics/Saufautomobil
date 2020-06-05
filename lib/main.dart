import 'package:sam/data/dependency_model.dart';
import 'package:sam/domain/tasks/tasks_service.dart';
import 'package:sam/view/common.dart';
import 'package:sam/view/page/player_page.dart';
import 'package:sam/view/resource/sam_colors.dart';
import 'package:sam/view/widget/messages_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DependencyModel().init();
  service<TasksService>().updateTasks();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MessagesProvider(
      child: MaterialApp(
        title: 'Saufautomat',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primaryTextTheme: Typography.blackMountainView.apply(
            displayColor: SamColors.primaryText,
            bodyColor: SamColors.primaryText,
          ),
          primaryColor: SamColors.primary,
          // This makes the visual density adapt to the platform that you run
          // the app on. For desktop platforms, the controls will be smaller and
          // closer together (more dense) than on mobile platforms.
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: PlayerPage(),
      ),
    );
  }
}
