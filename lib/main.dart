import 'package:flutter/material.dart';
import 'home_screen.dart'; // आपण बनवलेली होम स्क्रीन इथे जोडली आहे

void main() => runApp(const MathEliteApp());

class MathEliteApp extends StatelessWidget {
  const MathEliteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Math Elite',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        primaryColor: Colors.amber,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // ४ सेकंद लोगो दाखवून गेमच्या होम स्क्रीनवर जाणे
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // तुझा लोगो (अॅसेट्स मधील इमेज)
            Image.asset('assets/IMG-20260704-WA2822.jpg', width: 150),
            const SizedBox(height: 20),
            const Text(
              "MATH ELITE",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 30),
            // लोडिंग बार (शो साठी)
            const SizedBox(
              width: 200,
              child: LinearProgressIndicator(
                color: Colors.amber,
                backgroundColor: Colors.white10,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Loading HK PRODUCTION...",
              style: TextStyle(color: Colors.white54, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
