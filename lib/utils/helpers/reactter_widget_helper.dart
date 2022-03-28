library reactter;

import 'package:flutter/material.dart';
import 'package:reactter/utils/reaccter_exceptions.dart';

Widget renderBuild(Widget widget, BuildContext context) {
  try {
    return widget;
  } catch (e) {
    return WidgetException(originalError: e)
        .createWidget(context, "Error building ${widget.toString()} View");
  }
}
