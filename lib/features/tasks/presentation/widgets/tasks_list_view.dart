import 'package:clean_todo/features/tasks/presentation/states/task_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/failure.dart';
import '../../tasks.dart';
import '../controllers/task_controller.dart';
import 'empty_view.dart';
import 'error_view.dart';
import 'task_view.dart';

class TasksListView extends ConsumerStatefulWidget {
  const TasksListView({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TasksListViewState();
}

class _TasksListViewState extends ConsumerState<TasksListView> {
  @override
  Widget build(BuildContext context) {
    var state = ref.watch(tasksProvider);

    ref.listen(taskProvider, (previous, next) {
      if (next is TaskAdded || next is TaskDeleted || next is TaskUpdated) {
        ref.read(tasksProvider.notifier).getTasks();
      }
    });

    if (state is TasksLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state is TasksError) {
      return ErrorView(message: mapFailureToMessage(context, state.failure));
    }

    if (state is TasksEmpty) {
      return const EmptyView();
    }
    if (state is TasksSearch) {
      // Handle the TasksSearch state
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: Column(
          children: [
            const Text(
              "Search Results", // Or a more appropriate title
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: state.tasks.length,
                itemBuilder: (context, index) {
                  var task = state.tasks[index];
                  return TaskView(task: task);
                },
              ),
            ),
          ],
        ),
      );
    }
    if (state is TasksData) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        child: ListView.builder(
          itemCount: state.tasks.length,
          itemBuilder: (context, index) {
            var task = state.tasks[index];
            return TaskView(task: task);
          },
        ),
      );
    }

    return Container();
  }
}
// class TasksListView extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final searchQuery = ref.watch(searchNotifierProvider);
//     final tasks = ref.watch(tasksProvider).when(
//       data: (tasks) => searchQuery.when(
//         data: (query) => SearchNotifier(ref).getFilteredTasks(tasks),
//         error: (error, _) => [],
//         loading: () => [],
//       ),
//       error: (error, _) => [],
//       loading: () => [],
//     );

//     return ListView.builder(
//       itemCount: tasks.length,
//       itemBuilder: (context, index) {
//         return TaskItem(tasks[index]);
//       },
//     );
//   }
// }