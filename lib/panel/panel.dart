import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_sorter/panel/bloc/path_bloc.dart';
import 'package:media_sorter/panel/path_picker.dart';
import 'package:path/path.dart';

class Panel extends StatelessWidget {
  final bool isLeft;

  const Panel({super.key, required this.isLeft});

  static const EdgeInsets _leftPadding = EdgeInsets.fromLTRB(8, 0, 8, 8);
  static const EdgeInsets _rightPadding = EdgeInsets.fromLTRB(0, 0, 8, 8);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isLeft ? _leftPadding : _rightPadding,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(8),
        ),
        child: BlocProvider(
          create: (context) => PathBloc(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PathPicker(),
              Expanded(
                child: BlocBuilder<PathBloc, PathState>(
                  builder: (context, state) {
                    if (state is PathLoadingState) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is PathLoadedState) {
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: state.entities.length,
                        itemBuilder: (context, index) {
                          final entity = state.entities[index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                            child: Material(
                              borderRadius: BorderRadius.circular(8),
                              color: Theme.of(
                                context,
                              ).colorScheme.surfaceContainerHigh,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(8),
                                onTap: () {
                                  if (entity is Directory) {
                                    context.read<PathBloc>().add(
                                      PathSelectedEvent(entity.path),
                                    );
                                  }
                                },
                                child: ListTile(
                                  dense: true,
                                  leading: Icon(
                                    entity is Directory
                                        ? Icons.folder_open_rounded
                                        : Icons.insert_drive_file_rounded,
                                  ),
                                  title: Text(
                                    basename(entity.path),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }

                    if (state is PathErrorState) {
                      return Center(child: Text(state.message));
                    }

                    return const Center(child: Text('Select a folder'));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
