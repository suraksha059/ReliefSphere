enum AppThemeMode {
  light,
  dark,
  system;

  String toJson() => name;
  static AppThemeMode fromJson(String json) => values.byName(json);
}

enum SocialLoginType {
  google,
  facebook;

  String toJson() => name;
  static SocialLoginType fromJson(String json) => values.byName(json);
}
