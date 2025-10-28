// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skin_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkinAnalysis _$SkinAnalysisFromJson(Map<String, dynamic> json) => SkinAnalysis(
  skinScore: (json['skinScore'] as num?)?.toDouble() ?? 0.0,
  skinType: json['skinType'] as String? ?? '',
  analysis: json['analysis'] as Map<String, dynamic>? ?? {},
  improvements:
      (json['improvements'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      {},
  products:
      (json['products'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      ) ??
      {},
);

Map<String, dynamic> _$SkinAnalysisToJson(SkinAnalysis instance) =>
    <String, dynamic>{
      'skinScore': instance.skinScore,
      'skinType': instance.skinType,
      'analysis': instance.analysis,
      'improvements': instance.improvements,
      'products': instance.products,
    };
