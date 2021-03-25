class Replacement {
  final String name;
  final String pattern;
  final String replaceWith;
  final bool skipComparison;

  Replacement({
    required this.name,
    required this.pattern,
    required this.replaceWith,
    required this.skipComparison,
  });

  static List<Replacement> listFromJson(List<dynamic> json) {
    return List.generate(json.length, (r) => Replacement.fromJson(json[r]));
  }

  factory Replacement.fromJson(Map<String, dynamic> json) {
    return Replacement(
      name: json['name'],
      pattern: json['pattern'],
      replaceWith: json['replace_with'],
      skipComparison: json['skip_comparison'] ?? false,
    );
  }
}
