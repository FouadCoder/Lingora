import 'package:lingora/core/exceptions/network_exception.dart';
import 'package:lingora/core/service/network_service.dart';
import 'package:lingora/features/history/data/datasources/history_remote_data.dart';
import 'package:lingora/features/history/data/models/history_model.dart';
import 'package:lingora/features/history/domain/entities/history_entity.dart';
import 'package:lingora/features/history/domain/repositories/history_repository.dart';
import 'package:lingora/features/history/domain/usecases/history_params.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryRemoteData historyRemoteData;

  HistoryRepositoryImpl(this.historyRemoteData);

  @override
  Future<List<HistoryEntity>> fetchHistory(HistoryParams params) async {
    // Check Internet
    if (!await NetworkService().isConnect()) throw NetworkException();
    // Call
    final List<HistoryModel> historyModels =
        await historyRemoteData.fetchHistory(params);
    final List<HistoryEntity> historyEntities =
        historyModels.map((e) => e.toEntity()).toList();

    return historyEntities;
  }
}
