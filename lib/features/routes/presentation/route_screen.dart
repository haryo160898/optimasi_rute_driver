import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../app_providers.dart';
import '../domain/route_models.dart';

class RouteScreen extends ConsumerWidget {
  const RouteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeAsync = ref.watch(activeRouteProvider);

    return routeAsync.when(
      data: (route) => _RouteContent(route: route),
      loading: () => const LoadingView(message: 'Memuat rute saya...'),
      error: (error, stackTrace) => ErrorView(message: error.toString()),
    );
  }
}

class _RouteContent extends StatelessWidget {
  const _RouteContent({required this.route});

  final OptimizedRoute route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Rute Saya',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                StatusBadge(
                  label: route.status.toUpperCase(),
                  color: const Color(0xFF1DBA73),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ringkasan Rute',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(label: 'Route ID', value: route.id),
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
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.push('/route-map', extra: route),
                    child: const Text('Lihat Peta'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () =>
                        context.push('/route-sequence', extra: route),
                    child: const Text('Urutan Pengiriman'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('Tujuan', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...route.stops.map(
              (stop) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: const Color(0xFF112B46),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          '${stop.sequence}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            stop.customerName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            stop.address,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () =>
                          context.push('/delivery/${stop.id}', extra: stop),
                      icon: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
