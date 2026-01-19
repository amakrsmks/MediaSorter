import 'package:flutter/material.dart';
import 'package:media_sorter/panel/panel.dart';
import 'package:media_sorter/components/toolbar.dart';

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  // initial flex for left panel
  double leftFraction = 0.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          const Toolbar(),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final totalWidth = constraints.maxWidth;
                final leftWidth = totalWidth * leftFraction;
                final rightWidth = totalWidth - leftWidth - 8;

                return Row(
                  children: [
                    SizedBox(
                      width: leftWidth,
                      child: const Panel(isLeft: true),
                    ),
                    MouseRegion(
                      cursor: SystemMouseCursors.resizeColumn,
                      child: GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            leftFraction += details.delta.dx / totalWidth;
                            leftFraction = leftFraction.clamp(0.2, 0.8);
                          });
                        },
                        onDoubleTap: () {
                          setState(() {
                            leftFraction = 0.5;
                          });
                        },
                        child: VerticalDivider(
                          width: 8,
                          color: Colors.grey.withOpacity(0.3),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: rightWidth,
                      child: const Panel(isLeft: false),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
