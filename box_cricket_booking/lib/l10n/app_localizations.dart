import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_name': 'Box Cricket Booking',
      'tagline': 'Book your turf instantly',
      'search_hint': 'Search grounds...',
      'nearby': 'NEARBY YOU',
      'popular': 'POPULAR TURFS',
      'offers': 'SPECIAL OFFERS',
    },
    'hi': {
      'app_name': 'बॉक्स क्रिकेट बुकिंग',
      'tagline': 'अपना टर्फ तुरंत बुक करें',
      'search_hint': 'मैदान खोजें...',
      'nearby': 'आपके पास',
      'popular': 'लोकप्रिय टर्फ',
      'offers': 'विशेष ऑफर',
    },
    'te': {
      'app_name': 'బాక్స్ క్రికెట్ బుకింగ్',
      'tagline': 'మీ టర్ఫ్‌ను వెంటనే బుక్ చేయండి',
      'search_hint': 'మైదానాలను వెతకండి...',
      'nearby': 'మీకు సమీపంలో',
      'popular': 'ప్రసిద్ధ టర్ఫ్‌లు',
      'offers': 'ప్రత్యేక ఆఫర్లు',
    },
  };

  String translate(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
