import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:tic_tac_toe/widgets/mode_selector.dart';

import 'widgets/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
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
      home: ModeSelector(),
      routes: {
        MyHomePage.name: (context) {
          return MyHomePage(title: 'TicTacToe Game');
        }
      },
    );
  }
}
