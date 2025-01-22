import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tic_tac_toe/widgets/BoardBuilder.dart';
import 'package:tic_tac_toe/widgets/widgets.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  static const String name = "MyHomePage";

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const String CHAR_EMPTY_CELL = " ";

class _MyHomePageState extends State<MyHomePage> with BoardBuilder {
  var _grid = [
    List.filled(3, CHAR_EMPTY_CELL),
    List.filled(3, CHAR_EMPTY_CELL),
    List.filled(3, CHAR_EMPTY_CELL),
  ];

  bool _isOTurn = true;
  int _nRow = 3;
  int _nCol = 3;

  @override
  String getTitle() => widget.title;

  @override
  String getCell(int row, int col) {
    return _grid[row][col];
  }

  bool isCellUpdatable(int r, int c) {
    if (r < 0 || r >= _nRow || c < 0 || c >= _nCol) return false;

    return _grid[r][c] == CHAR_EMPTY_CELL;
  }

  Future<void> updateAsync(int r, int c) async {
    if (!isCellUpdatable(r, c)) return;

    setState(() {
      _grid[r][c] = _isOTurn ? "O" : "X";
      _isOTurn = !_isOTurn;
    });

    var checkedResult = checkWinner();
    var appLocalizations = AppLocalizations.of(context);
    switch (checkedResult) {
      case "X":
      case "O":
        print("The winner is $checkedResult");
        _showDialog(appLocalizations!.resultWinner + "$checkedResult", () {
          setState(() {
            _reset();
          });
        });
        break;
      case "D":
        print("It's a draw");
        _showDialog(appLocalizations!.resultDraw, () {
          setState(() {
            _reset();
          });
        });
        break;
    }
  }

  void _reset() {
    setState(() {
      _isOTurn = Random().nextBool();
      _grid = [
        List.filled(3, CHAR_EMPTY_CELL),
        List.filled(3, CHAR_EMPTY_CELL),
        List.filled(3, CHAR_EMPTY_CELL),
      ];
    });
  }

  String checkWinner() {
    var board = _grid;

    int sum = 0;
    String pre = CHAR_EMPTY_CELL;
    for (int i = 0; i < _nRow; i++) {
      sum = 1;
      pre = board[i][0];
      for (int j = 1; j < _nCol; j++) {
        if (pre != CHAR_EMPTY_CELL && board[i][j] == pre)
          sum++;
        else
          break;
      }
      if (sum == _nCol) return pre;
    }

    for (int i = 0; i < _nCol; i++) {
      sum = 1;
      pre = board[0][i];
      for (int j = 1; j < _nRow; j++) {
        if (pre != CHAR_EMPTY_CELL && pre == board[j][i])
          sum++;
        else
          break;
      }
      if (sum == _nRow) return pre;
    }

    pre = board[0][0];
    if (pre != CHAR_EMPTY_CELL && pre == board[1][1] && pre == board[2][2])
      return pre;

    pre = board[2][0];
    if (pre != CHAR_EMPTY_CELL && pre == board[1][1] && pre == board[0][2])
      return pre;

    bool emptyCellFound = false;
    out:
    for (int i = 0; i < _nRow; i++) {
      for (int j = 0; j < _nCol; j++) {
        if (board[i][j] == CHAR_EMPTY_CELL) {
          emptyCellFound = true;
          break out;
        }
      }
    }

    return emptyCellFound ? 'U' : 'D';
  }

  _showDialog(String msg, Function callback) {
    showChessResultDialog(context, msg, callback);
  }

  @override
  Widget build(BuildContext context) {
    return buildBoard(context);
  }
}
