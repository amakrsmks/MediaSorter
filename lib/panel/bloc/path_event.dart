part of 'path_bloc.dart';

@immutable
sealed class PathEvent {}

class PathSelectedEvent extends PathEvent {
  final String path;
  PathSelectedEvent(this.path);
}
