import 'dart:math';

class GameLogic {
  final Random _random = Random();

  Map<String, int> generateMathProblem(String operation, bool isPro, int currentLevel) {
    // लेव्हल जितकी जास्त असेल, तितके गणित कठीण होत जाणार
    int multiplier = 1 + (currentLevel ~/ 10); 
    
    int maxRange = isPro ? (99999 * multiplier).clamp(10000, 99999) : (99 * multiplier).clamp(10, 99);
    int minRange = isPro ? 100 : 1;

    int num1 = _random.nextInt(maxRange - minRange) + minRange;
    int num2 = _random.nextInt(maxRange - minRange) + minRange;

    if (operation == '-' && num1 < num2) {
      int temp = num1;
      num1 = num2;
      num2 = temp;
    }

    if (operation == '÷') {
      int answer = _random.nextInt(isPro ? 100 : 10) + 1;
      num1 = answer * num2; 
    }

    int correctAnswer = 0;
    if (operation == '+') correctAnswer = num1 + num2;
    if (operation == '-') correctAnswer = num1 - num2;
    if (operation == '×') correctAnswer = num1 * num2;
    if (operation == '÷') correctAnswer = num1 ~/ num2;

    return {
      'num1': num1,
      'num2': num2,
      'correctAnswer': correctAnswer,
    };
  }
}
