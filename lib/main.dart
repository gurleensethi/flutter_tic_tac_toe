import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tact Toe',
      home: Home(),
    );
  }
}

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Center(
        child: Game(),
      ),
    );
  }
}

class Square extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const Square({
    Key key,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTap,
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          border: Border.all(),
        ),
        child: Center(
          child: Text(this.text ?? ""),
        ),
      ),
    );
  }
}

class Board extends StatelessWidget {
  final List<String> data;
  final void Function(int index) onTap;

  const Board({
    Key key,
    this.data,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      child: GridView.builder(
        itemCount: 9,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          return Square(
            onTap: () => this.onTap(index),
            text: this.data[index],
          );
        },
      ),
    );
  }
}

class Game extends StatefulWidget {
  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<String> _gameData = List.generate(9, (index) => null);
  bool _isXTurn = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Board(
            data: _gameData,
            onTap: _handleTap,
          ),
          Text(_getTurn()),
        ],
      ),
    );
  }

  String _getTurn() {
    final winner = _calculateWinner(this._gameData);
    if (winner != null) {
      return "Winner is $winner";
    }
    return "Current turn is ${_isXTurn ? "X" : "O"}";
  }

  void _handleTap(int index) {
    final winner = _calculateWinner(this._gameData);
    if (_gameData[index] != null || winner != null) {
      return null;
    }
    _gameData[index] = _isXTurn ? "X" : "O";
    setState(() {
      _isXTurn = !_isXTurn;
    });
  }

  String _calculateWinner(List<String> squares) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];

    for (int i = 0; i < lines.length; i++) {
      List<int> line = lines[i];
      if (squares[line[0]] == squares[line[1]] &&
          squares[line[1]] == squares[line[2]]) {
        return squares[line[0]];
      }
    }

    return null;
  }
}
