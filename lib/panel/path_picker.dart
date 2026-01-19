import 'dart:io';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_sorter/panel/bloc/path_bloc.dart';

class PathPicker extends StatefulWidget {
  const PathPicker({super.key});

  @override
  State<PathPicker> createState() => _PathPickerState();
}

class _PathPickerState extends State<PathPicker> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PathBloc, PathState>(
      listenWhen: (previous, current) {
        return current is PathLoadedState ||
            current is PathLoadingState ||
            current is PathErrorState;
      },
      listener: (context, state) {
        final currentPath = switch (state) {
          PathLoadedState s => s.path,
          PathLoadingState s => s.path,
          PathErrorState s => s.path,
          _ => null,
        };

        if (currentPath != null && _controller.text != currentPath) {
          _controller.text = currentPath;
        }
      },
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<PathBloc, PathState>(
                builder: (context, state) {
                  final currentPath = switch (state) {
                    PathLoadedState s => s.path,
                    PathLoadingState s => s.path,
                    PathErrorState s => s.path,
                    _ => null,
                  };
                  return TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      prefixIcon:
                          currentPath != null &&
                              Directory(currentPath).parent.path != currentPath
                          ? IconButton(
                              icon: Icon(Icons.arrow_upward_rounded),
                              onPressed: () {
                                final parent = Directory(
                                  currentPath,
                                ).parent.path;
                                context.read<PathBloc>().add(
                                  PathSelectedEvent(parent),
                                );
                              },
                            )
                          : Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 7),
                              child: Icon(Icons.folder_open_rounded),
                            ),
                      hintText: 'Folder Path',
                    ),
                    onChanged: (value) {
                      context.read<PathBloc>().add(PathSelectedEvent(value));
                    },
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 8, 8),
            child: IconButton.filledTonal(
              onPressed: () async {
                final bloc = context.read<PathBloc>();

                final String? folderPath = await getDirectoryPath(
                  confirmButtonText: 'Select Folder',
                );

                if (folderPath != null) {
                  bloc.add(PathSelectedEvent(folderPath));
                }
              },
              icon: const Icon(Icons.open_in_new_rounded),
            ),
          ),
        ],
      ),
    );
  }
}
