import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sam/ui/common.dart';

class InjectedBlocProvider<B extends Bloc<Object?, Object?>>
    extends StatelessWidget {
  final Widget child;
  final dynamic param1;

  const InjectedBlocProvider({required this.child, this.param1}) : super();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<B>(
      create: (_) => GetIt.instance<B>(
        param1: param1,
      ),
      child: child,
    );
  }
}
