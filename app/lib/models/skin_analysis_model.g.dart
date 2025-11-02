// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skin_analysis_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkinIssueDetail _$SkinIssueDetailFromJson(Map<String, dynamic> json) =>
    SkinIssueDetail(
      label: json['label'] as String? ?? '',
      severity: json['severity'] as String? ?? '',
    );

Map<String, dynamic> _$SkinIssueDetailToJson(SkinIssueDetail instance) =>
    <String, dynamic>{
      'label': instance.label,
      'severity': instance.severity,
    };

AnalysisDetail _$AnalysisDetailFromJson(Map<String, dynamic> json) =>
    AnalysisDetail(
      overallIssues: (json['overall_issues'] as List<dynamic>?)
              ?.map((e) => SkinIssueDetail.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      acne: (json['acne'] as num?)?.toInt() ?? 0,
      pores: (json['pores'] as num?)?.toInt() ?? 0,
      pigmentation: (json['pigmentation'] as num?)?.toInt() ?? 0,
      wrinkles: (json['wrinkles'] as num?)?.toInt() ?? 0,
      texture: (json['texture'] as num?)?.toInt() ?? 0,
      redness: (json['redness'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$AnalysisDetailToJson(AnalysisDetail instance) =>
    <String, dynamic>{
      'overall_issues': instance.overallIssues.map((e) => e.toJson()).toList(),
      'acne': instance.acne,
      'pores': instance.pores,
      'pigmentation': instance.pigmentation,
      'wrinkles': instance.wrinkles,
      'texture': instance.texture,
      'redness': instance.redness,
    };

ProductSuggestion _$ProductSuggestionFromJson(Map<String, dynamic> json) =>
    ProductSuggestion(
      name: json['name'] as String? ?? '',
      brand: json['brand'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
      image: json['image'] as String? ?? '',
    );

Map<String, dynamic> _$ProductSuggestionToJson(ProductSuggestion instance) =>
    <String, dynamic>{
      'name': instance.name,
      'brand': instance.brand,
      'reason': instance.reason,
      'image': instance.image,
    };

SkinAnalysis _$SkinAnalysisFromJson(Map<String, dynamic> json) => SkinAnalysis(
      skinScore: (json['skinScore'] as num?)?.toDouble() ?? 0.0,
      skinType: json['skinType'] as String? ?? '',
      analysis:
          AnalysisDetail.fromJson(json['analysis'] as Map<String, dynamic>),
      improvements: (json['improvements'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, (e as List<dynamic>).map((e) => e as String).toList()),
          ) ??
          {},
      products: (json['products'] as List<dynamic>?)
              ?.map(
                  (e) => ProductSuggestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      lifestyleTips: (json['lifestyleTips'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, (e as List<dynamic>).map((e) => e as String).toList()),
          ) ??
          {},
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$SkinAnalysisToJson(SkinAnalysis instance) =>
    <String, dynamic>{
      'skinScore': instance.skinScore,
      'skinType': instance.skinType,
      'analysis': instance.analysis.toJson(),
      'improvements': instance.improvements,
      'products': instance.products.map((e) => e.toJson()).toList(),
      'lifestyleTips': instance.lifestyleTips,
      'date': instance.date?.toIso8601String(),
    };
