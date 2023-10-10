import 'dart:convert';

import 'package:fetching_data_from_api/todo.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'repository.g.dart';

class Repository {
  Future<List<Todo>> fetchTodos() async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos');
    final response = await http.get(uri);
    final responseBody = await jsonDecode(response.body);
    await Future.delayed(const Duration(milliseconds: 500));
    return List<Map<String, dynamic>>.from(responseBody)
        .map((todoMap) => Todo.fromMap(todoMap))
        .toList();
  }

  Future<Todo> fetchTodo({required String id}) async {
    final uri = Uri.parse('https://jsonplaceholder.typicode.com/todos/$id');
    final response = await http.get(uri);
    final responseBody = await jsonDecode(response.body);
    final todoMap = Map<String, dynamic>.from(responseBody);
    return Todo.fromMap(todoMap);
  }
}

@riverpod
Repository repository(RepositoryRef ref) {
  return Repository();
}
