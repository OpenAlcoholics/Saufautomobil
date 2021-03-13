import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:sam/infrastructure/dependency/dependency_container.config.dart';

@InjectableInit()
void configureDependencies() => $initGetIt(
      GetIt.instance,
      environment: Environment.prod,
    );