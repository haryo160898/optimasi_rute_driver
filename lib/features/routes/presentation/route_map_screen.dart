import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/status_badge.dart';
import '../domain/route_models.dart';

class RouteMapScreen extends StatelessWidget {
  const RouteMapScreen({super.key, required this.route});

  final OptimizedRoute route;

  @override
  Widget build(BuildContext context) {
    final center = route.routeGeometry.isNotEmpty
        ? route.routeGeometry.first
        : route.depot;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Rute'),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt_rounded),
            onPressed: () => context.push('/route-sequence', extra: route),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FlutterMap(
              options: MapOptions(initialCenter: center, initialZoom: 11),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.optimasi_rute_driver',
                ),
                if (route.routeGeometry.isNotEmpty)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: route.routeGeometry,
                        strokeWidth: 5,
                        color: const Color(0xFF112B46),
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: route.depot,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_history_rounded,
                        color: Colors.green,
                      ),
                    ),
                    ...route.stops.map(
                      (stop) => Marker(
                        point: stop.latLng,
                        width: 42,
                        height: 42,
                        child: CircleAvatar(
                          backgroundColor:
                              stop.status == DeliveryStatus.completed
                              ? Colors.green
                              : stop.status == DeliveryStatus.inProgress
                              ? Colors.orange
                              : Colors.grey,
                          radius: 16,
                          child: Text(
                            '${stop.sequence}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Ringkasan Rute',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        StatusBadge(
                          label: route.status.toUpperCase(),
                          color: const Color(0xFF1DBA73),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(label: 'ID Rute', value: route.id),
                    _InfoRow(
                      label: 'Jumlah Tujuan',
                      value: '${route.totalStops}',
                    ),
                    _InfoRow(
                      label: 'Jarak Estimasi',
                      value: route.estimatedDistanceKm != null
                          ? '${route.estimatedDistanceKm!.toStringAsFixed(1)} km'
                          : 'Belum tersedia',
                    ),
                    _InfoRow(
                      label: 'Durasi Estimasi',
                      value: route.estimatedDurationMinutes != null
                          ? '${route.estimatedDurationMinutes} menit'
                          : 'Belum tersedia',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF54677A)),
            ),
          ),
          Expanded(flex: 3, child: Text(value, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}
