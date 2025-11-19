import 'package:easy_localization/easy_localization.dart';
import 'package:lingora/data/langauges_list.dart';
import 'package:lingora/features/history/domain/entities/history_entity.dart';

class HistoryModel {
  final String? id;
  final String? userId;
  final String original;
  final String translated;
  final Language? translateFrom;
  final Language? translateTo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  HistoryModel(
      {this.id,
      this.userId,
      required this.original,
      required this.translated,
      this.translateFrom,
      this.translateTo,
      required this.createdAt,
      required this.updatedAt,
      this.deletedAt});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    return HistoryModel(
      id: json['id'],
      userId: json['user_id'],
      original: json['original'] ?? "",
      translated: json['translated'] ?? "translation_not_found".tr(),
      translateFrom: json["translate_from"] != null
          ? LanguageData.getLanguageByCode(json["translate_from"])
          : LanguageData.getLanguageByCode("en"),
      translateTo: json["translate_to"] != null
          ? LanguageData.getLanguageByCode(json["translate_to"])
          : LanguageData.getLanguageByCode("ar"),
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
      deletedAt: json['deleted_at'] != null
          ? DateTime.tryParse(json['deleted_at']!)
          : null,
    );
  }

  // To Entity
  HistoryEntity toEntity() {
    return HistoryEntity(
      id: id,
      userId: userId,
      original: original,
      translated: translated,
      translateFrom: translateFrom!,
      translateTo: translateTo!,
      createdAt: createdAt,
      updatedAt: updatedAt,
      deletedAt: deletedAt,
    );
  }
}
