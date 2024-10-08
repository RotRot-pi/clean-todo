import 'package:clean_todo/core/core.dart';

import '../../domain/entities/task.dart';

abstract class TasksState {}

class TasksInitial extends TasksState {}

class TasksLoading extends TasksState {}

class TasksData extends TasksState {
  final List<Task> tasks;
  TasksData(this.tasks);
}

class TasksEmpty extends TasksState {
  TasksEmpty();
}

class TasksSearch extends TasksState {
  final List<Task> tasks;
  TasksSearch(this.tasks);
}

class TasksError extends TasksState {
  final Failure failure;
  TasksError(this.failure);
}
