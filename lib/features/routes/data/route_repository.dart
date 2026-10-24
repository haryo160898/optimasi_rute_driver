import 'package:latlong2/latlong.dart';

import '../../../core/config/app_config.dart';
import '../domain/route_models.dart';

class RouteRepository {
  RouteRepository({AppConfig? config}) : _config = config ?? const AppConfig();

  final AppConfig _config;

  Future<DriverProfile> getDriverProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (_config.mockMode) {
      return DriverProfile(
        id: 'DRV-001',
        name: 'Rafi Pratama',
        phone: '081234567890',
        vehicleId: 'VEH-101',
        vehicleName: 'Honda Brio 2024',
        status: 'Aktif',
        lastSyncAt: DateTime.now(),
      );
    }
    throw UnimplementedError('Backend integration belum dikonfigurasi.');
  }

  Future<OptimizedRoute> getActiveRoute() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (_config.mockMode) {
      return _buildMockRoute();
    }
    throw UnimplementedError('Backend integration belum dikonfigurasi.');
  }

  Future<List<DeliveryHistoryEntry>> getHistory() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (_config.mockMode) {
      return [
        DeliveryHistoryEntry(
          routeId: 'RTE-001',
          date: DateTime.now().subtract(const Duration(days: 2)),
          totalDeliveries: 12,
          completed: 10,
          failed: 1,
          status: 'Selesai',
        ),
        DeliveryHistoryEntry(
          routeId: 'RTE-002',
          date: DateTime.now().subtract(const Duration(days: 5)),
          totalDeliveries: 9,
          completed: 7,
          failed: 2,
          status: 'Ada kendala',
        ),
      ];
    }
    throw UnimplementedError('Backend integration belum dikonfigurasi.');
  }

  OptimizedRoute _buildMockRoute() {
    final stops = <DeliveryStop>[
      DeliveryStop(
        id: 'DEL-01',
        sequence: 1,
        customerName: 'PT Lestari Jaya',
        address: 'Jl. Merdeka No. 12, Jakarta Pusat',
        latitude: -6.2088,
        longitude: 106.8456,
        estimatedArrival: DateTime.now().add(const Duration(hours: 1)),
        timeWindowStart: '08:00',
        timeWindowEnd: '09:00',
        status: DeliveryStatus.inProgress,
        distanceFromPreviousKm: 0,
        instructions: 'Ambil dokumen dan serahkan ke security.',
      ),
      DeliveryStop(
        id: 'DEL-02',
        sequence: 2,
        customerName: 'Mitra Mart',
        address: 'Jl. Gatot Subroto No. 44, Jakarta Selatan',
        latitude: -6.2146,
        longitude: 106.8228,
        estimatedArrival: DateTime.now().add(
          const Duration(hours: 2, minutes: 20),
        ),
        timeWindowStart: '09:15',
        timeWindowEnd: '10:15',
        status: DeliveryStatus.waiting,
        distanceFromPreviousKm: 2.4,
        instructions: 'Pastikan paket diterima dengan tanda tangan.',
      ),
      DeliveryStop(
        id: 'DEL-03',
        sequence: 3,
        customerName: 'Bumi Sejahtera',
        address: 'Jl. TB Simatupang No. 73, Jakarta Selatan',
        latitude: -6.2597,
        longitude: 106.7813,
        estimatedArrival: DateTime.now().add(
          const Duration(hours: 3, minutes: 35),
        ),
        timeWindowStart: '10:30',
        timeWindowEnd: '12:00',
        status: DeliveryStatus.waiting,
        distanceFromPreviousKm: 4.1,
        instructions: 'Barang perlu dititipkan pada rak receiving.',
      ),
      DeliveryStop(
        id: 'DEL-04',
        sequence: 4,
        customerName: 'Rajawali Electric',
        address: 'Jl. Sudirman Kav. 25, Jakarta Pusat',
        latitude: -6.2002,
        longitude: 106.8223,
        estimatedArrival: DateTime.now().add(
          const Duration(hours: 4, minutes: 40),
        ),
        timeWindowStart: '11:45',
        timeWindowEnd: '13:00',
        status: DeliveryStatus.waiting,
        distanceFromPreviousKm: 6.5,
        instructions: 'Masuk melalui pintu utama lalu ke lantai 2.',
      ),
      DeliveryStop(
        id: 'DEL-05',
        sequence: 5,
        customerName: 'Nusa Transport',
        address: 'Jl. Kuningan Timur No. 10, Jakarta Selatan',
        latitude: -6.2305,
        longitude: 106.822,
        estimatedArrival: DateTime.now().add(
          const Duration(hours: 5, minutes: 50),
        ),
        timeWindowStart: '13:15',
        timeWindowEnd: '14:00',
        status: DeliveryStatus.completed,
        distanceFromPreviousKm: 3.4,
        instructions: 'Dokumen sudah diserahkan.',
      ),
    ];

    final routeGeometry = <LatLng>[
      const LatLng(-6.1837, 106.8171),
      const LatLng(-6.2088, 106.8456),
      const LatLng(-6.2146, 106.8228),
      const LatLng(-6.2597, 106.7813),
      const LatLng(-6.2002, 106.8223),
      const LatLng(-6.2305, 106.8220),
    ];

    return OptimizedRoute(
      id: 'RTE-2026-101',
      driverId: 'DRV-001',
      vehicleId: 'VEH-101',
      status: 'aktif',
      version: 4,
      totalStops: 5,
      estimatedDistanceKm: 18.7,
      estimatedDurationMinutes: 198,
      optimizationExecutedAt: DateTime.now().subtract(
        const Duration(minutes: 25),
      ),
      stops: stops,
      routeGeometry: routeGeometry,
      depot: const LatLng(-6.1837, 106.8171),
    );
  }
}
