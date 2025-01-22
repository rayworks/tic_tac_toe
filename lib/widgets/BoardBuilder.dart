import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../anim/cross.dart';
import '../anim/oval.dart';

const String CHESS_EMPTY_CELL = " ";
const String CHESS_COMP = "O";
const String CHESS_HUMAN = "X";

mixin BoardBuilder {
  String getCell(int row, int col) => " ";

  String getTitle() => " ";

  Future<void> updateAsync(int r, int c) async {
    return Future.value();
  }

  Widget buildBoard(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getTitle()),
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
    String cellText = getCell(row, col);
    Widget cell;
    if (cellText == CHESS_COMP)
      cell = OvalPaintWidget(animDurationInSec: 1);
    else if (cellText == CHESS_HUMAN)
      cell = CrossPaintWidget(animDurationInSec: 1);
    else
      cell = Text(cellText,
          textAlign: TextAlign.center, style: TextStyle(fontSize: 24.0));

    return InkWell(
      onTap: () {
        print("you clicked position [$row, $col]");
        updateAsync(row, col);
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
