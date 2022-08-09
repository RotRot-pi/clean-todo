import 'dart:developer';

import 'package:clean_todo/core/presentation/router.dart';
import 'package:clean_todo/features/todo/domain/usecases/add_count.dart';
import 'package:clean_todo/features/todo/presentation/view_models/todos_view_model.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'injector.dart';
import 'presentation/screens/screen.dart';
import 'utils/service_locator.dart';

class Initializer {
  List<Injector> injectors;
  Initializer({required this.injectors});

  Future inject() async {
    List translations = [];
    List usecases = [];

    for (var injector in injectors) {
      translations.addAll(injector.translations);
      usecases.addAll(injector.useCases);
    }
  }

  injectViewModels() {
    for (var injector in injectors) {
      for (var viewModel in injector.viewModels) {
        //getIt.registerFactory(() => viewModel);
        log("TYPES ${viewModel.runtimeType}, ${getIt.currentScopeName}");
      }
    }
  }

  injectRoutes() {
    List<Screen> screens = injectors.expand((e) => e.screens).toList();
    AppRouter appRouter = AppRouter(screens: screens);
    getIt.registerSingleton<AppRouter>(appRouter);
  }

  initDB() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    for (var injector in injectors) {
      for (var adapter in injector.adapters) {
        Hive.registerAdapter(adapter);
      }
    }
  }

  injectUseCases() {
    List useCases = injectors.expand((injector) => injector.useCases).toList();
    for (var useCase in useCases) {
      getIt.registerSingleton(useCase);
    }
  }

  Future init() async {
    WidgetsFlutterBinding.ensureInitialized();
    await initDB();
    await injectViewModels();
    await injectUseCases();
    injectRoutes();
  }
}
