import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../errors/exceptions.dart';
import '../errors/failures.dart';

void showErrorWidget(
    {@required Failure failure, @required BuildContext context}) {
  final errorMessage = errorMessages[failure.messageId];
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.deepOrange.shade900,
      behavior: SnackBarBehavior.fixed,
      action: SnackBarAction(
        onPressed: () {},
        label: "OK",
      ),
      duration: Duration(seconds: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Row(
        textBaseline: TextBaseline.alphabetic,
        children: [
          Icon(
            FontAwesomeIcons.timesCircle,
            color: Colors.white,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                errorMessage.message,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

void showInformationWidget(
    {@required String message, @required BuildContext context}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.indigo.shade900,
      behavior: SnackBarBehavior.fixed,
      action: SnackBarAction(
        onPressed: () {},
        label: "OK",
      ),
      duration: Duration(seconds: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      content: Row(
        textBaseline: TextBaseline.alphabetic,
        children: [
          Icon(
            FontAwesomeIcons.exclamationCircle,
            color: Colors.white,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 30.0),
              child: Text(
                message,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
