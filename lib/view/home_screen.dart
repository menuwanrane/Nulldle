import 'package:flutter/material.dart';
import 'game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Center(
              child: Text(
                'Nulldle',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 48.0,
                ),
              ),
            ),
            Center(
              child: Image.asset(
                'assets/title.png',
                width: 200,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Guess the hidden five-letter word in just six tries! After each guess, tiles will light up, green means the letter is in the right spot, yellow means the letter is in the word but in the wrong spot, and grey means the letter is not in the word at all.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              },
              child: const Text(
                'Play Game',
                style: TextStyle(
                  fontFamily: 'Courier',
                  color: Colors.pink,
                  fontWeight: FontWeight.bold,
                  fontSize: 24.0,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
