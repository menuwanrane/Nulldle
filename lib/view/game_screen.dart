import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../view_model/game_view_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<GameViewModel>(context, listen: false).initializeGame();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _showResultDialog({required bool won, required String word}) {
    //Show diolog when game ends
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              won ? ":D" : ":(",
              style: TextStyle(
                fontSize: 64,
                color: won ? Colors.green : Colors.pink,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "The word was: ${word.toUpperCase()}",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: won ? Colors.pink : Colors.black,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Provider.of<GameViewModel>(context, listen: false).resetGame();
              _controller.clear();
            },
            child: Text(
              "New game",
              style: TextStyle(
                fontSize:
                    won ? 24 : 24, //for wins close was 64 font size. fixed it.
                color: Colors.pink,
                fontWeight: FontWeight.bold,
                fontFamily: 'Courier',
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GameViewModel>(
      builder: (context, vm, _) {
        void submitGuess() {
          //guess submit function
          final guess = _controller.text
              .toLowerCase(); //make all lowercase before submission
          _controller.clear();

          vm.submitGuess(guess);

          if (vm.errorMessage != null) {
            _showSnackBar(vm.errorMessage!);
            vm.clearError();
            return;
          }

          if (vm.gameWon) {
            //check if game won or lost to show the message
            _showResultDialog(won: true, word: vm.game.targetWord);
          } else if (vm.gameLost) {
            _showResultDialog(won: false, word: vm.game.targetWord);
            _showSnackBar("Out of guesses! Word was ${vm.game.targetWord}");
          }
        }

        Widget buildKeyboard() {
          //on screen keboard
          const keyboardRows = ["QWERTYUIOP", "ASDFGHJKL", "ZXCVBNM"];
          return Column(
            children: keyboardRows.map((row) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: row.split('').map((letter) {
                  return Flexible(
                    //wrapped keyboard in a flexible to avoid overflowing in some devices.
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      width: 30,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: vm.keyboardColors[letter],
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.black26),
                      ),
                      child: Text(
                        letter,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: vm.isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator()) //to fix not inizialized bug
                  : Column(
                      children: [
                        Text(
                          "Wins: ${vm.game.wins} | Losses: ${vm.game.losses} | Incorrect guesses (this game): ${vm.game.incorrectGuesses}",
                          style: const TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),

                        //////reset button for stats
                        ElevatedButton(
                          onPressed: () {
                            vm.resetStats();
                          },
                          child: const Text("Reset Stats"),
                        ),

                        Flexible(
                          //used flexible to avoid overflowing
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(6, (rowIndex) {
                              String? guess = rowIndex < vm.game.guesses.length
                                  ? vm.game.guesses[rowIndex]
                                  : null;
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(5, (colIndex) {
                                  String letter = '';
                                  Color bgColor = Colors.grey.shade300;
                                  if (guess != null &&
                                      colIndex < guess.length) {
                                    letter = guess[colIndex].toUpperCase();
                                    bgColor = vm.tileColor(guess, colIndex);
                                  }
                                  return Container(
                                    margin: const EdgeInsets.all(4.0),
                                    width: 48,
                                    height: 48,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.black26),
                                    ),
                                    child: Text(
                                      letter,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }),
                              );
                            }),
                          ),
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: _controller,
                                maxLines: 1,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: "Enter your guess",
                                ),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Container(
                              //added a clear button to easily clear letter after typing
                              width: 40,
                              height: 54,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade700,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: const Color.fromARGB(66, 0, 0, 0)),
                              ),
                              child: InkWell(
                                onTap: () {
                                  if (_controller.text.isNotEmpty) {
                                    setState(() {
                                      _controller.text = _controller.text
                                          .substring(
                                              0, _controller.text.length - 1);
                                    });
                                  }
                                },
                                child: const Text(
                                  "⌫",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Courier',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: submitGuess,
                              child: const Text(
                                "Submit",
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            ElevatedButton(
                              onPressed: () {
                                _showResultDialog(
                                    won: false, word: vm.game.targetWord);
                                _showSnackBar(
                                    "Game reset. Word was ${vm.game.targetWord}");
                              },
                              child: const Text(
                                "New Game",
                                style: TextStyle(
                                  fontFamily: 'Courier',
                                  color: Colors.pink,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        buildKeyboard(),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}
