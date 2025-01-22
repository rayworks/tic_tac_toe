import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tic_tac_toe/widgets/BoardBuilder.dart';
import 'package:tic_tac_toe/widgets/MoveInfo.dart';
import 'package:tic_tac_toe/widgets/widgets.dart';

class ChessAutoModePage extends StatefulWidget {
  const ChessAutoModePage({Key? key, required this.title}) : super(key: key);

  static const String name = "AutoMode";

  final String title;

  @override
  State<ChessAutoModePage> createState() => _ChessAutoModePageState();
}

class _ChessAutoModePageState extends State<ChessAutoModePage>
    with BoardBuilder {
  static const int COMP_LOSS = -1;
  static const int DRAW = 0;
  static const int COMP_WIN = 1;

  static const int COMP = 1;
  static const int HUMAN = 2;

  // the chess board
  late List<String> _board;

  var wonIdxTbl = [
    [0, 1, 2], // horizontal
    [3, 4, 5],
    [6, 7, 8],
    [0, 3, 6], // vertical
    [1, 4, 7],
    [2, 5, 8],
    [0, 4, 8], // cross
    [2, 4, 6]
  ];

  bool _isCompTurn = false;

  bool isCellUpdatable(int r, int c) {
    if (r < 0 || r >= 3 || c < 0 || c >= 3) return false;

    return _board[r * 3 + c] == CHESS_EMPTY_CELL;
  }

  @override
  String getTitle() {
    return widget.title;
  }

  @override
  String getCell(int row, int col) {
    return _board[row * 3 + col];
  }

  @override
  Future<void> updateAsync(int r, int c) async {
    if (!isCellUpdatable(r, c)) return;

    var appLocale = AppLocalizations.of(context);

    if (!_isCompTurn) {
      _board[r * 3 + c] = CHESS_HUMAN;
    }

    setState(() {
      _isCompTurn = !_isCompTurn;
    });

    if (fullBoard()) {
      showChessResultDialog(context, appLocale!.resultDraw, () {
        setState(() {
          _reset();
        });
      });
      return;
    }

    if (_isCompTurn) {
      MoveInfo info = findCompMove(COMP_LOSS, COMP_WIN);
      int pos = info.move;
      // place(pos, COMP);

      setState(() {
        _board[pos] = CHESS_COMP;
        _isCompTurn = false;
      });

      if (hasWon(CHESS_COMP)) {
        showChessResultDialog(context, appLocale!.youLose, () {
          setState(() {
            _reset();
          });
        });

        return;
      }
    } else {
      if (hasWon(CHESS_HUMAN)) {
        showChessResultDialog(context, appLocale!.youWin, () {
          setState(() {
            _reset();
          });
        });
        return;
      }
    }

    if (fullBoard()) {
      showChessResultDialog(context, appLocale!.resultDraw, () {
        setState(() {
          _reset();
        });
      });
    }
  }

  void _reset() {
    _isCompTurn = false;
    _board = List.filled(9, CHESS_EMPTY_CELL);
  }

  @override
  Widget build(BuildContext context) {
    return buildBoard(context);
  }

  @override
  void initState() {
    _board = List<String>.filled(9, CHESS_EMPTY_CELL);
    super.initState();
  }

  bool isEmpty(int pos) {
    return _board[pos] == CHESS_EMPTY_CELL;
  }

  void update(int pos, String chess) {
    _board[pos] = chess;
  }

  void place(int pos, int player) {
    update(pos, player == HUMAN ? CHESS_HUMAN : CHESS_COMP);
  }

  void unplace(int pos) {
    update(pos, CHESS_EMPTY_CELL);
  }

  bool hasWon(String chess) {
    int oCnt = 0, xCnt = 0;
    for (final line in wonIdxTbl) {
      oCnt = xCnt = 0;
      for (final coord in line) {
        if (_board[coord] == CHESS_COMP) {
          oCnt++;
        } else if (_board[coord] == CHESS_HUMAN) {
          xCnt++;
        }
      }
      if (oCnt == 3 && chess == CHESS_COMP ||
          xCnt == 3 && chess == CHESS_HUMAN) {
        return true;
      }
    }
    return false;
  }

  MoveInfo? _immediateWin(String chess) {
    int oCnt = 0, xCnt = 0;
    int nextPos;
    for (final line in wonIdxTbl) {
      nextPos = oCnt = xCnt = 0;
      for (final coord in line) {
        if (_board[coord] == CHESS_COMP) {
          oCnt++;
        } else if (_board[coord] == CHESS_HUMAN) {
          xCnt++;
        } else {
          nextPos = coord;
        }
      }

      // search for the empty pos for current player
      if (chess == CHESS_COMP) {
        if (oCnt == 2 && xCnt == 0) {
          return new MoveInfo(move: nextPos, value: COMP_WIN);
        }
      } else {
        if (xCnt == 2 && oCnt == 0) {
          return new MoveInfo(move: nextPos, value: COMP_LOSS);
        }
      }
    }
    return null;
  }

  MoveInfo findCompMove(int alpha, int beta) {
    int i, respValue;
    int value, bestMove = 1;
    MoveInfo? quickWinInfo;

    if (fullBoard())
      value = DRAW;
    else {
      quickWinInfo = _immediateWin(CHESS_COMP);
      if (quickWinInfo != null)
        return quickWinInfo;
      else {
        value = alpha;
        for (i = 0; i < 9 && value < beta; i++) {
          if (isEmpty(i)) {
            place(i, COMP);
            respValue = findHumanMove(alpha, beta).value;
            unplace(i);

            if (respValue > value) {
              value = respValue;
              bestMove = i;
            }
          }
        }
      }
    }
    return new MoveInfo(move: bestMove, value: value);
  }

  bool fullBoard() {
    for (int i = 0; i < 3; i++) {
      for (int j = 0; j < 3; j++) {
        if (_board[i * 3 + j] == CHESS_EMPTY_CELL) return false;
      }
    }
    return true;
  }

  MoveInfo findHumanMove(int alpha, int beta) {
    int i, respValue;
    int value, bestMove = 1;
    MoveInfo? quickWinInfo;

    if (fullBoard())
      value = DRAW;
    else {
      quickWinInfo = _immediateWin(CHESS_HUMAN);
      if (quickWinInfo != null) return quickWinInfo;

      value = beta;
      for (i = 0; i < 9 && value > alpha; i++) {
        if (isEmpty(i)) {
          place(i, HUMAN);
          respValue = findCompMove(alpha, beta).value;
          unplace(i);

          if (respValue < value) {
            value = respValue;
            bestMove = i;
          }
        }
      }
    }
    return new MoveInfo(move: bestMove, value: value);
  }
}
