import 'dart:developer';

import 'package:clean_todo/core/failure/exceptions.dart';
import 'package:clean_todo/features/task/data/models/task.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/data/local_data_source.dart';

final tasksLocalDataSourceProvider =
    FutureProvider<TasksLocalDataSource>((ref) async {
  var tasksLocalDataSource = TasksLocalDataSourceImpl();
  await tasksLocalDataSource.init();
  return tasksLocalDataSource;
});

abstract class TasksLocalDataSource implements LocalDataSource {
  Stream<List<TaskModel>> watchTasks();
  Future<List<TaskModel>> getTasks();
  Future<bool> addTask(TaskModel task);
  Future<bool> updateTask(TaskModel task);
  Future<bool> deleteTask(TaskModel task);
}

class TasksLocalDataSourceImpl extends TasksLocalDataSource {
  late Box<TaskModel> box;

  @override
  Future<List<TaskModel>> getTasks() async {
    try {
      return box.values.toList();
    } catch (e) {
      log("$e");
      throw CacheException();
    }
  }

  @override
  Future<bool> addTask(TaskModel task) async {
    try {
      int id = await box.add(task);
      await box.put(id, task..id = id);
      return true;
    } catch (e) {
      log("$e");
      throw CacheException();
    }
  }

  @override
  Future<bool> deleteTask(TaskModel task) async {
    try {
      await box.delete(task.id);
      return true;
    } catch (e) {
      log("$e");
      throw CacheException();
    }
  }

  @override
  Future<bool> updateTask(TaskModel task) async {
    try {
      await box.put(task.id, task);
      return true;
    } catch (e) {
      throw CacheException();
    }
  }

  @override
  Future<void> init() async {
    box = await Hive.openBox("tasks");
  }

  @override
  Stream<List<TaskModel>> watchTasks() async* {
    yield [];
    try {
      yield await getTasks();
      yield* box.watch().map((event) => box.values.toList());
    } catch (e) {
      log("WATCH_ERROR $e");
      throw CacheException();
    }
  }

  @override
  Future<void> clear() async {
    await box.clear();
  }

  @override
  Future<void> close() async {
    await box.close();
  }
}
