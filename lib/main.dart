import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tic_tac_toe/anim/cross.dart';
import 'package:tic_tac_toe/anim/oval.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('en', ''), // English, no country code
        Locale('zh', '')
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'TicTacToe Game'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

const String CHAR_EMPTY_CELL = " ";

class _MyHomePageState extends State<MyHomePage> {
  var _grid = [
    List.filled(3, CHAR_EMPTY_CELL),
    List.filled(3, CHAR_EMPTY_CELL),
    List.filled(3, CHAR_EMPTY_CELL),
  ];

  bool _isOTurn = true;
  int _nRow = 3;
  int _nCol = 3;

  bool isCellUpdatable(int r, int c) {
    if (r < 0 || r >= _nRow || c < 0 || c >= _nCol) return false;

    return _grid[r][c] == CHAR_EMPTY_CELL;
  }

  Future<void> _update(int r, int c) async {
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
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.msgGameOver),
          content: Text(msg),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  callback.call();
                },
                child: Text(AppLocalizations.of(context)!.btnOK))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _buildExpandedRow(0),
            _buildExpandedRow(1),
            _buildExpandedRow(2),
          ],
        ),
      ),
    );
  }

  Expanded _buildExpandedRow(int index) {
    return Expanded(
      flex: 1,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildRowChildren(index),
        ),
      ),
    );
  }

  List<Widget> _buildRowChildren(int row) {
    var widgets = <Widget>[];
    for (int i = 0; i < 3; i++) {
      widgets.add(Expanded(child: _buildMaxHeightText(row, i), flex: 1));
    }
    return widgets;
  }

  Widget _buildMaxHeightText(int row, int col) {
    String cellText = _grid[row][col];
    Widget cell;
    if (cellText == "O")
      cell = OvalPaintWidget(animDurationInSec: 1);
    else if (cellText == "X")
      cell = CrossPaintWidget(animDurationInSec: 1);
    else
      cell = Text(cellText,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0));

    return InkWell(
      onTap: () {
        print("you clicked position [$row, $col]");
        _update(row, col);
      },
      child: Container(
        child: cell,
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
              left: BorderSide(width: 1.0, color: Color(0xFFDFDFDF)),
              right: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
              bottom: BorderSide(width: 1.0, color: Color(0xFF7F7F7F)),
            ),
            color: Color(0xFFBFBFBF)),
        height: double.maxFinite,
        alignment: Alignment.center,
      ),
    );
  }
}
