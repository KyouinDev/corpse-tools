class Replacement {
  final String name;
  final String pattern;
  final String replaceWith;
  final bool skipComparison;

  Replacement(this.name, this.pattern, this.replaceWith, this.skipComparison);

  static List<Replacement> listFromJson(List<dynamic> json) {
    return List.generate(json.length, (r) => Replacement.fromJson(json[r]));
  }

  factory Replacement.fromJson(Map<String, dynamic> json) {
    return Replacement(
      json['name'],
      json['pattern'],
      json['replace_with'],
      json['skip_comparison'] ?? false,
    );
  }
}
