import 'package:flutter/material.dart';
import 'package:flutter_challenge/widgets/game_logic.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _gameOver = false;
  bool _isSwitched = false;
  int _turn = 0;
  String _activePlayer = 'X';
  String _resultText = '';
  Game game = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Column(
                    children: [
                      ..._firstBlock(),
                      _expandedGridView(),
                      ..._secondBlock(),
                    ],
                  )
                  : Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [..._firstBlock(), ..._secondBlock()],
                        ),
                      ),
                      _expandedGridView(),
                    ],
                  ),
        ),
      ),
    );
  }

  List<Widget> _firstBlock() {
    return [_switcheButton(), Turn(activePlayer: _activePlayer)];
  }

  List<Widget> _secondBlock() {
    return [Result(resultText: _resultText), _resetButton()];
  }

  Widget _switcheButton() {
    return SwitchListTile.adaptive(
      title: Text(
        'Turn On/Off two player mode',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      value: _isSwitched,
      onChanged: (value) {
        setState(() {
          _isSwitched = value;
        });
      },
    );
  }

  Widget _resetButton() {
    return Container(
      width:
          MediaQuery.of(context).orientation == Orientation.portrait
              ? double.infinity
              : 300,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.blueAccent,
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            Player.playerX.clear();
            Player.playerO.clear();
            _gameOver = false;
            _turn = 0;
            _activePlayer = 'X';
            _resultText = '';
          });
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.replay, size: 30),
            const SizedBox(width: 10),
            Text(
              'Repeat the Game',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandedGridView() {
    return Expanded(
      child: GridView.count(
        padding:
            MediaQuery.of(context).orientation == Orientation.portrait
                ? const EdgeInsets.all(16)
                : const EdgeInsets.all(50),
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
        children: List.generate(9, (index) {
          return InkWell(
            onTap: _gameOver ? null : () => _onTap(index),
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).shadowColor,
              ),
              child: Center(
                child: Text(
                  Player.playerX.contains(index)
                      ? 'X'
                      : Player.playerO.contains(index)
                      ? 'O'
                      : '',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color:
                        Player.playerX.contains(index)
                            ? Colors.blue
                            : Colors.red,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  _onTap(int index) {
    if ((Player.playerX.isEmpty || !Player.playerX.contains(index)) &&
        (Player.playerO.isEmpty || !Player.playerO.contains(index))) {
      game.playGame(index, _activePlayer);
      _updateState();
      if (!_isSwitched && !_gameOver && _turn != 9) {
        game.autoPlay(_activePlayer).then((_) {
          _updateState();
        });
      }
    }
  }

  void _updateState() {
    setState(() {
      _activePlayer = _activePlayer == 'X' ? 'O' : 'X';
      _turn++;
    });
    String winnerPlayer = game.checkWinner();
    if (winnerPlayer != '') {
      _gameOver = true;
      _resultText = 'WINNER IS $winnerPlayer';
    } else if (!_gameOver && _turn == 9) {
      _resultText = 'IT\'S TURN! Draw!';
    }
  }
}

class Turn extends StatelessWidget {
  const Turn({super.key, required String activePlayer})
    : _activePlayer = activePlayer;

  final String _activePlayer;

  @override
  Widget build(BuildContext context) {
    return Text(
      'IT\'S TURN! $_activePlayer',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}

class Result extends StatelessWidget {
  const Result({super.key, required String resultText})
    : _resultText = resultText;

  final String _resultText;

  @override
  Widget build(BuildContext context) {
    return Text(
      _resultText,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 48),
    );
  }
}
