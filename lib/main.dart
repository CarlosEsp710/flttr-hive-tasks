import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/app/data/hive_data_store.dart';

import 'package:hive_todo/app/modules/home/screens/home_screen.dart';
import 'package:hive_todo/app/shared/models/task.dart';

late Box boxTask;
Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter<Task>(TaskAdapter());

  boxTask = await Hive.openBox<Task>('tasks');

  boxTask.values.forEach((task) {
    if (task.createdAt.day != DateTime.now().day) {
      boxTask.delete(task.id);
    }
  });

  runApp(BaseWidget(child: const MyApp()));
}

class BaseWidget extends InheritedWidget {
  final Widget child;
  final HiveDataStore dataStore = HiveDataStore();

  BaseWidget({
    Key? key,
    required this.child,
  }) : super(key: key, child: child);

  static BaseWidget? of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw Exception('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(BaseWidget oldWidget) {
    return false;
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          elevation: 0.0,
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
