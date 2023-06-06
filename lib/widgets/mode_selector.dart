import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tic_tac_toe/widgets/home_page.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context);
  }

  _navigateToMain(BuildContext context, bool playWithHuman) {
    Navigator.of(context).popAndPushNamed(MyHomePage.name);
  }

  Widget _buildLayout(BuildContext context) {
    return Material(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          onPressed: () => _navigateToMain(context, true),
          child: Text(
            "VS. Human Player",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () => _navigateToMain(context, false),
          child: Text(
            "VS. Computer",
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        )
      ]),
    );
  }
}