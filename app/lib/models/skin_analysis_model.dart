import 'package:json_annotation/json_annotation.dart';

part 'skin_analysis_model.g.dart';

@JsonSerializable()
class SkinAnalysis {
  @JsonKey(defaultValue: 0.0)
  final double skinScore;

  @JsonKey(defaultValue: '')
  final String skinType;

  @JsonKey(defaultValue: <String, dynamic>{})
  final Map<String, dynamic> analysis; // e.g., {"overall_issues": [{"label": "acne", "confidence": 0.4}]}

  @JsonKey(defaultValue: <String, List<String>>{})
  final Map<String, List<String>> improvements;

  @JsonKey(defaultValue: <String, List<String>>{})
  final Map<String, List<String>> products;

  SkinAnalysis({
    required this.skinScore,
    required this.skinType,
    required this.analysis,
    required this.improvements,
    required this.products,
  });

  factory SkinAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SkinAnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$SkinAnalysisToJson(this);
}
