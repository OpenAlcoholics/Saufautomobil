import 'package:bloc/bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:sam/domain/api/card_spec_service.dart';
import 'package:sam/domain/model/card_spec.dart';
import 'package:sam/domain/persistence/card_spec_repository.dart';

abstract class _NewGameLoadEvent {}

class _InitEvent implements _NewGameLoadEvent {}

class _CreateCards implements _NewGameLoadEvent {
  final Set<CardSpec> specs;

  _CreateCards(this.specs);
}

class Retry implements _NewGameLoadEvent {
  const Retry();
}

enum NewGameLoadStage {
  fetchingSpecs,
  creatingCards,
  success,
  error,
}

@injectable
class NewGameLoad extends Bloc<_NewGameLoadEvent, NewGameLoadStage> {
  final Logger _logger;
  final CardSpecLoader _loader;

  NewGameLoad(
    this._logger,
    this._loader,
  ) : super(NewGameLoadStage.fetchingSpecs) {
    add(_InitEvent());
  }

  Future<void> _createCards(Set<CardSpec> specs) async {
    await Future.delayed(const Duration(seconds: 2));
    // TODO
  }

  @override
  Stream<NewGameLoadStage> mapEventToState(_NewGameLoadEvent event) async* {
    if (event is _InitEvent) {
      try {
        final specs = await _loader();
        yield NewGameLoadStage.creatingCards;
        add(_CreateCards(specs));
      } on _CardSpecLoadingException catch (e) {
        _logger.e('Could not fetch card specs', e);
        yield NewGameLoadStage.error;
      }
    } else if (event is _CreateCards) {
      await _createCards(event.specs);
      yield NewGameLoadStage.success;
    } else if (event is Retry && state == NewGameLoadStage.error) {
      yield NewGameLoadStage.fetchingSpecs;
      add(_InitEvent());
    }
  }
}

enum _CardSpecLoadingError {
  ioError,
}

class _CardSpecLoadingException implements Exception {
  final _CardSpecLoadingError error;

  _CardSpecLoadingException(this.error);
}

@injectable
class CardSpecLoader {
  final Logger logger;
  final CardSpecService service;
  final CardSpecRepository repo;

  CardSpecLoader(this.logger, this.service, this.repo);

  Future<Set<CardSpec>> call() async {
    try {
      final dtos = await service();
      final specs = dtos.map((e) => e.toModel()).toSet();
      await repo.replaceSpecs(specs);
      return specs;
    } on CardSpecServiceException catch (e) {
      logger.e('Could not fetch newest CardSpecs', e);
      final specs = await repo.getSpecs();
      if (specs.isEmpty) {
        throw _CardSpecLoadingException(_CardSpecLoadingError.ioError);
      } else {
        return specs;
      }
    }
  }
}
