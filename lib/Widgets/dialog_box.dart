import 'package:flutter/material.dart';

void showDialogBox({
  required BuildContext context,
  required String title,
  required String text,
  required List<Map<String, dynamic>> actions, // Changed to dynamic to allow for styling
}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      List<Widget> actionWidgets = actions.map((action) {
        String buttonText = action['text'];
        VoidCallback callback = action['onPressed'];
        TextStyle? textStyle = action['style']; // Optional style

        return TextButton(
          child: Text(buttonText, style: textStyle),
          onPressed: () {
            callback();
            Navigator.of(context).pop(); // Close the dialog by default after action
          },
        );
      }).toList();

      return AlertDialog(
        title: Text(title, textAlign: TextAlign.center),
        content: Text(text, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey.shade800,fontSize: 16),),
        actions: actionWidgets,
        actionsAlignment: MainAxisAlignment.center,
      );
    },
  );
}
