import 'package:go_router/go_router.dart';
import 'package:pinterest_clone/domain/entities/pin_entity.dart';
import 'package:pinterest_clone/presentation/auth/screens/login_screen.dart';
import 'package:pinterest_clone/presentation/home/screens/home_screen.dart';
import 'package:pinterest_clone/presentation/pin_detail/screens/pin_detail_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/pin',
      builder: (context, state) {
        final args = state.extra as Map<String, dynamic>;
        final pin = args['pin'] as PinEntity;
        final heroTag = args['heroTag'] as String;
        return PinDetailScreen(pin: pin, heroTag: heroTag);
      },
    ),
  ],
);
