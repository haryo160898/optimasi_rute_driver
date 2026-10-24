import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import 'auth/data/auth_repository.dart';
import 'auth/domain/auth_session.dart';
import 'routes/data/route_repository.dart';
import 'routes/domain/route_models.dart';

final appConfigProvider = Provider<AppConfig>((ref) => const AppConfig());

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final config = ref.watch(appConfigProvider);
  return ApiClient(baseUrl: config.baseUrl);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  final apiClient = ref.watch(apiClientProvider);
  final config = ref.watch(appConfigProvider);
  return AuthRepository(storage: storage, apiClient: apiClient, config: config);
});

final routeRepositoryProvider = Provider<RouteRepository>((ref) {
  final config = ref.watch(appConfigProvider);
  return RouteRepository(config: config);
});

final authStateProvider =
    StateNotifierProvider<AuthController, AsyncValue<AuthSession?>>((ref) {
      final repository = ref.watch(authRepositoryProvider);
      return AuthController(repository);
    });

final driverProfileProvider = FutureProvider<DriverProfile>((ref) {
  final repository = ref.watch(routeRepositoryProvider);
  return repository.getDriverProfile();
});

final activeRouteProvider = FutureProvider<OptimizedRoute>((ref) {
  final repository = ref.watch(routeRepositoryProvider);
  return repository.getActiveRoute();
});

final historyProvider = FutureProvider<List<DeliveryHistoryEntry>>((ref) {
  final repository = ref.watch(routeRepositoryProvider);
  return repository.getHistory();
});

class AuthController extends StateNotifier<AsyncValue<AuthSession?>> {
  AuthController(this._repository) : super(const AsyncValue.data(null));

  final AuthRepository _repository;

  Future<void> signIn({
    required String username,
    required String password,
  }) async {
    state = const AsyncValue.loading();
    try {
      final session = await _repository.login(username, password);
      state = AsyncValue.data(session);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await _repository.logout();
      state = const AsyncValue.data(null);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
