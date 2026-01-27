import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/game_model.dart';

class GameViewModel extends ChangeNotifier {
  late GameModel _game;
  late List<String> _dictionary;
  bool isLoading = true;
  String? errorMessage;
  bool gameWon = false;
  bool gameLost = false;

  //keyboard letter colors
  Map<String, Color> keyboardColors = {
    for (var c in 'QWERTYUIOPASDFGHJKLZXCVBNM'.split(''))
      c: Colors.grey.shade300,
  };

  GameModel get game => _game; //getter for the current game

  //initialize the game and load dictionary
  Future<void> initializeGame() async {
    isLoading = true;
    final dict = await rootBundle.loadString('assets/english_dict.txt');
    _dictionary = dict
        .split('\n')
        .map((w) => w.trim().toLowerCase())
        .where((w) => w.length == 5)
        .toList();

    //Select a random target word
    _game = GameModel(
        targetWord: _dictionary[Random().nextInt(_dictionary.length)]);

    keyboardColors.updateAll((key, _) => Colors.grey.shade300);
    errorMessage = null;
    gameWon = false;
    gameLost = false;
    isLoading = false;
    notifyListeners();
  }

  void submitGuess(String guess) {  //submit a guess
    guess = guess.toLowerCase();
    errorMessage = null;

    if (!_dictionary.contains(guess)) {
      errorMessage = "Not a valid word!";
      notifyListeners();
      return;
    }

    //prevent repeated guess
    if (_game.guesses.contains(guess)) {
      errorMessage = "You already guessed that word!";
      notifyListeners();
      return;
    }

    final updatedGuesses = [..._game.guesses, guess];
    int incorrect = _game.incorrectGuesses; 
    if (guess != _game.targetWord) incorrect++; //increment incorrect count if guess is incorrect

    _game = _game.copyWith(
      guesses: updatedGuesses,
      incorrectGuesses: incorrect, //update game stats
    );
    _updateKeyboard(guess);

    if (guess == _game.targetWord) {
      gameWon = true;
      _game = _game.copyWith(wins: _game.wins + 1); //Increment wins
    } else if (_game.guesses.length >= _game.maxGuesses) {
      gameLost = true;
      _game = _game.copyWith(losses: _game.losses + 1); //Increment losses
    }

    notifyListeners();
  }

  //reset current game
  void resetGame() {
    _game = GameModel(
      targetWord: _dictionary[Random().nextInt(_dictionary.length)],
      wins: _game.wins,
      losses: _game.losses,
      incorrectGuesses: 0,
    ); //incorrect guseese per game, so it resets for new games
    keyboardColors.updateAll((key, _) => Colors.grey.shade300);   //reset keyboard
    errorMessage = null;
    gameWon = false;
    gameLost = false;
    notifyListeners();
  }

  void clearError() {
    errorMessage = null;
    notifyListeners();
  }

  //get tile color for a letter in a guess
  Color tileColor(String guess, int index) {
    if (_game.targetWord[index] == guess[index]) return Colors.green;
    if (_game.targetWord.contains(guess[index])) return Colors.yellow;
    return Colors.grey;
  }

  //update keyboard colos based on guess
  void _updateKeyboard(String guess) {
    for (int i = 0; i < guess.length; i++) {
      String letter = guess[i].toUpperCase();
      Color newColor = tileColor(guess, i);

      if (keyboardColors[letter] == Colors.green) continue;
      if (keyboardColors[letter] == Colors.yellow && newColor == Colors.grey) {
        continue;
      }

      keyboardColors[letter] = newColor;
    }
  }

  //reste all stats including wins, losses and incorrect gueeses
  void resetStats() {
    _game = _game.copyWith(wins: 0, losses: 0, incorrectGuesses: 0);
    notifyListeners();
  }
}
