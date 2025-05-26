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
  String _resultText = 'xxxxxxxxxx';
  int _currentIndex = 0;
  Game game = Game();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              SwitchListTile.adaptive(
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
              ),
              Text(
                'IT\'S TURN! $_activePlayer',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Expanded(
                child: GridView.count(
                  padding: const EdgeInsets.all(10),
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 10,
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
                            style: Theme.of(
                              context,
                            ).textTheme.bodyLarge!.copyWith(
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
              ),
              Text(
                _resultText,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge!.copyWith(fontSize: 48),
              ),
              Container(
                width: double.infinity,
                height: 60,
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onTap(int index) {
    game.playGame(index, _activePlayer);
    _updateState();
  }

  void _updateState() {
    setState(() {
      _activePlayer = _activePlayer == 'X' ? 'O' : 'X';
    });
  }
}
