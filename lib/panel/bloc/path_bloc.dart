import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'path_event.dart';
part 'path_state.dart';

class PathBloc extends Bloc<PathEvent, PathState> {
  PathBloc() : super(PathInitialState()) {
    on<PathSelectedEvent>(_onPathSelected);
  }

  Future<void> _onPathSelected(
    PathSelectedEvent event,
    Emitter<PathState> emit,
  ) async {
    emit(PathLoadingState(event.path));

    try {
      final directory = Directory(event.path);

      if (!await directory.exists()) {
        emit(PathErrorState(event.path, 'Folder does not exist.'));
        return;
      }

      final entities = await directory.list().toList();
      emit(PathLoadedState(path: event.path, entities: entities));
    } on PathAccessException {
      emit(
        PathErrorState(
          event.path,
          "Not Authorized to access the path. Check folder permissions.",
        ),
      );
    } on PathNotFoundException {
      emit(PathErrorState(event.path, "Folder path does not exists."));
    } on FileSystemException {
      emit(
        PathErrorState(
          event.path,
          "Folder path syntax is wrong. Check for special characters / formatting.",
        ),
      );
    } catch (e) {
      emit(PathErrorState(event.path, "Unexpected error: ${e.toString()}"));
    }
  }
}
