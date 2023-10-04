class Todo {
  Todo({
    required this.id,
    required this.title,
    required this.completed,
  });

  final int id;
  final String title;
  final bool completed;

  Todo copyWith({
    int? id,
    String? title,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as int,
      title: map['title'] as String,
      completed: map['completed'] as bool,
    );
  }

  @override
  String toString() => 'Todo(id: $id, title: $title, completed: $completed)';

  @override
  bool operator ==(Object? other) {
    if (other is! Todo) return false;
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        other.completed == completed;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ completed.hashCode;
}
