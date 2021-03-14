import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sam/domain/bloc/new_game_load.dart';
import 'package:sam/ui/common.dart';
import 'package:sam/ui/placeholder/page.dart';
import 'package:sam/ui/widget/injected_bloc_provider.dart';

class PreparationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.messages.page.game),
      ),
      body: injectedBlocProvider<NewGameLoad>(
          child: Center(
        child: _GameLoadInfo(),
      )),
    );
  }
}

class _GameLoadInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewGameLoad, NewGameLoadStage>(
      builder: (context, stage) {
        switch (stage) {
          case NewGameLoadStage.fetchingSpecs:
            return _LoadingInfo(context.messages.preparation.fetchingSpecs);
          case NewGameLoadStage.creatingCards:
            return _LoadingInfo(context.messages.preparation.creatingCards);
          case NewGameLoadStage.error:
            return _RetryButton();
          case NewGameLoadStage.success:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => PlaceholderPage(),
              ),
            );
            return Container();
        }
      },
    );
  }
}

class _RetryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error, size: 48),
        const SizedBox(height: 10),
        Text(context.messages.preparation.error),
        TextButton(
          onPressed: () {
            BlocProvider.of<NewGameLoad>(context).add(const Retry());
          },
          child: Text(context.messages.common.retry),
        ),
      ],
    );
  }
}

class _LoadingInfo extends StatelessWidget {
  final String text;

  const _LoadingInfo(this.text) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 10),
        Text(text),
      ],
    );
  }
}
