import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/tasks_controller.dart';

class SearchWiget extends ConsumerWidget {
  const SearchWiget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextField(
        onChanged: (query) =>
            ref.read(tasksProvider.notifier).searchTasks(query),
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0), // Rounded corners
            borderSide: BorderSide.none, // Remove default border
          ),
          filled: true,
          fillColor: Colors.white
              .withOpacity(0.8), // Semi-transparent white background
          hintStyle: TextStyle(color: Colors.grey[600]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 12), // Adjust padding
        ),
      ),
    );
  }
}
