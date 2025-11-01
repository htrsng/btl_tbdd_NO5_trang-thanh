import 'package:json_annotation/json_annotation.dart';

part 'skin_analysis_model.g.dart';

@JsonSerializable()
class SkinIssueDetail {
  @JsonKey(defaultValue: '')
  final String label;

  @JsonKey(defaultValue: '')
  final String severity;

  SkinIssueDetail({required this.label, required this.severity});

  factory SkinIssueDetail.fromJson(Map<String, dynamic> json) =>
      _$SkinIssueDetailFromJson(json);
  Map<String, dynamic> toJson() => _$SkinIssueDetailToJson(this);
}

@JsonSerializable(explicitToJson: true)
class AnalysisDetail {
  @JsonKey(name: 'overall_issues', defaultValue: [])
  final List<SkinIssueDetail> overallIssues;

  @JsonKey(defaultValue: 0)
  final int acne;
  @JsonKey(defaultValue: 0)
  final int pores;
  @JsonKey(defaultValue: 0)
  final int pigmentation;
  @JsonKey(defaultValue: 0)
  final int wrinkles;
  @JsonKey(defaultValue: 0)
  final int texture;
  @JsonKey(defaultValue: 0)
  final int redness;

  AnalysisDetail({
    required this.overallIssues,
    required this.acne,
    required this.pores,
    required this.pigmentation,
    required this.wrinkles,
    required this.texture,
    required this.redness,
  });

  factory AnalysisDetail.fromJson(Map<String, dynamic> json) =>
      _$AnalysisDetailFromJson(json);
  Map<String, dynamic> toJson() => _$AnalysisDetailToJson(this);
}

@JsonSerializable()
class ProductSuggestion {
  @JsonKey(defaultValue: '')
  final String name;
  @JsonKey(defaultValue: '')
  final String brand;
  @JsonKey(defaultValue: '')
  final String reason;
  @JsonKey(defaultValue: '')
  final String image;

  ProductSuggestion({
    required this.name,
    required this.brand,
    required this.reason,
    required this.image,
  });

  factory ProductSuggestion.fromJson(Map<String, dynamic> json) =>
      _$ProductSuggestionFromJson(json);
  Map<String, dynamic> toJson() => _$ProductSuggestionToJson(this);
}

// --- MODEL CHÍNH ---
@JsonSerializable(explicitToJson: true)
class SkinAnalysis {
  @JsonKey(defaultValue: 0.0)
  final double skinScore;

  @JsonKey(defaultValue: '')
  final String skinType;

  final AnalysisDetail analysis;

  @JsonKey(defaultValue: {})
  final Map<String, List<String>> improvements;

  @JsonKey(defaultValue: [])
  final List<ProductSuggestion> products;

  final DateTime? date;

  SkinAnalysis({
    required this.skinScore,
    required this.skinType,
    required this.analysis,
    required this.improvements,
    required this.products,
    this.date,
  });

  factory SkinAnalysis.empty() {
    return SkinAnalysis(
      skinScore: 0.0,
      skinType: '',
      analysis: AnalysisDetail(
          overallIssues: [],
          acne: 0,
          pores: 0,
          pigmentation: 0,
          wrinkles: 0,
          texture: 0,
          redness: 0),
      improvements: {},
      products: [],
      date: DateTime.now(),
    );
  }

  // [THÊM MỚI] - Phương thức copyWith
  SkinAnalysis copyWith({
    double? skinScore,
    String? skinType,
    AnalysisDetail? analysis,
    Map<String, List<String>>? improvements,
    List<ProductSuggestion>? products,
    DateTime? date,
  }) {
    return SkinAnalysis(
      skinScore: skinScore ?? this.skinScore,
      skinType: skinType ?? this.skinType,
      analysis: analysis ?? this.analysis,
      improvements: improvements ?? this.improvements,
      products: products ?? this.products,
      date: date ?? this.date,
    );
  }

  factory SkinAnalysis.fromJson(Map<String, dynamic> json) =>
      _$SkinAnalysisFromJson(json);
  Map<String, dynamic> toJson() => _$SkinAnalysisToJson(this);
}
