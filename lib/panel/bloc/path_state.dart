part of 'path_bloc.dart';

@immutable
sealed class PathState {}

class PathInitialState extends PathState {}

class PathLoadingState extends PathState {
  final String path;

  PathLoadingState(this.path);
}

class PathLoadedState extends PathState {
  final String path;
  final List<FileSystemEntity> entities;

  PathLoadedState({required this.path, required this.entities});
}

class PathErrorState extends PathState {
  final String path;
  final String message;

  PathErrorState(this.path, this.message);
}
