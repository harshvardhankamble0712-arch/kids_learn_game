import 'dart:math';

class GameLogic {
  final Random _random = Random();

  // गणिताचे आकडे तयार करणारे फंक्शन
  Map<String, int> generateMathProblem(String operation, bool isPro) {
    int maxRange = isPro ? 99999 : 99; // Pro मध्ये ५ अंकी, Basic मध्ये २ अंकी
    int minRange = isPro ? 100 : 1;    // Pro मध्ये कमीत कमी ३ अंकी

    int num1 = _random.nextInt(maxRange - minRange) + minRange;
    int num2 = _random.nextInt(maxRange - minRange) + minRange;

    // वजाबाकी (Subtraction) मध्ये उत्तर मायनस (-) येऊ नये म्हणून मोठी संख्या वर ठेवणे
    if (operation == '-' && num1 < num2) {
      int temp = num1;
      num1 = num2;
      num2 = temp;
    }

    // भागाकार (Division) सोपा करण्यासाठी
    if (operation == '÷') {
      int answer = _random.nextInt(isPro ? 500 : 20) + 1;
      num1 = answer * num2; // जेणेकरून पूर्ण भाग जाईल
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
