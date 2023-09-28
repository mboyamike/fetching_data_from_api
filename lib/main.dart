import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Map<String, dynamic>>> fetchTodos() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    final response = await http.get(uri);
    final responseBody = await jsonDecode(response.body);
    return List<Map<String, dynamic>>.from(responseBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todos'),
      ),
      body: FutureBuilder(
        future: fetchTodos(),
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
                        builder: (_) => TodoPage(id: todo['id'].toString()),
                      ),
                    ),
                    leading: Text('${todos.indexOf(todo) + 1}'),
                    title: Text(todo['title']),
                    selected: todo['completed'],
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

class TodoPage extends StatefulWidget {
  const TodoPage({super.key, required this.id});

  final String id;

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  Future<Map<String, dynamic>> fetchTodo() async {
    final id = widget.id;
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos/$id');
    final response = await http.get(uri);
    final responseBody = await jsonDecode(response.body);
    return Map<String, dynamic>.from(responseBody);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo'),
      ),
      body: FutureBuilder(
        future: fetchTodo(),
        builder: (context, asyncSnapshot) {
          if (asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (asyncSnapshot.hasData) {
            final todo = asyncSnapshot.data!;
            return Center(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(todo['id'].toString()),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            todo['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Checkbox(value: todo['completed'], onChanged: null),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
