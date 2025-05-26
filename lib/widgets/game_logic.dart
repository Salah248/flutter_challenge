class Player {
  static const x = 'X';
  static const o = 'O';
  static const empty = '';

  static List<int> playerX = [];
  static List<int> playerO = [];
}

class Game {
  void playGame(int index, String activePlayer) {
    if (activePlayer == Player.x) {
      Player.playerX.add(index);
    } else {
      Player.playerO.add(index);
    }
  }

  checkWinner() {}
  autoPlay() {}
}
