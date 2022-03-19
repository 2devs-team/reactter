// ignore_for_file: avoid_print, annotate_overrides, overridden_fields

import 'package:flutter/material.dart';

class FlutterGenericException extends AsyncException {
  Object originalError;

  FlutterGenericException({required this.originalError})
      : super(originalError: originalError, typeOfError: "FLUTTER GENERIC") {
    printErrorMessage();
  }
}

class WidgetException extends AsyncException {
  Object originalError;

  WidgetException({required this.originalError})
      : super(originalError: originalError, typeOfError: "WIDGET");

  Widget createWidget(BuildContext context, String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.red[500],
        ),
      ),
    );
  }
}

class AsyncException {
  late String message;
  String typeOfError;
  Object originalError;

  AsyncException({required this.originalError, this.typeOfError = "ASYNC"}) {
    printErrorMessage();
  }

  printErrorMessage() {
    final completeStack = StackTrace.current.toString();

    final currentStack = completeStack.split("#")[4];

    final stackSplitted = currentStack.split(":meru/")[1].split(":");

    final route = stackSplitted[0];
    final line = stackSplitted[1];

    final fileAndMethod = currentStack.split("3      ")[1].split(" (")[0];

    printError("═════ 🛑 [\x1B[37m$typeOfError EXCEPTION\x1B[31m] 🛑 ═════");
    print("\x1B[37mCAUGHT IN: \x1B[36m$fileAndMethod()");
    print("\x1B[37mFILE: \x1B[36m$route");
    print("\x1B[37mLINE: \x1B[36m$line");
    print("\x1B[37mORIGINAL ERROR: \x1B[36m$originalError");
    printError("====================================");
  }

  void printError(String text) {
    print('\x1B[31m$text\x1B[0m');
  }
}
