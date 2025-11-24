class Language {
  final String name;
  final String nativeName;
  final String code;
  final String flag;
  final String region;

  const Language({
    required this.name,
    required this.nativeName,
    required this.code,
    required this.flag,
    required this.region,
  });
}

class LanguageData {
  static const List<Language> languages = [
    Language(
      name: 'Arabic',
      nativeName: 'العربية',
      code: 'ar',
      flag: '🇸🇦',
      region: 'Middle East',
    ),
    Language(
      name: 'Bulgarian',
      nativeName: 'Български',
      code: 'bg',
      flag: '🇧🇬',
      region: 'Europe',
    ),
    Language(
      name: 'Chinese (Simplified)',
      nativeName: '简体中文',
      code: 'zh-cn',
      flag: '🇨🇳',
      region: 'Asia',
    ),
    Language(
      name: 'Chinese (Traditional)',
      nativeName: '繁體中文',
      code: 'zh-tw',
      flag: '🇹🇼',
      region: 'Asia',
    ),
    Language(
      name: 'Czech',
      nativeName: 'Čeština',
      code: 'cs',
      flag: '🇨🇿',
      region: 'Europe',
    ),
    Language(
      name: 'Danish',
      nativeName: 'Dansk',
      code: 'da',
      flag: '🇩🇰',
      region: 'Europe',
    ),
    Language(
      name: 'Dutch',
      nativeName: 'Nederlands',
      code: 'nl',
      flag: '🇳🇱',
      region: 'Europe',
    ),
    Language(
      name: 'English',
      nativeName: 'British English',
      code: 'en',
      flag: '🇬🇧',
      region: 'Europe',
    ),
    Language(
      name: 'Estonian',
      nativeName: 'Eesti',
      code: 'et',
      flag: '🇪🇪',
      region: 'Europe',
    ),
    Language(
      name: 'Finnish',
      nativeName: 'Suomi',
      code: 'fi',
      flag: '🇫🇮',
      region: 'Europe',
    ),
    Language(
      name: 'French',
      nativeName: 'Français',
      code: 'fr',
      flag: '🇫🇷',
      region: 'Europe',
    ),
    Language(
      name: 'German',
      nativeName: 'Deutsch',
      code: 'de',
      flag: '🇩🇪',
      region: 'Europe',
    ),
    Language(
      name: 'Greek',
      nativeName: 'Ελληνικά',
      code: 'el',
      flag: '🇬🇷',
      region: 'Europe',
    ),
    Language(
      name: 'Hungarian',
      nativeName: 'Magyar',
      code: 'hu',
      flag: '🇭🇺',
      region: 'Europe',
    ),
    Language(
      name: 'Indonesian',
      nativeName: 'Bahasa Indonesia',
      code: 'id',
      flag: '🇮🇩',
      region: 'Asia',
    ),
    Language(
      name: 'Italian',
      nativeName: 'Italiano',
      code: 'it',
      flag: '🇮🇹',
      region: 'Europe',
    ),
    Language(
      name: 'Japanese',
      nativeName: '日本語',
      code: 'ja',
      flag: '🇯🇵',
      region: 'Asia',
    ),
    Language(
      name: 'Korean',
      nativeName: '한국어',
      code: 'ko',
      flag: '🇰🇷',
      region: 'Asia',
    ),
    Language(
      name: 'Latvian',
      nativeName: 'Latviešu',
      code: 'lv',
      flag: '🇱🇻',
      region: 'Europe',
    ),
    Language(
      name: 'Lithuanian',
      nativeName: 'Lietuvių',
      code: 'lt',
      flag: '🇱🇹',
      region: 'Europe',
    ),
    Language(
      name: 'Norwegian Bokmål',
      nativeName: 'Norsk Bokmål',
      code: 'nb',
      flag: '🇳🇴',
      region: 'Europe',
    ),
    Language(
      name: 'Polish',
      nativeName: 'Polski',
      code: 'pl',
      flag: '🇵🇱',
      region: 'Europe',
    ),
    Language(
      name: 'Portuguese (Brazilian)',
      nativeName: 'Português Brasileiro',
      code: 'pt-br',
      flag: '🇧🇷',
      region: 'South America',
    ),
    Language(
      name: 'Portuguese (European)',
      nativeName: 'Português Europeu',
      code: 'pt-pt',
      flag: '🇵🇹',
      region: 'Europe',
    ),
    Language(
      name: 'Romanian',
      nativeName: 'Română',
      code: 'ro',
      flag: '🇷🇴',
      region: 'Europe',
    ),
    Language(
      name: 'Russian',
      nativeName: 'Русский',
      code: 'ru',
      flag: '🇷🇺',
      region: 'Europe',
    ),
    Language(
      name: 'Slovak',
      nativeName: 'Slovenčina',
      code: 'sk',
      flag: '🇸🇰',
      region: 'Europe',
    ),
    Language(
      name: 'Slovenian',
      nativeName: 'Slovenščina',
      code: 'sl',
      flag: '🇸🇮',
      region: 'Europe',
    ),
    Language(
      name: 'Spanish',
      nativeName: 'Español Europeo',
      code: 'es-es',
      flag: '🇪🇸',
      region: 'Europe',
    ),
    Language(
      name: 'Swedish',
      nativeName: 'Svenska',
      code: 'sv',
      flag: '🇸🇪',
      region: 'Europe',
    ),
    Language(
      name: 'Thai',
      nativeName: 'ไทย',
      code: 'th',
      flag: '🇹🇭',
      region: 'Asia',
    ),
    Language(
      name: 'Ukrainian',
      nativeName: 'Українська',
      code: 'uk',
      flag: '🇺🇦',
      region: 'Europe',
    ),
    Language(
      name: 'Vietnamese',
      nativeName: 'Tiếng Việt',
      code: 'vi',
      flag: '🇻🇳',
      region: 'Asia',
    ),
  ];

  // Get languages by region
  static List<Language> getLanguagesByRegion(String region) {
    return languages.where((lang) => lang.region == region).toList();
  }

  // Get languages excluding specific codes
  static List<Language> getLanguagesExcluding(List<String> excludeCodes) {
    return languages
        .where((lang) => !excludeCodes.contains(lang.code))
        .toList();
  }

  // Get popular languages (first 20)
  static List<Language> getPopularLanguages() {
    return languages.take(20).toList();
  }

  // Search languages by name or code
  static List<Language> searchLanguages(String query) {
    query = query.toLowerCase();
    return languages
        .where((lang) =>
            lang.name.toLowerCase().contains(query) ||
            lang.nativeName.toLowerCase().contains(query) ||
            lang.code.toLowerCase().contains(query))
        .toList();
  }

  // Get a single language by its code
  static Language? getLanguageByCode(String code) {
    try {
      return languages.firstWhere((lang) => lang.code == code);
    } catch (e) {
      return languages.firstWhere((lang) => lang.code == "en");
    }
  }
}
