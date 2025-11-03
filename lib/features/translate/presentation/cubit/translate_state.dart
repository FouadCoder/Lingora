import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/translate/domain/entities/translate_entity.dart';

enum TranslateStatus { initial, loading, success, failure, empty }

class TranslateState {
  final TranslateStatus status;
  final String inputText;
  final TranslateEntity? result;
  final Language sourceLanguage;
  final Language targetLanguage;

  const TranslateState({
    this.status = TranslateStatus.initial,
    this.inputText = '',
    this.result,
    this.sourceLanguage = const Language(
      name: 'English',
      nativeName: 'British English',
      code: 'en',
      flag: '🇬🇧',
      region: 'Europe',
    ),
    this.targetLanguage = const Language(
      name: 'Arabic',
      nativeName: 'العربية',
      code: 'ar',
      flag: '🇸🇦',
      region: 'Middle East',
    ),
  });

  TranslateState copyWith({
    TranslateStatus? status,
    String? inputText,
    TranslateEntity? result,
    Language? sourceLanguage,
    Language? targetLanguage,
  }) {
    return TranslateState(
      status: status ?? this.status,
      inputText: inputText ?? this.inputText,
      result: result ?? this.result,
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
    );
  }
}
