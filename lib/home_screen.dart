import 'package:flutter/material.dart';
import 'localization.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedLang = 'English';
  final List<String> languages = ['English', 'Marathi', 'Hindi', 'French', 'German', 'Spanish'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.getLabel('title', selectedLang)),
        actions: [
          DropdownButton<String>(
            value: selectedLang,
            dropdownColor: const Color(0xFF151522),
            items: languages.map((l) => DropdownMenuItem(value: l, child: Text(l))).toList(),
            onChanged: (v) => setState(() => selectedLang = v!),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _opCard('+', Colors.green),
                  _opCard('-', Colors.blue),
                  _opCard('×', Colors.amber),
                  _opCard('÷', Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _opCard(String op, Color color) => InkWell(
    onTap: () => _showLevelDialog(op),
    child: Card(
      color: color.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: color, width: 1)),
      child: Center(child: Text(op, style: TextStyle(fontSize: 60, color: color, fontWeight: FontWeight.bold))),
    ),
  );

  void _showLevelDialog(String op) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF151522),
        title: Text("Select Mode", style: const TextStyle(color: Colors.white)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen(op: op, isPro: false, lang: selectedLang)));
            },
            child: Text(AppStrings.getLabel('basic', selectedLang), style: const TextStyle(color: Colors.amber)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(context, MaterialPageRoute(builder: (_) => GameScreen(op: op, isPro: true, lang: selectedLang)));
            },
            child: Text(AppStrings.getLabel('pro', selectedLang), style: const TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
