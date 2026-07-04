import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(const KidsGameApp());
}

class KidsGameApp extends StatelessWidget {
  const KidsGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Rush',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0D0D13),
      ),
      home: const GameHomeScreen(),
    );
  }
}

// ---- १. पहिली नवीन वेलकम स्क्रीन (Home Screen) ----
class GameHomeScreen extends StatelessWidget {
  const GameHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF161623), Color(0xFF0D0D13)],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1E1E2F),
                      border: Border.all(color: Colors.amber.shade600, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.amber.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        )
                      ],
                    ),
                    child: const Icon(
                      Icons.calculate_rounded,
                      size: 80,
                      color: Colors.amber,
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'MATH RUSH',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 4,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'SHARPEN YOUR MIND',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      letterSpacing: 2,
                      color: Colors.amber.shade600,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E2F),
                        minimumSize: const Size(double.infinity, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.white10),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MathGameScreen(startLevel: 1)),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('🚀 START LEVEL 1 ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                          Text('(बेरीज)', style: TextStyle(fontSize: 14, color: Colors.white60)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E1E2F),
                        minimumSize: const Size(double.infinity, 65),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.white10),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MathGameScreen(startLevel: 2)),
                        );
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('⚡ START LEVEL 2 ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.amber)),
                          Text('(वजाबाकी)', style: TextStyle(fontSize: 14, color: Colors.white60)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "hk_production • Quiet Luxury Edition",
                style: TextStyle(color: Colors.white24, fontSize: 11, letterSpacing: 1),
              )
            ],
          ),
        ),
      ),
    );
  }
}

// ---- २. गेम स्क्रीन ----
class MathGameScreen extends StatefulWidget {
  final int startLevel;
  const MathGameScreen({super.key, required this.startLevel});

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  int score = 0;
  late int level;
  late int number1;
  late int number2;
  late int correctAns;
  List<int> options = [];
  String operator = "+";

  @override
  void initState() {
    super.initState();
    level = widget.startLevel;
    startNewRound();
  }

  void startNewRound() {
    final random = Random();
    
    if (level == 2) {
      operator = random.nextBool() ? "+" : "-";
    } else {
      operator = "+";
    }

    number1 = random.nextInt(10 * level) + 2;
    number2 = random.nextInt(10 * level) + 2;

    if (operator == "+") {
      correctAns = number1 + number2;
    } else {
      if (number1 < number2) {
        int temp = number1;
        number1 = number2;
        number2 = temp;
      }
      correctAns = number1 - number2;
    }

    options = [
      correctAns,
      correctAns + random.nextInt(4) + 1,
      correctAns - random.nextInt(3) - 1,
      number1 + 5
    ];
    
    for(int i=0; i<options.length; i++) {
      if(options[i] < 0 || (options[i] == correctAns && i != 0)) {
        options[i] = correctAns + i + 2;
      }
    }
    
    options.shuffle();
  }

  void verifyAnswer(int selectedAnswer) {
    if (selectedAnswer == correctAns) {
      setState(() {
        score += 10;
        if (score >= 50 && level == 1) {
          level = 2;
        }
        startNewRound();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 शाब्बास! बरोबर उत्तर!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.green,
          duration: Duration(milliseconds: 400),
        ),
      );
    } else {
      setState(() {
        if (score > 0) score -= 5;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ चूक झाली, पुन्हा प्रयत्न कर!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          backgroundColor: Colors.red,
          duration: Duration(milliseconds: 400),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MATH RUSH', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2)),
        backgroundColor: const Color(0xFF0D0D13),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(12)),
                  child: Text('🌟 स्कोअर: $score', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: const Color(0xFF1E1E2F), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.white10)),
                  child: Text('🚀 लेव्हल: $level', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2F),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white10, width: 1),
              ),
              child: Text(
                '$number1 $operator $number2 = ?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 2),
              ),
            ),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.3,
              ),
              itemCount: options.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2D44),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 2,
                  ),
                  onPressed: () => verifyAnswer(options[index]),
                  child: Text(
                    '${options[index]}',
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              },
            ),
            if (level == 1)
              const Text(
                "५० स्कोअर झाल्यावर ऑटोमॅटिक लेव्हल २ अनलॉक होईल!",
                style: TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic),
              )
          ],
        ),
      ),
    );
  }
}
