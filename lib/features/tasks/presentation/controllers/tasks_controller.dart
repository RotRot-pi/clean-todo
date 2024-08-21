import 'package:clean_todo/features/tasks/domain/usecases/search_tasks.dart';
import 'package:clean_todo/features/tasks/presentation/states/tasks_state.dart';
import 'package:riverpod/riverpod.dart';
import '../../domain/domain.dart';

class TasksController extends StateNotifier<TasksState> {
  StateNotifierProviderRef ref;

  GetTasks getTasksUseCase;
  TasksController(this.ref, this.getTasksUseCase) : super(TasksInitial()) {
    getTasks();
  }

  Future<void> getTasks() async {
    state = TasksLoading();

    var response = await getTasksUseCase();

    response.fold((failure) {
      state = TasksError(failure);
    }, (tasks) {
      if (tasks.isEmpty) {
        state = TasksEmpty();
        return;
      }
      state = TasksData(tasks);
    });
  }

  Future<void> searchTasks(String query) async {
    final tasksResult = await getTasksUseCase(); // Get all tasks

    tasksResult.fold(
      (failure) => state = TasksError(failure),
      (tasks) {
        final filteredTasks = tasks
            .where((task) =>
                task.title.toLowerCase().contains(query.toLowerCase()))
            .toList();
        state = TasksData(filteredTasks); // Update state with filtered tasks
      },
    );
  }
}

final tasksProvider =
    StateNotifierProvider.autoDispose<TasksController, TasksState>((ref) {
  GetTasks getTaskUseCase = ref.watch(getTasksUseCaseProvider);
  return TasksController(ref, getTaskUseCase);
});
