import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() {
  runApp(const InternationalMathGame());
}

class InternationalMathGame extends StatefulWidget {
  const InternationalMathGame({super.key});

  @override
  State<InternationalMathGame> createState() => _InternationalMathGameAppState();
}

class _InternationalMathGameAppState extends State<InternationalMathGame> {
  String currentLang = 'en';

  // ६ भाषांचे डिक्शनरी भाषांतर - सर्व शुद्ध आणि एरर-फ्री
  final Map<String, Map<String, String>> localizedText = {
    'en': {
      'start': 'START GAME', 'select_mode': 'Select Mode', 'custom': 'Parents Custom Math',
      'easy': 'Easy (1 Digit)', 'hard': 'Hard (Multi Digit)', 'score': 'Score', 'time': 'Time',
      'back': 'Back', 'submit': 'Submit Question', 'enter_n1': 'Enter Number 1', 'enter_n2': 'Enter Number 2',
      'parent_title': 'Custom Math Setup', 'correct': '🎉 Correct!', 'wrong': '❌ Wrong!', 'timeout': '⏰ Time Out!'
    },
    'mr': {
      'start': 'गेम सुरू करा', 'select_mode': 'मोड निवडा', 'custom': 'आई-बाबा स्पेशल गणित',
      'easy': 'सोपी लेव्हल (१ अंकी)', 'hard': 'अवघड लेव्हल (२/३ अंकी)', 'score': 'स्कोअर', 'time': 'वेळ',
      'back': 'मागे', 'submit': 'गणित तयार करा', 'enter_n1': 'पहिली संख्या टाका', 'enter_n2': 'दुसरी संख्या टाका',
      'parent_title': 'पालकांसाठी सेटिंग्ज', 'correct': '🎉 शाब्बास! बरोबर!', 'wrong': '❌ चूक झाली!', 'timeout': '⏰ वेळ संपली!'
    },
    'hi': {
      'start': 'खेल शुरू करें', 'select_mode': 'मोड चुनें', 'custom': 'माता-पिता स्पेशल गणित',
      'easy': 'आसान लेवल (1 अंक)', 'hard': 'कठिन लेवल (2/3 अंक)', 'score': 'स्कोर', 'time': 'समय',
      'back': 'पीछे', 'submit': 'सवाल सेट करें', 'enter_n1': 'पहली संख्या', 'enter_n2': 'दूसरी संख्या',
      'parent_title': 'पेरेंट्स सेटअप', 'correct': '🎉 सही उत्तर!', 'wrong': '❌ गलत उत्तर!', 'timeout': '⏰ समय समाप्त!'
    },
    'ja': {
      'start': 'ゲームスタート', 'select_mode': 'モード選択', 'custom': '保護者カスタム数学',
      'easy': 'かんたん (1桁)', 'hard': 'むずかしい (複数桁)', 'score': 'スコア', 'time': '時間',
      'back': '戻る', 'submit': '質問を送信', 'enter_n1': '数 1 を入力', 'enter_n2': '数 2 を入力',
      'parent_title': 'カスタム設定', 'correct': '🎉 正解！', 'wrong': '❌ 不正解！', 'timeout': '⏰ 時間切れ！'
    },
    'es': {
      'start': 'INICIAR JUEGO', 'select_mode': 'Seleccionar Modo', 'custom': 'Matemáticas de Padres',
      'easy': 'Fácil (1 Dígito)', 'hard': 'Difícil (Multi Dígito)', 'score': 'Puntuación', 'time': 'Tiempo',
      'back': 'Atrás', 'submit': 'Enviar Pregunta', 'enter_n1': 'Número 1', 'enter_n2': 'Número 2',
      'parent_title': 'Configuración de Padres', 'correct': '🎉 ¡Correcto!', 'wrong': '❌ ¡Incorrecto!', 'timeout': '⏰ ¡Tiempo Terminado!'
    },
    'zh': {
      'start': '开始游戏', 'select_mode': '选择模式', 'custom': '家长自定数学',
      'easy': '简单 (1位数)', 'hard': '困难 (多位数)', 'score': '分数', 'time': '时间',
      'back': '返回', 'submit': '提交题目', 'enter_n1': '输入数字 1', 'enter_n2': '输入数字 2',
      'parent_title': '家长设置', 'correct': '🎉 回答正确！', 'wrong': '❌ 回答错误！', 'timeout': '⏰ 时间到！'
    }
  };

  void changeLanguage(String langCode) {
    setState(() { currentLang = langCode; });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Rush Global',
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xFF0A0A0F)),
      home: MainStartScreen(localizedText: localizedText, currentLang: currentLang, onLangChange: changeLanguage),
    );
  }
}

// ---- १. मुख्य पहिली स्क्रीन ----
class MainStartScreen extends StatelessWidget {
  final Map<String, Map<String, String>> localizedText;
  final String currentLang;
  final Function(String) onLangChange;

  const MainStartScreen({super.key, required this.localizedText, required this.currentLang, required this.onLangChange});

  @override
  Widget build(BuildContext context) {
    String t(String key) => localizedText[currentLang]![key]!;

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.language, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: currentLang,
                  dropdownColor: const Color(0xFF1E1E2F),
                  underline: Container(),
                  items: const [
                    DropdownMenuItem<String>(value: 'en', child: Text('English')),
                    DropdownMenuItem<String>(value: 'mr', child: Text('मराठी')),
                    DropdownMenuItem<String>(value: 'hi', child: Text('हिन्दी')),
                    DropdownMenuItem<String>(value: 'ja', child: Text('日本語')),
                    DropdownMenuItem<String>(value: 'es', child: Text('Español')),
                    DropdownMenuItem<String>(value: 'zh', child: Text('中文')),
                  ],
                  onChanged: (String? val) { if (val != null) onLangChange(val); },
                ),
              ],
            ),
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    height: 150,
                    width: 150,
                    color: const Color(0xFF1E1E2F),
                    child: const Icon(Icons.workspace_premium_rounded, size: 100, color: Colors.amber),
                  ),
                ),
                const SizedBox(height: 24),
                const Text('MATH RUSH', style: TextStyle(fontSize: 42, fontWeight: FontWeight.bold, letterSpacing: 4)),
                const SizedBox(height: 4),
                const Text('GLOBAL EDITION', style: TextStyle(fontSize: 12, color: Colors.amber, letterSpacing: 2)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  minimumSize: const Size(double.infinity, 70),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 10,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ModeSelectionScreen(localizedText: localizedText, currentLang: currentLang)),
                  );
                },
                child: Text(t('start'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.black, color: Colors.black)),
              ),
            ),
            const Text("hk_production • Kids Special", style: TextStyle(color: Colors.white12, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ---- २. मोड सिलेक्शन स्क्रीन ----
class ModeSelectionScreen extends StatelessWidget {
  final Map<String, Map<String, String>> localizedText;
  final String currentLang;

  const ModeSelectionScreen({super.key, required this.localizedText, required this.currentLang});

  @override
  Widget build(BuildContext context) {
    String t(String key) => localizedText[currentLang]![key]!;

    return Scaffold(
      appBar: AppBar(title: Text(t('select_mode')), backgroundColor: const Color(0xFF0A0A0F), elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E2F), padding: const EdgeInsets.all(20)),
                  onPressed: () => showLevelDialog(context, '+'),
                  child: const Text('+', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E2F), padding: const EdgeInsets.all(20)),
                  onPressed: () => showLevelDialog(context, '-'),
                  child: const Text('-', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.blue)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E2F), padding: const EdgeInsets.all(20)),
                  onPressed: () => showLevelDialog(context, '×'),
                  child: const Text('×', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.amber)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1E1E2F), padding: const EdgeInsets.all(20)),
                  onPressed: () => showLevelDialog(context, '÷'),
                  child: const Text('÷', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.red)),
                ),
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D2D44),
                minimumSize: const Size(double.infinity, 65),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              icon: const Icon(Icons.security_rounded, color: Colors.amber),
              label: Text(t('custom'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ParentsSetupScreen(localizedText: localizedText, currentLang: currentLang)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void showLevelDialog(BuildContext context, String op) {
    String t(String key) => localizedText[currentLang]![key]!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E2F),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('${t('select_mode')} ($op)', textAlign: TextAlign.center),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => GameplayScreen(op: op, isHard: false, localizedText: localizedText, currentLang: currentLang)));
            },
            child: Text(t('easy'), style: const TextStyle(color: Colors.green, fontSize: 16)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (context) => GameplayScreen(op: op, isHard: true, localizedText: localizedText, currentLang: currentLang)));
            },
            child: Text(t('hard'), style: const TextStyle(color: Colors.red, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}

// ---- ३. मुख्य गेमप्ले स्क्रीन ----
class GameplayScreen extends StatefulWidget {
  final String op;
  final bool isHard;
  final Map<String, Map<String, String>> localizedText;
  final String currentLang;
  final bool isCustom;
  final int? customN1;
  final int? customN2;

  const GameplayScreen({
    super.key, required this.op, required this.isHard, required this.localizedText, required this.currentLang,
    this.isCustom = false, this.customN1, this.customN2
  });

  @override
  State<GameplayScreen> createState() => _GameplayScreenState();
}

class _GameplayScreenState extends State<GameplayScreen> {
  int score = 0;
  late int num1, num2, correctAns;
  List<int> options = [];
  int timeLeft = 15;
  Timer? gameTimer;

  @override
  void initState() {
    super.initState();
    startNewRound();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    gameTimer?.cancel();
    timeLeft = 15;
    gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (timeLeft > 0) {
          timeLeft--;
        } else {
          timer.cancel();
          handleTimeout();
        }
      });
    });
  }

  void handleTimeout() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(widget.localizedText[widget.currentLang]!['timeout']!, style: const TextStyle(fontSize: 18, color: Colors.white)),
      backgroundColor: Colors.orange, duration: const Duration(milliseconds: 600),
    ));
    if (!widget.isCustom) {
      Future.delayed(const Duration(milliseconds: 600), () => setState(() { startNewRound(); }));
    } else {
      Navigator.pop(context);
    }
  }

  void startNewRound() {
    if (widget.isCustom) {
      num1 = widget.customN1!;
      num2 = widget.customN2!;
    } else {
      final random = Random();
      int maxRange = widget.isHard ? 100 : 10;
      num1 = random.nextInt(maxRange) + (widget.isHard ? 10 : 1);
      num2 = random.nextInt(widget.isHard ? 50 : 9) + 1;
    }

    if (widget.op == '+') correctAns = num1 + num2;
    if (widget.op == '-') {
      if (num1 < num2) { int t = num1; num1 = num2; num2 = t; }
      correctAns = num1 - num2;
    }
    if (widget.op == '×') correctAns = num1 * num2;
    if (widget.op == '÷') {
      correctAns = num1;
      num1 = correctAns * num2;
    }

    final random = Random();
    options = [correctAns, correctAns + random.nextInt(4) + 1, correctAns - random.nextInt(3) - 1, correctAns + 5];
    for (int i = 0; i < options.length; i++) {
      if (options[i] < 0 || (options[i] == correctAns && i != 0)) options[i] = correctAns + i + 2;
    }
    options.shuffle();
    startTimer();
  }

  void checkAnswer(int selected) {
    gameTimer?.cancel();
    bool isCorrect = (selected == correctAns);
    
    setState(() {
      if (isCorrect) {
        score += 10;
      } else {
        if (score > 0) score -= 5;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(widget.localizedText[widget.currentLang]![isCorrect ? 'correct' : 'wrong']!, style: const TextStyle(fontSize: 18)),
      backgroundColor: isCorrect ? Colors.green : Colors.red,
      duration: const Duration(milliseconds: 500),
    ));

    Future.delayed(const Duration(milliseconds: 600), () {
      if (widget.isCustom) {
        Navigator.pop(context);
      } else {
        setState(() { startNewRound(); });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String t(String key) => widget.localizedText[widget.currentLang]![key]!;

    return Scaffold(
      appBar: AppBar(title: Text('${t('score')}: $score'), backgroundColor: const Color(0xFF0A0A0F), centerTitle: true, elevation: 0),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            LinearProgressIndicator(value: timeLeft / 15, backgroundColor: Colors.white10, color: timeLeft > 5 ? Colors.amber : Colors.red),
            Text('${t('time')}: $timeLeft s', style: TextStyle(fontSize: 18, color: timeLeft > 5 ? Colors.white70 : Colors.red, fontWeight: FontWeight.bold)),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(color: const Color(0xFF1E1E2F), borderRadius: BorderRadius.circular(24)),
              child: Text('$num1 ${widget.op} $num2 = ?', textAlign: TextAlign.center, style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold)),
            ),
            
            GridView.builder(
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 16, childAspectRatio: 1.3),
              itemCount: options.length,
              itemBuilder: (context, idx) => ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2D2D44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                onPressed: () => checkAnswer(options[idx]),
                child: Text('${options[idx]}', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---- ४. पालकांसाठी स्पेशल स्क्रीन ----
class ParentsSetupScreen extends StatefulWidget {
  final Map<String, Map<String, String>> localizedText;
  final String currentLang;

  const ParentsSetupScreen({super.key, required this.localizedText, required this.currentLang});

  @override
  State<ParentsSetupScreen> createState() => _ParentsSetupScreenState();
}

class _ParentsSetupScreenState extends State<ParentsSetupScreen> {
  final TextEditingController n1Controller = TextEditingController();
  final TextEditingController n2Controller = TextEditingController();
  String selectedOp = '+';

  @override
  Widget build(BuildContext context) {
    String t(String key) => widget.localizedText[widget.currentLang]![key]!;

    return Scaffold(
      appBar: AppBar(title: Text(t('parent_title')), backgroundColor: const Color(0xFF0A0A0F)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(controller: n1Controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: t('enter_n1'), border: const OutlineInputBorder())),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedOp,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              dropdownColor: const Color(0xFF1E1E2F),
              items: const [
                DropdownMenuItem<String>(value: '+', child: Text('बेरीज (+)')),
                DropdownMenuItem<String>(value: '-', child: Text('वजाबाकी (-)')),
                DropdownMenuItem<String>(value: '×', child: Text('गुणाकार (×)')),
                DropdownMenuItem<String>(value: '÷', child: Text('भागाकार (÷)')),
              ],
              onChanged: (String? val) { if (val != null) setState(() { selectedOp = val; }); },
            ),
            const SizedBox(height: 20),
            TextField(controller: n2Controller, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: t('enter_n2'), border: const OutlineInputBorder())),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.all(20)),
              onPressed: () {
                int? n1 = int.tryParse(n1Controller.text);
                int? n2 = int.tryParse(n2Controller.text);
                if (n1 != null && n2 != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GameplayScreen(op: selectedOp, isHard: false, localizedText: widget.localizedText, currentLang: widget.currentLang, isCustom: true, customN1: n1, customN2: n2)),
                  );
                }
              },
              child: Text(t('submit'), style: const TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}
