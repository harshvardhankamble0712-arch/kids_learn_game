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
      title: 'Math Rush for Kids',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF1A1A2E),
      ),
      home: const MathGameScreen(),
    );
  }
}

class MathGameScreen extends StatefulWidget {
  const MathGameScreen({super.key});

  @override
  State<MathGameScreen> createState() => _MathGameScreenState();
}

class _MathGameScreenState extends State<MathGameScreen> {
  int score = 0;
  int level = 1;
  late int number1;
  late int number2;
  late int correctAns;
  List<int> options = [];
  String operator = "+";

  @override
  void initState() {
    super.initState();
    startNewRound();
  }

  void startNewRound() {
    final random = Random();
    
    if (score >= 50) {
      level = 2;
      operator = random.nextBool() ? "+" : "-";
    } else {
      level = 1;
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
          content: Text('❌ अरेरे! चूक झाली, पुन्हा प्रयत्न कर!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
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
        title: const Text('➕ MATH RUSH ✖️', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.white)),
        backgroundColor: const Color(0xFF16213E),
        centerTitle: true,
        elevation: 5,
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
                  decoration: BoxDecoration(color: Colors.amber, borderRadius: BorderRadius.circular(15)),
                  child: Text('🌟 स्कोअर: $score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.cyan, borderRadius: BorderRadius.circular(15)),
                  child: Text('🚀 लेव्हल: $level', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
                ),
              ],
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: const Color(0xFF0F3460),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.cyan, width: 2),
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
                    backgroundColor: const Color(0xFFE94560),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 5,
                  ),
                  onPressed: () => verifyAnswer(options[index]),
                  child: Text(
                    '${options[index]}',
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                );
              },
            ),
            const Text(
              "५० स्कोअर झाल्यावर लेव्हल २ अनलॉक होईल!",
              style: TextStyle(color: Colors.white38, fontSize: 12, fontStyle: FontStyle.italic),
            )
          ],
        ),
      ),
    );
  }
}
