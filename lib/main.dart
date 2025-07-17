import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:hwpldemo/screen/dashboard/model/todo_entity.dart';
import 'package:hwpldemo/screen/dashboard/logic/logic.dart';
import 'package:hwpldemo/screen/dashboard/todo_list_screen.dart';
import 'package:hwpldemo/theme/theme.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoEntityAdapter());

  await Hive.openBox<TodoEntity>('local_todos');
  await Hive.openBox<int>('deleted_ids');
  await Hive.openBox<bool>('completed_status_overrides');
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TodoProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData(context),
      home: TodoListScreen(),
    );
  }
}
