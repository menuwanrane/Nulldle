class GameModel {
  final String targetWord;   //The word player needs to guess
  final List<String> guesses;   //List of player's guesses
  final int maxGuesses;    // Maximum allowed guesses
  final int wins;          // Total wins
  final int losses;        // Total losses
  final int incorrectGuesses;  // Number of wrong guesses

  GameModel({
    required this.targetWord,
    this.guesses = const [],
    this.maxGuesses = 6,
    this.wins = 0,
    this.losses = 0,
    this.incorrectGuesses = 0,
  });

  GameModel copyWith({
    String? targetWord,
    List<String>? guesses,
    int? maxGuesses,
    int? wins,
    int? losses,
    int? incorrectGuesses,
  }) {
    return GameModel(
      targetWord: targetWord ?? this.targetWord,
      guesses: guesses ?? this.guesses,
      maxGuesses: maxGuesses ?? this.maxGuesses,
      wins: wins ?? this.wins,
      losses: losses ?? this.losses,
      incorrectGuesses: incorrectGuesses ?? this.incorrectGuesses,
    );
  }
}
