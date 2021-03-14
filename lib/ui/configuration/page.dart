import 'package:get_it/get_it.dart';
import 'package:sam/domain/bloc/configuration.dart';
import 'package:sam/domain/model/game_configuration.dart';
import 'package:sam/domain/persistence/configuration_repository.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/configuration/configuration.dart';
import 'package:sam/ui/widget/injected_bloc_provider.dart';

class ConfigurationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.messages.page.configuration),
      ),
      body: _ConfigurationBody(),
    );
  }
}

class _ConfigurationBody extends StatefulWidget {
  @override
  _ConfigurationBodyState createState() => _ConfigurationBodyState();
}

class _ConfigurationBodyState extends State<_ConfigurationBody> {
  late Future<GameConfiguration> configuration;

  @override
  void initState() {
    super.initState();
    final repo = GetIt.instance<ConfigurationRepository>();
    configuration = repo.getConfiguration();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<GameConfiguration>(
      future: configuration,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return injectedBlocProvider<ConfigurationBloc>(
            param1: snapshot.data,
            child: Configuration(),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
