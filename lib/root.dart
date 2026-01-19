import 'package:flutter/material.dart';
import 'package:media_sorter/panel/panel.dart';
import 'package:media_sorter/components/toolbar.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Toolbar(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: Panel(isLeft: true)),
                Expanded(child: Panel(isLeft: false)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
