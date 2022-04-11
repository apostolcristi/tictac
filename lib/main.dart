import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: GameScreen(),
    );
  }
}

class Player {
  static const String x = 'X';
  static const String o = 'O';
  static const String empty = '';
}

class Game {
  static const int boardCount = 9;
  static const double blocSize = 100;

  List<String>? board;

  static List<String>? initGameBoard() => List<String>.generate(boardCount, (int index) => Player.empty);

  bool winnerCheck(String player, int index, List<int> scoreboard, int gridSize) {
    final int row = index ~/ 3;
    final int col = index % 3;
    final int score = player == 'X' ? 1 : -1;

    scoreboard[row] += score;
    scoreboard[gridSize + col] += score;
    if (row == col) {
      scoreboard[2 * gridSize] += score;
    }
    if (gridSize - 1 - col == row) {
      scoreboard[2 * gridSize + 1] += score;
    }

    if (scoreboard.contains(3) || scoreboard.contains(-3)) {
      return true;
    }
    return false;
  }
}

class GameScreen extends StatefulWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  GameScreenState createState() => GameScreenState();
}

class GameScreenState extends State<GameScreen> {
  String lastValue = 'X';
  bool gameOver = false;
  int turn = 0;
  String result = '';
  List<int> scoreboard = <int>[0, 0, 0, 0, 0, 0, 0, 0];

  Game game = Game();

  @override
  void initState() {
    super.initState();
    game.board = Game.initGameBoard();
  }

  @override
  Widget build(BuildContext context) {
    final double boardWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Center(
          child: Text('tic-tac-toe'),
        ),
      ),
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "It's $lastValue turn".toUpperCase(),
            style: const TextStyle(
              color: Colors.deepPurple,
              fontSize: 56,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: boardWidth,
            height: boardWidth,
            child: GridView.count(
              crossAxisCount: Game.boardCount ~/ 3,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              children: List<Widget>.generate(Game.boardCount, (int index) {
                return InkWell(
                  onTap: gameOver
                      ? null
                      : () {
                          if (game.board![index] == '') {
                            setState(() {
                              game.board![index] = lastValue;
                              turn++;
                              gameOver = game.winnerCheck(lastValue, index, scoreboard, 3);

                              if (gameOver) {
                                result = '$lastValue is the Winner';
                              } else if (!gameOver && turn == 9) {
                                result = "It's a Draw!";
                                gameOver = true;
                              }
                              if (lastValue == 'X') {
                                lastValue = 'O';
                              } else {
                                lastValue = 'X';
                              }
                            });
                          }
                        },
                  child: Container(
                    width: Game.blocSize,
                    height: Game.blocSize,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Text(
                        game.board![index],
                        style: TextStyle(
                          color: game.board![index] == 'X' ? Colors.blue : Colors.pink,
                          fontSize: 64,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
          Text(
            result,
            style: const TextStyle(color: Colors.blue, fontSize: 54),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                //erase the board
                game.board = Game.initGameBoard();
                lastValue = 'X';
                gameOver = false;
                turn = 0;
                result = '';
                scoreboard = <int>[0, 0, 0, 0, 0, 0, 0, 0];
              });
            },
            icon: const Icon(Icons.replay),
            label: const Text('Play again'),
          ),
        ],
      ),
    );
  }
}
