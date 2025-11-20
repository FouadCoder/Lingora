import 'package:lingora/features/history/domain/entities/history_entity.dart';
import 'package:lingora/features/history/domain/usecases/history_params.dart';

abstract class HistoryRepository {
  Future<List<HistoryEntity>> fetchHistory(HistoryParams params);
}
