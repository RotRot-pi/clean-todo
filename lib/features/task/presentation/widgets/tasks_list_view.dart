import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../notifiers/tasks_state_notifier.dart';
import 'task_view.dart';

class TasksListView extends ConsumerWidget {
  const TasksListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    var tasksState = ref.watch(tasksStateNotifierProvider);
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      color: const Color(0xff14141b),
      child: ListView.builder(
        itemCount: tasksState.tasks.length,
        itemBuilder: (context, index) {
          var task = tasksState.tasks[index];
          return TaskView(task: task);
        },
      ),
    );
  }
}
