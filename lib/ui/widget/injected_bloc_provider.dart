import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sam/ui/common.dart';

BlocProvider<B> injectedBlocProvider<B extends Bloc<Object?, Object?>>({
  Widget? child,
  dynamic param1,
}) {
  return BlocProvider<B>(
    create: (_) => GetIt.instance<B>(
      param1: param1,
    ),
    child: child,
  );
}
