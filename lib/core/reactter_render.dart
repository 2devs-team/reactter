import 'package:flutter/material.dart';
import 'package:reactter/core/reactter_factory.dart';
import '../reactter.dart';

class ReactterRender<T extends ReactterController> extends StatefulWidget {
  const ReactterRender({Key? key}) : super(key: key);

  @override
  State<ReactterRender> createState() => _ReactterRenderState<T>();
}

class _ReactterRenderState<T extends ReactterController>
    extends State<ReactterRender> {
  @override
  void initState() {
    super.initState();

    var isRegistered = ReactterFactory().isRegistered<T>();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
