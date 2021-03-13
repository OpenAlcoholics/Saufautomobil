import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:logger/logger.dart';
import 'package:sam/domain/api/card_spec_service.dart';

part 'card_spec_service_github.g.dart';

@JsonSerializable()
class _SerializableCardSpecDto extends CardSpecDto {
  _SerializableCardSpecDto({
    required String text,
    required int count,
    required int uses,
    required int rounds,
    required bool personal,
    required bool remote,
    required bool unique,
    required int id,
  }) : super(
          text: text,
          count: count,
          uses: uses,
          rounds: rounds,
          personal: personal,
          remote: remote,
          unique: unique,
          id: id,
        );

  factory _SerializableCardSpecDto.fromJson(Map<String, dynamic> json) =>
      _$_SerializableCardSpecDtoFromJson(json);
}

const _tasksUrl =
    'https://github.com/OpenAlcoholics/drinking-game-cards/raw/v1/tasks.json';

@injectable
@Injectable(as: CardSpecService)
class CardSpecServiceGithub implements CardSpecService {
  final Logger logger;
  final Dio dio;

  CardSpecServiceGithub(this.logger, this.dio);

  _SerializableCardSpecDto _createSerializableDto(dynamic input) {
    return _SerializableCardSpecDto.fromJson(input as Map<String, dynamic>);
  }

  @override
  Future<List<CardSpecDto>> call() async {
    try {
      // TODO: running IO in a compute() would be nice
      final response = await dio.get<List>(_tasksUrl);
      final result = response.data
          ?.map((e) => _createSerializableDto(e))
          .toList(growable: false);
      if (result == null) {
        throw CardSpecServiceException('message');
      }
      return result;
    } on DioError catch (e) {
      logger.e('Could not retrieve tasks', e);
      throw CardSpecServiceException(e.message);
    }
  }
}
