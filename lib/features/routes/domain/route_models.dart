import 'package:latlong2/latlong.dart';

enum DeliveryStatus {
  waiting,
  inProgress,
  completed,
  failed;

  static DeliveryStatus fromJson(String? value) {
    switch (value?.toLowerCase()) {
      case 'in_progress':
      case 'inprogress':
      case 'sedang diproses':
        return DeliveryStatus.inProgress;
      case 'completed':
      case 'selesai':
        return DeliveryStatus.completed;
      case 'failed':
      case 'gagal':
        return DeliveryStatus.failed;
      case 'waiting':
      case 'menunggu':
      default:
        return DeliveryStatus.waiting;
    }
  }

  String get label {
    switch (this) {
      case DeliveryStatus.waiting:
        return 'Menunggu';
      case DeliveryStatus.inProgress:
        return 'Sedang Diproses';
      case DeliveryStatus.completed:
        return 'Selesai';
      case DeliveryStatus.failed:
        return 'Gagal';
    }
  }
}

class DriverProfile {
  const DriverProfile({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleId,
    required this.vehicleName,
    required this.status,
    required this.lastSyncAt,
  });

  final String id;
  final String name;
  final String phone;
  final String vehicleId;
  final String vehicleName;
  final String status;
  final DateTime lastSyncAt;

  factory DriverProfile.fromJson(Map<String, dynamic> json) {
    return DriverProfile(
      id: json['id'] as String? ?? 'DRV-001',
      name: json['name'] as String? ?? 'Rafi Pratama',
      phone: json['phone'] as String? ?? '081234567890',
      vehicleId: json['vehicleId'] as String? ?? 'VEH-101',
      vehicleName: json['vehicleName'] as String? ?? 'Honda Brio 2024',
      status: json['status'] as String? ?? 'Aktif',
      lastSyncAt:
          DateTime.tryParse(json['lastSyncAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }
}

class DeliveryStop {
  const DeliveryStop({
    required this.id,
    required this.sequence,
    required this.customerName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.estimatedArrival,
    required this.timeWindowStart,
    required this.timeWindowEnd,
    required this.status,
    required this.distanceFromPreviousKm,
    required this.instructions,
  });

  final String id;
  final int sequence;
  final String customerName;
  final String address;
  final double latitude;
  final double longitude;
  final DateTime estimatedArrival;
  final String? timeWindowStart;
  final String? timeWindowEnd;
  final DeliveryStatus status;
  final double? distanceFromPreviousKm;
  final String instructions;

  factory DeliveryStop.fromJson(Map<String, dynamic> json) {
    return DeliveryStop(
      id: json['id'] as String? ?? 'stop_${json['sequence'] ?? 0}',
      sequence: (json['sequence'] as num?)?.toInt() ?? 0,
      customerName: json['customerName'] as String? ?? 'Pelanggan',
      address: json['address'] as String? ?? 'Alamat belum tersedia',
      latitude: (json['latitude'] as num?)?.toDouble() ?? -6.1751,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 106.8272,
      estimatedArrival:
          DateTime.tryParse(json['estimatedArrival'] as String? ?? '') ??
          DateTime.now(),
      timeWindowStart: json['timeWindowStart'] as String?,
      timeWindowEnd: json['timeWindowEnd'] as String?,
      status: DeliveryStatus.fromJson(json['status'] as String?),
      distanceFromPreviousKm: (json['distanceFromPreviousKm'] as num?)
          ?.toDouble(),
      instructions:
          json['instructions'] as String? ??
          'Silakan cek dan konfirmasi pengiriman.',
    );
  }

  LatLng get latLng => LatLng(latitude, longitude);
}

class OptimizedRoute {
  const OptimizedRoute({
    required this.id,
    required this.driverId,
    required this.vehicleId,
    required this.status,
    required this.version,
    required this.totalStops,
    required this.estimatedDistanceKm,
    required this.estimatedDurationMinutes,
    required this.optimizationExecutedAt,
    required this.stops,
    required this.routeGeometry,
    required this.depot,
  });

  final String id;
  final String driverId;
  final String vehicleId;
  final String status;
  final int version;
  final int totalStops;
  final double? estimatedDistanceKm;
  final int? estimatedDurationMinutes;
  final DateTime? optimizationExecutedAt;
  final List<DeliveryStop> stops;
  final List<LatLng> routeGeometry;
  final LatLng depot;

  factory OptimizedRoute.fromJson(Map<String, dynamic> json) {
    final stopsJson = (json['stops'] as List<dynamic>? ?? const <dynamic>[])
        .map((item) => DeliveryStop.fromJson(item as Map<String, dynamic>))
        .toList();

    final geometryJson =
        (json['routeGeometry'] as List<dynamic>? ?? const <dynamic>[]).map((
          item,
        ) {
          if (item is Map) {
            final map = Map<String, dynamic>.from(item);
            return LatLng(
              (map['latitude'] as num?)?.toDouble() ??
                  (map['lat'] as num?)?.toDouble() ??
                  0,
              (map['longitude'] as num?)?.toDouble() ??
                  (map['lng'] as num?)?.toDouble() ??
                  0,
            );
          }
          return LatLng(0, 0);
        }).toList();

    final depotMap = json['depot'] as Map<String, dynamic>? ?? const {};

    return OptimizedRoute(
      id: json['id'] as String? ?? 'RTE-001',
      driverId: json['driverId'] as String? ?? 'DRV-001',
      vehicleId: json['vehicleId'] as String? ?? 'VEH-101',
      status: json['status'] as String? ?? 'active',
      version: (json['version'] as num?)?.toInt() ?? 1,
      totalStops: (json['totalStops'] as num?)?.toInt() ?? stopsJson.length,
      estimatedDistanceKm: (json['estimatedDistanceKm'] as num?)?.toDouble(),
      estimatedDurationMinutes: (json['estimatedDurationMinutes'] as num?)
          ?.toInt(),
      optimizationExecutedAt:
          DateTime.tryParse(json['optimizationExecutedAt'] as String? ?? '') ??
          DateTime.now(),
      stops: stopsJson,
      routeGeometry: geometryJson,
      depot: LatLng(
        (depotMap['latitude'] as num?)?.toDouble() ?? -6.1751,
        (depotMap['longitude'] as num?)?.toDouble() ?? 106.8272,
      ),
    );
  }
}

class DeliveryHistoryEntry {
  const DeliveryHistoryEntry({
    required this.routeId,
    required this.date,
    required this.totalDeliveries,
    required this.completed,
    required this.failed,
    required this.status,
  });

  final String routeId;
  final DateTime date;
  final int totalDeliveries;
  final int completed;
  final int failed;
  final String status;

  factory DeliveryHistoryEntry.fromJson(Map<String, dynamic> json) {
    return DeliveryHistoryEntry(
      routeId: json['routeId'] as String? ?? 'RTE-001',
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      totalDeliveries: (json['totalDeliveries'] as num?)?.toInt() ?? 0,
      completed: (json['completed'] as num?)?.toInt() ?? 0,
      failed: (json['failed'] as num?)?.toInt() ?? 0,
      status: json['status'] as String? ?? 'Selesai',
    );
  }
}
