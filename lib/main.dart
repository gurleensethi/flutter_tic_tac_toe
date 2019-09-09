import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Game(),
    );
  }
}

class Square extends StatelessWidget {
  final int index;
  final String text;
  final void Function(int index) onTap;

  const Square({
    Key key,
    this.index,
    this.text,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => this.onTap(this.index),
      child: Container(
        width: 60.0,
        height: 60.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black,
          ),
        ),
        child: Center(
          child: Text(this.text ?? ''),
        ),
      ),
    );
  }
}

class Board extends StatelessWidget {
  final List<String> squares;
  final void Function(int index) onTap;

  const Board({
    Key key,
    this.squares,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemCount: 9,
        itemBuilder: (context, index) {
          return Square(
            index: index,
            onTap: this.onTap,
            text: squares[index],
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
  final List<List<String>> _history = [
    List.generate(9, (index) => null),
  ];
  int _currentStep = 0;
  bool _isXNext = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tic Tac Toe'),
      ),
      body: Column(
        children: <Widget>[
          Text(_getStatus()),
          Board(
            squares: _history[_currentStep],
            onTap: _handleClick,
          ),
          Text('Time Travel'),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final text = index == 0 ? 'Game Start' : 'Move to step $index';

                return RaisedButton(
                  child: Text(text),
                  onPressed: () {
                    this.setState(() {
                      _currentStep = index;
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _handleClick(index) {
    final squares = _history[_currentStep];
    final winner = _calculateWinner(squares);
    if (winner != null || squares[index] != null) {
      return;
    }

    final move = this._isXNext ? "X" : "O";
    final newSquares = squares.sublist(0);
    newSquares[index] = move;

    setState(() {
      if (_history.length > (_currentStep + 1)) {
        _history.removeRange(_currentStep + 1, _history.length);
      }
      _history.add(newSquares);
      _currentStep = _history.length - 1;
      _isXNext = !_isXNext;
    });
  }

  String _getStatus() {
    final winner = _calculateWinner(_history[_currentStep]);
    if (winner != null) {
      return 'The winner is $winner';
    } else {
      return 'Next turn is ${this._isXNext ? "X" : "O"}';
    }
  }
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
