import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showChessResultDialog(BuildContext context, String msg, Function callback) {
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
