class LanguageUtils {
  static String convertLanguageCode(String languageCode) {
    String newLanguageCode = languageCode;
    switch (languageCode) {
      case "es":
        newLanguageCode = "spa";
        break;
      case "ru":
        newLanguageCode = "rsa";
        break;
      case "zh":
        newLanguageCode = "cn";
        break;
    }
    return newLanguageCode;
  }
}
