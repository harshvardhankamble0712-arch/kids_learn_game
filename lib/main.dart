              import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const MathEliteApp());
}

class MathEliteApp extends StatelessWidget {
  const MathEliteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Math Elite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF090A0F), // Premium Deep Black
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF), // Neon Cyan
          secondary: Color(0xFFFF3D00), // Electric Orange
          surface: Color(0xFF141622), // Sleek Card Background
        ),
      ),
      home: const MathEliteGame(),
    );
  }
}

class MathEliteGame extends StatefulWidget {
  const MathEliteGame({super.key});

  @override
  State<MathEliteGame> createState() => _MathEliteGameState();
}

class _MathEliteGameState extends State<MathEliteGame> {
  int _score = 0;
  int _highestScore = 0;
  late int _num1, _num2;
  late String _operator;
  late int _correctAnswer;
  List<int> _options = [];
  
  int _timeLeft = 5; // ५ सेकंदांचे कडक चॅलेंज
  Timer? _timer;
  bool _isGameOver = false;

  @override
  void initState() {
    super.initState();
    _generateNewQuestion();
  }

  void _startTimer() {
    _timer?.cancel();
    _timeLeft = 5;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeLeft > 0) {
          _timeLeft--;
        } else {
          _timer?.cancel();
          _isGameOver = true;
        }
      });
    });
  }

  void _generateNewQuestion() {
    final random = Random();
    // लहान मुलांसाठी आणि मोठ्यांसाठी बॅलन्स नंबर्स (१ ते २०)
    _num1 = random.nextInt(15) + 2;
    _num2 = random.nextInt(12) + 2;
    
    List<String> operators = ['+', '-', '×'];
    _operator = operators[random.nextInt(operators.length)];

    if (_operator == '+') {
      _correctAnswer = _num1 + _num2;
    } else if (_operator == '-') {
      // उत्तर मायनसमध्ये येऊ नये म्हणून
      if (_num1 < _num2) {
        int temp = _num1;
        _num1 = _num2;
        _num2 = temp;
      }
      _correctAnswer = _num1 - _num2;
    } else {
      _correctAnswer = _num1 * _num2;
    }

    // ४ चुकीचे आणि बरोबर ऑप्शन्स तयार करणे
    _options = [_correctAnswer];
    while (_options.length < 4) {
      int wrongAns = _correctAnswer + random.nextInt(10) - 5;
      if (!_options.contains(wrongAns) && wrongAns >= 0) {
        _options.add(wrongAns);
      }
    }
    _options.shuffle(); // ऑप्शन्स मिक्स करणे
    _startTimer();
  }

  void _checkAnswer(int selectedAnswer) {
    if (_isGameOver) return;

    if (selectedAnswer == _correctAnswer) {
      setState(() {
        _score++;
        if (_score > _highestScore) {
          _highestScore = _score;
        }
        _generateNewQuestion();
      });
    } else {
      _timer?.cancel();
      setState(() {
        _isGameOver = true;
      });
    }
  }

  void _restartGame() {
    setState(() {
      _score = 0;
      _isGameOver = false;
      _generateNewQuestion();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MATH ELITE", style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.black)),
        centerTitle: true,
        backgroundColor: const Color(0xFF141622),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // स्कोअर बोर्ड आणि टाइमर
            Row(
              mainAxisAlignment: MainAxisAlignment.between,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("SCORE: $_score", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF00E5FF))),
                    Text("BEST: $_highestScore", style: const TextStyle(fontSize: 14, color: Colors.white54)),
                  ],
                ),
                // वर्तुळाकार निऑन टाइमर
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        value: _timeLeft / 5,
                        strokeWidth: 5,
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF3D00)),
                      ),
                    ),
                    Text("$_timeLeft", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                )
              ],
            ),

            // मुख्य गेम स्क्रीन (प्रश्न किंवा गेम ओव्हर स्क्रीन)
            Expanded(
              child: Center(
                child: _isGameOver
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.gavel_rounded, size: 80, color: Color(0xFFFF3D00)),
                          const SizedBox(height: 16),
                          const Text("GAME OVER", style: TextStyle(fontSize: 28, fontWeight: FontWeight.black, color: Color(0xFFFF3D00), letterSpacing: 2)),
                          const SizedBox(height: 8),
                          Text("Your Final Score: $_score", style: const TextStyle(fontSize: 18, color: Colors.white70)),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E5FF),
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                            ),
                            onPressed: _restartGame,
                            icon: const Icon(Icons.refresh),
                            label: const Text("TRY AGAIN", style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      )
                    : Container(
                        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF141622),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFF00E5FF).withOpacity(0.2), width: 1),
                        ),
                        child: Text(
                          "$_num1 $_operator $_num2 = ?",
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 1),
                        ),
                      ),
              ),
            ),

            // ऑप्शन्सची बटन्स (खेळतानाच दिसतील)
            if (!_isGameOver)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.5,
                ),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () => _checkAnswer(_options[index]),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF141622),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Center(
                        child: Text(
                          "${_options[index]}",
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
