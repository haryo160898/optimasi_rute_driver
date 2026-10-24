import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/error_view.dart';
import '../../../core/widgets/loading_view.dart';
import '../../../core/widgets/status_badge.dart';
import '../../app_providers.dart';
import '../../routes/domain/route_models.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverAsync = ref.watch(driverProfileProvider);
    final routeAsync = ref.watch(activeRouteProvider);

    return Scaffold(
      body: SafeArea(
        child: driverAsync.when(
          data: (driver) => routeAsync.when(
            data: (route) => _DashboardContent(driver: driver, route: route),
            loading: () => const LoadingView(message: 'Memuat rute aktif...'),
            error: (error, stackTrace) => ErrorView(message: error.toString()),
          ),
          loading: () => const LoadingView(message: 'Memuat profil driver...'),
          error: (error, stackTrace) => ErrorView(message: error.toString()),
        ),
      ),
    );
  }
}

class _DashboardContent extends StatelessWidget {
  const _DashboardContent({required this.driver, required this.route});

  final DriverProfile driver;
  final OptimizedRoute route;

  @override
  Widget build(BuildContext context) {
    final currentHour = DateTime.now().hour;
    final greeting = currentHour < 12
        ? 'Selamat pagi'
        : currentHour < 18
        ? 'Selamat siang'
        : 'Selamat malam';

    final progress = route.totalStops > 0
        ? ((route.stops
                          .where(
                            (stop) => stop.status == DeliveryStatus.completed,
                          )
                          .length /
                      route.totalStops) *
                  100)
              .round()
        : 0;

    return RefreshIndicator(
      onRefresh: () async =>
          Future<void>.delayed(const Duration(milliseconds: 300)),
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      driver.name,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ],
                ),
              ),
              CircleAvatar(
                radius: 26,
                backgroundColor: AppTheme.navy,
                child: const Icon(Icons.person, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Driver ID',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            driver.id,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 14),
                          StatusBadge(
                            label: driver.status,
                            color: AppTheme.primaryGreen,
                          ),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kendaraan',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            driver.vehicleName,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            driver.vehicleId,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.4,
            children: [
              _SummaryCard(
                label: 'Total Pengiriman',
                value: route.totalStops.toString(),
              ),
              _SummaryCard(
                label: 'Selesai',
                value: route.stops
                    .where((s) => s.status == DeliveryStatus.completed)
                    .length
                    .toString(),
                color: AppTheme.primaryGreen,
              ),
              _SummaryCard(
                label: 'Belum Selesai',
                value: route.stops
                    .where((s) => s.status != DeliveryStatus.completed)
                    .length
                    .toString(),
                color: AppTheme.primaryOrange,
              ),
              _SummaryCard(
                label: 'Gagal',
                value: route.stops
                    .where((s) => s.status == DeliveryStatus.failed)
                    .length
                    .toString(),
                color: AppTheme.primaryRed,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Rute Aktif',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                      StatusBadge(
                        label: route.status.toUpperCase(),
                        color: AppTheme.primaryGreen,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      _MetricTile(label: 'Route ID', value: route.id),
                      _MetricTile(
                        label: 'Total Titik',
                        value: '${route.totalStops} titik',
                      ),
                      _MetricTile(
                        label: 'Jarak',
                        value: route.estimatedDistanceKm != null
                            ? '${route.estimatedDistanceKm!.toStringAsFixed(1)} km'
                            : 'Belum tersedia',
                      ),
                      _MetricTile(
                        label: 'Durasi',
                        value: route.estimatedDurationMinutes != null
                            ? '${route.estimatedDurationMinutes} menit'
                            : 'Belum tersedia',
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5FF),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: CustomPaint(
                            painter: _RoutePreviewPainter(route),
                          ),
                        ),
                        Positioned(
                          right: 14,
                          bottom: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text('$progress%'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton(
                          onPressed: () =>
                              context.push('/route-map', extra: route),
                          child: const Text('Lihat Rute'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () =>
                              context.push('/active-delivery', extra: route),
                          child: const Text('Mulai Pengiriman'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Tujuan Berikutnya',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Text(DateFormat('dd MMM yyyy').format(DateTime.now())),
            ],
          ),
          const SizedBox(height: 12),
          ...route.stops.take(3).map((stop) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppTheme.navy,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${stop.sequence}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Estimasi: ${DateFormat('HH:mm').format(stop.estimatedArrival)}',
                          style: const TextStyle(color: AppTheme.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        context.push('/delivery/${stop.id}', extra: stop),
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Text(
            'Sinkronisasi terakhir: ${DateFormat('dd MMM yyyy, HH:mm').format(driver.lastSyncAt)}',
            style: const TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    this.color = AppTheme.navy,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 12),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _RoutePreviewPainter extends CustomPainter {
  _RoutePreviewPainter(this.route);

  final OptimizedRoute route;

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppTheme.navy
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    final points = route.routeGeometry.map((point) {
      final x = ((point.longitude + 106.8) / 0.08) * size.width;
      final y = ((-point.latitude + 6.15) / 0.12) * size.height;
      return Offset(x.clamp(0, size.width), y.clamp(0, size.height));
    }).toList();

    if (points.length > 1) {
      final path = Path()..moveTo(points.first.dx, points.first.dy);
      for (final point in points.skip(1)) {
        path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(path, linePaint);
    }

    final markerPaint = Paint()..color = AppTheme.primaryGreen;
    for (final point in points) {
      canvas.drawCircle(point, 6, markerPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _RoutePreviewPainter oldDelegate) => false;
}
