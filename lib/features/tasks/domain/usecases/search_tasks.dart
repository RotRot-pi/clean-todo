import 'package:clean_todo/core/core.dart';
import 'package:clean_todo/core/usecases/usecase.dart';
import 'package:clean_todo/features/tasks/data/repositories/tasks_repository_impl.dart';
import 'package:clean_todo/features/tasks/domain/entities/task.dart';
import 'package:dartz/dartz.dart' hide Task;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/task_repository.dart';

class SearchTasksParams {
  final String query;
  final List<Task> tasks;

  SearchTasksParams({required this.query, required this.tasks});
}

class SearchTasks extends UseCase<List<Task>, SearchTasksParams> {
  final TasksRepository repository; // You might not need the repository here

  SearchTasks({required this.repository});

  @override
  Future<Either<Failure, List<Task>>> call(SearchTasksParams params) async {
    // Filtering logic (no need for repository interaction in this case)
    if (params.query.isEmpty) {
      return Right(params.tasks);
    }
    return Right(params.tasks
        .where((task) =>
            task.title.toLowerCase().contains(params.query.toLowerCase()))
        .toList());
  }
}

final searchTasksUseCaseProvider = Provider<SearchTasks>((ref) {
  final tasksRepository =
      ref.watch(tasksRepositoryProvider as AlwaysAliveProviderListenable);
  return SearchTasks(repository: tasksRepository);
});
