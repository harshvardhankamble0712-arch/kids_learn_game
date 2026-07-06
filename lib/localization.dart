class AppStrings {
  static String getLabel(String key, String lang) {
    Map<String, Map<String, String>> localizedStrings = {
      'English': {
        'title': 'MATH ELITE',
        'start': 'START GAME',
        'basic': 'Basic (1-2 Digits)',
        'pro': 'Pro (3-5 Digits)',
        'submit': 'SUBMIT',
        'score': 'Score',
        'time': 'Time',
        'back_home': 'Back to Home',
      },
      'Marathi': {
        'title': 'मॅथ एलिट',
        'start': 'गेम सुरू करा',
        'basic': 'बेसिक (१-२ अंकी)',
        'pro': 'प्रो (३-५ अंकी)',
        'submit': 'सबमिट करा',
        'score': 'गुण',
        'time': 'वेळ',
        'back_home': 'मुख्य स्क्रीनवर जा',
      },
      'Hindi': {
        'title': 'मैथ एलिट',
        'start': 'गेम शुरू करें',
        'basic': 'बेसिक (१-२ अंकी)',
        'pro': 'प्रो (३-५ अंकी)',
        'submit': 'जमा करें',
        'score': 'अंक',
        'time': 'समय',
        'back_home': 'मुख्य स्क्रीन पर जाएं',
      },
      'French': {
        'title': 'MATH ELITE',
        'start': 'DÉMARRER',
        'basic': 'Basique (1-2 chiffres)',
        'pro': 'Pro (3-5 chiffres)',
        'submit': 'SOUMETTRE',
        'score': 'Score',
        'time': 'Temps',
        'back_home': 'Accueil',
      },
      'German': {
        'title': 'MATH ELITE',
        'start': 'SPIEL STARTEN',
        'basic': 'Basis (1-2 Ziffern)',
        'pro': 'Pro (3-5 Ziffern)',
        'submit': 'BESTÄTIGEN',
        'score': 'Ergebnis',
        'time': 'Zeit',
        'back_home': 'Startseite',
      },
      'Spanish': {
        'title': 'MATH ELITE',
        'start': 'INICIAR JUEGO',
        'basic': 'Básico (1-2 dígitos)',
        'pro': 'Pro (3-5 dígitos)',
        'submit': 'ENVIAR',
        'score': 'Puntuación',
        'time': 'Tiempo',
        'back_home': 'Inicio',
      }
    };
    return localizedStrings[lang]?[key] ?? localizedStrings['English']![key]!;
  }
}
