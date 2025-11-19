import 'package:lingora/features/history/domain/entities/history_entity.dart';
import 'package:lingora/features/history/domain/repositories/history_repository.dart';
import 'package:lingora/features/history/domain/usecases/history_params.dart';

class FetchHistoryUseCase {
  final HistoryRepository historyRepository;
  FetchHistoryUseCase(this.historyRepository);
  Future<Map<String, List<HistoryEntity>>> call(HistoryParams params) async {
    final history = await historyRepository.fetchHistory(params);
    final sortedHistory = sortGroupedData(groupByDate(history));
    return sortedHistory;
  }

  // Group data by date
  Map<String, List<HistoryEntity>> groupByDate(List<HistoryEntity> data) {
    final Map<String, List<HistoryEntity>> datesGroups = {};
    final Set<String> datesIDS = {};

    for (var item in data) {
      final createdAt = item.createdAt;
      final dateKey =
          "${createdAt.year}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}";

      if (!datesIDS.contains(dateKey)) {
        datesGroups[dateKey] = [];
        datesIDS.add(dateKey);
      }

      // Add item to the list of that date
      datesGroups[dateKey]!.add(item);
    }

    return datesGroups;
  }

  // Sort by date
  Map<String, List<HistoryEntity>> sortGroupedData(
      Map<String, List<HistoryEntity>> groupedData) {
    // Convert to list of entries for sorting
    final List<MapEntry<dynamic, dynamic>> entries =
        groupedData.entries.toList();

    // Sort by date key (most recent first)
    entries.sort((a, b) => b.key.toString().compareTo(a.key.toString()));

    // Sort items within each date group by creation time (most recent first)
    for (var entry in entries) {
      final List<HistoryEntity> items = List<HistoryEntity>.from(entry.value);
      items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      entry.value.clear();
      entry.value.addAll(items);
    }

    // Convert back to map
    final Map<String, List<HistoryEntity>> sortedData = {};
    for (var entry in entries) {
      sortedData[entry.key.toString()] = List<HistoryEntity>.from(entry.value);
    }

    return sortedData;
  }
}
