import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tic_tac_toe/widgets/ChessAutoModePage.dart';
import 'package:tic_tac_toe/widgets/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ModeSelector extends StatelessWidget {
  const ModeSelector({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildLayout(context);
  }

  _navigateToMain(BuildContext context, bool playWithHuman) {
    if (playWithHuman)
      Navigator.of(context).pushNamed(MyHomePage.name, arguments: {});
    else
      Navigator.of(context).pushNamed(ChessAutoModePage.name, arguments: {});
  }

  Widget _buildLayout(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context);

    return Material(
      color: Colors.cyan,
      child: Scaffold(
        appBar: AppBar(title: Text(appLocalizations!.modeSelection),),
        body: Stack(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: InkWell(
                    child: Icon(Icons.info_outlined),
                    onTap: () {
                      print('info clicked');
                      launch('https://github.com/rayworks/tic_tac_toe');
                    }),
              ),
            ),
            Center(
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                ElevatedButton(
                  onPressed: () => _navigateToMain(context, true),
                  child: Text(
                    appLocalizations.vsPlayer,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => _navigateToMain(context, false),
                  child: Text(
                    appLocalizations.vsComputer,
                    style: TextStyle(color: Colors.black, fontSize: 20),
                  ),
                )
              ]),
            )
          ],
        ),
      ),
    );
  }
}
