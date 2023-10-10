import 'package:fetching_data_from_api/main.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/todos/:todoID',
      builder: (context, state) =>
          TodoPage(id: state.pathParameters['todoID'] ?? ''),
    )
  ],
);
