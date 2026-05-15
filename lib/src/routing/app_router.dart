import 'package:go_router/go_router.dart';
import '../features/catalog/catalog_screen.dart';
import '../features/detail/detail_screen.dart';
import '../features/quiz/quiz_screen.dart';
import '../features/settings/settings_screen.dart';
import 'scaffold_with_nav.dart';

final appRouter = GoRouter(
  initialLocation: '/catalog',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => ScaffoldWithNav(shell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/catalog',
            builder: (_, _) => const CatalogScreen(),
            routes: [
              GoRoute(
                path: 'dino/:id',
                builder: (_, state) =>
                    DetailScreen(dinoId: state.pathParameters['id']!),
              ),
            ],
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/quiz',
            builder: (_, _) => const QuizScreen(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/settings',
            builder: (_, _) => const SettingsScreen(),
          ),
        ]),
      ],
    ),
  ],
);
