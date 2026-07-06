import 'package:flutter/material.dart';
import 'dart:async';
import 'game_logic.dart';
import 'localization.dart';

class GameScreen extends StatefulWidget {
  final String op;
  final bool isPro;
  final String lang;

  const GameScreen({super.key, required this.op, required this.isPro, required this.lang});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _ThemeColors {
  static const Color background = Color(0xFF0F1016);
  static const Color cardBg = Color(0xFF181A26);
  static const Color accent = Color(0xFFFFB800);
}

class _GameScreenState extends State<GameScreen> {
  final GameLogic _logic = GameLogic();
  final TextEditingController _controller = TextEditingController();
  
  int num1 = 0;
  int num2 = 0;
  int correctAnswer = 0;
  int score = 0;
  int currentLevel = 1;
  int timeLeft = 15;
  Timer? _timer;

  List<Map<String, int>> history = [];
  int historyIndex = -1;

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
  }

  void _startTimer() {
    _timer?.cancel();
    timeLeft = 15;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > 0) {
        setState(() => timeLeft--);
      } else {
        _processAnswer(isTimeout: true);
      }
    });
  }

  void _generateNewProblem() {
    var problem = _logic.generateMathProblem(widget.op, widget.isPro, currentLevel);
    setState(() {
      num1 = problem['num1']!;
      num2 = problem['num2']!;
      correctAnswer = problem['correctAnswer']!;
      history.add(problem);
      historyIndex = history.length - 1;
    });
    _startTimer();
  }

  void _processAnswer({bool isTimeout = false}) {
    int userAnswer = int.tryParse(_controller.text) ?? -999999;
    _controller.clear();

    setState(() {
      if (!isTimeout && userAnswer == correctAnswer) {
        score += 2;
        if (currentLevel < 100) currentLevel++;
      } else {
        score -= 1;
      }
    });

    _generateNewProblem();
  }

  void _navigateHistory(bool goBack) {
    if (goBack && historyIndex > 0) {
      setState(() {
        historyIndex--;
        num1 = history[historyIndex]['num1']!;
        num2 = history[historyIndex]['num2']!;
        correctAnswer = history[historyIndex]['correctAnswer']!;
      });
      _timer?.cancel();
    } else if (!goBack && historyIndex < history.length - 1) {
      setState(() {
        historyIndex++;
        num1 = history[historyIndex]['num1']!;
        num2 = history[historyIndex]['num2']!;
        correctAnswer = history[historyIndex]['correctAnswer']!;
      });
      if (historyIndex == history.length - 1) _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _ThemeColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Level $currentLevel / 100", 
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20)
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Score & Timer Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _ThemeColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${AppStrings.getLabel('score', widget.lang)}: $score", 
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _ThemeColors.accent)
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: _ThemeColors.cardBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      "${AppStrings.getLabel('time', widget.lang)}: ${timeLeft}s", 
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: timeLeft < 5 ? Colors.redAccent : Colors.greenAccent)
                    ),
                  ),
                ],
              ),
              const Spacer(),
              
              // New Box Layout design exactly like Dashboard Grid Items
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: _ThemeColors.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.05), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    )
                  ]
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$num1", 
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)
                        ),
                        const SizedBox(width: 16),
                        Text(
                          widget.op, 
                          style: const TextStyle(fontSize: 40, color: _ThemeColors.accent, fontWeight: FontWeight.bold)
                        ),
                        const SizedBox(width: 16),
                        Text(
                          "$num2", 
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1)
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: _ThemeColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: _ThemeColors.accent.withOpacity(0.3), width: 1.5)
                      ),
                      child: TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(signed: true, decimal: false),
                        autofocus: true,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 36, color: _ThemeColors.accent, fontWeight: FontWeight.bold),
                        decoration: const InputDecoration(
                          hintText: "?",
                          hintStyle: TextStyle(color: Colors.white24),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),

              // Submit Button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _ThemeColors.accent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  onPressed: () => _processAnswer(),
                  child: Text(
                    AppStrings.getLabel('submit', widget.lang), 
                    style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Bottom Navigation Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, size: 24, color: Colors.white54),
                    onPressed: () => _navigateHistory(true),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      AppStrings.getLabel('back_home', widget.lang), 
                      style: const TextStyle(color: Colors.redAccent, fontSize: 15, fontWeight: FontWeight.w600)
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 24, color: Colors.white54),
                    onPressed: () => _navigateHistory(false),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

