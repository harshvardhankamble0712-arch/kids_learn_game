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
    String sign = widget.op;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.home),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Level $currentLevel / 100"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${AppStrings.getLabel('score', widget.lang)}: $score", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                  Text("${AppStrings.getLabel('time', widget.lang)}: ${timeLeft}s", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: timeLeft < 5 ? Colors.red : Colors.green)),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("$num1", style: const TextStyle(fontSize: 55, letterSpacing: 4, fontWeight: FontWeight.bold)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(sign, style: const TextStyle(fontSize: 45, color: Colors.amber, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 20),
                        Text("$num2", style: const TextStyle(fontSize: 55, letterSpacing: 4, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const Divider(color: Colors.white, thickness: 3, height: 20),
                    SizedBox(
                      width: 200,
                      child: TextField(
                        controller: _controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.right,
                        style: const TextStyle(fontSize: 45, color: Colors.amber, fontWeight: FontWeight.bold),
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
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: () => _processAnswer(),
                child: Text(AppStrings.getLabel('submit', widget.lang), style: const TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 35, color: Colors.white54),
                    onPressed: () => _navigateHistory(true),
                  ),
                  TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.exit_to_app, color: Colors.redAccent),
                    label: Text(AppStrings.getLabel('back_home', widget.lang), style: const TextStyle(color: Colors.redAccent, fontSize: 16)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 35, color: Colors.white54),
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
