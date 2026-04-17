import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainLocalization {
  final Locale locale;

  MainLocalization(this.locale);

  static MainLocalization? of(BuildContext context) {
    return Localizations.of<MainLocalization>(context, MainLocalization);
  }

  Map<String, String>? _localizedValues;

  Future load() async {
    String jsonStringValues = await rootBundle
        .loadString('lib/languages/${locale.languageCode}.json');

    Map<String, dynamic> mappedJson = json.decode(jsonStringValues);

    _localizedValues =
        mappedJson.map((key, value) => MapEntry(key, value.toString()));
  }

  String? getTranslatedValue(String key) {
    return _localizedValues![key];
  }

  static const LocalizationsDelegate<MainLocalization> delegate =
      _MainLocalizationDelegate();
}

class _MainLocalizationDelegate
    extends LocalizationsDelegate<MainLocalization> {
  const _MainLocalizationDelegate();
  @override
  bool isSupported(Locale locale) {
    return ['en', 'ml'].contains(locale.languageCode);
  }

  @override
  Future<MainLocalization> load(Locale locale) async {
    MainLocalization localization = MainLocalization(locale);
    await localization.load();
    return localization;
  }

  @override
  bool shouldReload(_MainLocalizationDelegate old) => false;
}
