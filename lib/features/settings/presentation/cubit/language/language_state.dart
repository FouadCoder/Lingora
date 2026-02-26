import 'package:lingora/data/langauges_list.dart';

enum LanguageStatus { initial, loading, success, error }

class LanguageState {
  final LanguageStatus status;
  final Language? language;

  LanguageState({
    this.status = LanguageStatus.initial,
    this.language,
  });

  LanguageState copyWith({
    LanguageStatus? status,
    Language? language,
  }) {
    return LanguageState(
      status: status ?? this.status,
      language: language ?? this.language,
    );
  }
}
