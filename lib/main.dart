import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'view_model/game_view_model.dart';
import 'view/home_screen.dart';

class WordleApp extends StatelessWidget {
  const WordleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => GameViewModel()..initializeGame(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.pink  //Primary theme color
          ),
        home: const HomeScreen(),    // Set main screen
      ),
    );
  }
}

void main() {
  runApp(const WordleApp());
}
