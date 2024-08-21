import 'package:clean_todo/features/tasks/presentation/controllers/tasks_controller.dart';
import 'package:clean_todo/features/tasks/presentation/widgets/search_bar.dart';
import 'package:clean_todo/features/tasks/presentation/widgets/tasks_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import '../../../preferences/presentation/widgets/change_language_button.dart';
import '../../../preferences/presentation/widgets/change_theme_button.dart';
import 'add_task_screen.dart';

class TasksScreen extends ConsumerStatefulWidget {
  static String get routePath => "/";
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(AppLocalizations.of(context)!.listTasksScreenTitle),
        actions: [
          IconButton(
            onPressed: () => setState(() => _isSearching = !_isSearching),
            icon: Icon(_isSearching ? Icons.close : Icons.search),
          ),
          const ChangeLanguageButton(),
          const AppThemeButton(),
        ],
      ),
      // appBar: AppBar(
      //   elevation: 0.0,
      //   title: Text(AppLocalizations.of(context)!.listTasksScreenTitle),
      //   actions: const [
      //     ChangeLanguageButton(),
      //     AppThemeButton(),
      //   ],
      // ),
      // appBar: AppBar(
      //   elevation: 0.0,
      //   title: Consumer(builder: (context, ref, child) {
      //     return TextField(
      //       onChanged: (query) =>
      //           ref.read(tasksProvider.notifier).searchTasks(query),
      //       decoration: InputDecoration(
      //         hintText: AppLocalizations.of(context)!
      //             .listTasksScreenTitle, // Or similar
      //       ),
      //     );
      //   }),
      // ),
      body: Column(
        children: [
          if (_isSearching) const SearchWiget(),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: TextField(
          //     onChanged: (query) =>
          //         ref.read(tasksProvider.notifier).searchTasks(query),
          //     decoration: const InputDecoration(
          //       hintText: 'Search tasks...',
          //       border: InputBorder.none,
          //     ),
          //   ),
          // ),
          const Expanded(child: TasksListView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xffffd78a),
        foregroundColor: Colors.black,
        onPressed: () => context.push(AddTaskScreen.routePath),
        child: const Icon(Iconsax.add),
      ),
    );
  }
}
