import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../features/app_providers.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/dashboard/presentation/dashboard_screen.dart';
import '../../features/deliveries/presentation/delivery_detail_screen.dart';
import '../../features/history/presentation/history_screen.dart';
import '../../features/profile/presentation/profile_screen.dart';
import '../../features/routes/domain/route_models.dart';
import '../../features/routes/presentation/active_delivery_screen.dart';
import '../../features/routes/presentation/delivery_sequence_screen.dart';
import '../../features/routes/presentation/route_map_screen.dart';
import '../../features/routes/presentation/route_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }
      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/routes',
            builder: (context, state) => const RouteScreen(),
          ),
          GoRoute(
            path: '/history',
            builder: (context, state) => const HistoryScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/route-map',
            builder: (context, state) {
              final route =
                  state.extra as OptimizedRoute? ??
                  const OptimizedRoute(
                    id: 'RTE-001',
                    driverId: 'DRV-001',
                    vehicleId: 'VEH-101',
                    status: 'aktif',
                    version: 1,
                    totalStops: 0,
                    estimatedDistanceKm: 0,
                    estimatedDurationMinutes: 0,
                    optimizationExecutedAt: null,
                    stops: [],
                    routeGeometry: [],
                    depot: LatLng(0, 0),
                  );
              return RouteMapScreen(route: route);
            },
          ),
          GoRoute(
            path: '/route-sequence',
            builder: (context, state) {
              final route =
                  state.extra as OptimizedRoute? ??
                  const OptimizedRoute(
                    id: 'RTE-001',
                    driverId: 'DRV-001',
                    vehicleId: 'VEH-101',
                    status: 'aktif',
                    version: 1,
                    totalStops: 0,
                    estimatedDistanceKm: 0,
                    estimatedDurationMinutes: 0,
                    optimizationExecutedAt: null,
                    stops: [],
                    routeGeometry: [],
                    depot: LatLng(0, 0),
                  );
              return DeliverySequenceScreen(route: route);
            },
          ),
          GoRoute(
            path: '/active-delivery',
            builder: (context, state) {
              final route =
                  state.extra as OptimizedRoute? ??
                  const OptimizedRoute(
                    id: 'RTE-001',
                    driverId: 'DRV-001',
                    vehicleId: 'VEH-101',
                    status: 'aktif',
                    version: 1,
                    totalStops: 0,
                    estimatedDistanceKm: 0,
                    estimatedDurationMinutes: 0,
                    optimizationExecutedAt: null,
                    stops: [],
                    routeGeometry: [],
                    depot: LatLng(0, 0),
                  );
              return ActiveDeliveryScreen(route: route);
            },
          ),
          GoRoute(
            path: '/delivery/:id',
            builder: (context, state) {
              final stop = state.extra as DeliveryStop?;
              if (stop == null) {
                return const Scaffold(
                  body: Center(child: Text('Detail pengiriman tidak tersedia')),
                );
              }
              return DeliveryDetailScreen(delivery: stop);
            },
          ),
        ],
      ),
    ],
  );
});

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    final currentIndex = _locationToIndex(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
              break;
            case 1:
              context.go('/routes');
              break;
            case 2:
              context.go('/history');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Beranda',
          ),
          NavigationDestination(icon: Icon(Icons.route_rounded), label: 'Rute'),
          NavigationDestination(
            icon: Icon(Icons.history_rounded),
            label: 'Riwayat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  int _locationToIndex(String location) {
    switch (location) {
      case '/routes':
        return 1;
      case '/history':
        return 2;
      case '/profile':
        return 3;
      case '/':
      default:
        return 0;
    }
  }
}
