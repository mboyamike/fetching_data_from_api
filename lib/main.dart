import 'dart:convert';

import 'package:fetching_data_from_api/repository.dart';
import 'package:fetching_data_from_api/router.dart';
import 'package:fetching_data_from_api/todo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      routerConfig: router,
    );
  }
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late Future<List<Todo>> fetchTodosFuture;

  @override
  void initState() {
    super.initState();
    final Repository repository = ref.read(repositoryProvider);
    fetchTodosFuture = repository.fetchTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                final Repository repository = ref.read(repositoryProvider);
                fetchTodosFuture = repository.fetchTodos();
              });
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchTodosFuture,
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasData) {
            final todos = asyncSnapshot.data!;
            return ListView(
              children: [
                for (final todo in todos)
                  ListTile(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => TodoPage(id: todo.id.toString()),
                      ),
                    ),
                    leading: Text('${todos.indexOf(todo) + 1}'),
                    title: Text(todo.title),
                    selected: todo.completed,
                  ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class TodoPage extends ConsumerStatefulWidget {
  const TodoPage({super.key, required this.id});

  final String id;

  @override
  ConsumerState<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends ConsumerState<TodoPage> {
  late Future<Todo> fetchTodoFuture;

  @override
  void initState() {
    super.initState();
    final Repository repository = ref.read(repositoryProvider);
    fetchTodoFuture = repository.fetchTodo(id: widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: FutureBuilder(
        future: fetchTodoFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          if (snapshot.hasData) {
            final todo = snapshot.data!;
            return Center(
              child: Column(
                children: [
                  Text(todo.id.toString()),
                  Checkbox(value: todo.completed, onChanged: null)
                ],
              ),
            );
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
