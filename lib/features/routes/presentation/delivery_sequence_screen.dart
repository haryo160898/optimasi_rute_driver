import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/status_badge.dart';
import '../domain/route_models.dart';

class DeliverySequenceScreen extends StatelessWidget {
  const DeliverySequenceScreen({super.key, required this.route});

  final OptimizedRoute route;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Urutan Pengiriman')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: route.stops.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final stop = route.stops[index];
          final statusColor = stop.status == DeliveryStatus.completed
              ? const Color(0xFF1DBA73)
              : stop.status == DeliveryStatus.failed
              ? const Color(0xFFE11D48)
              : stop.status == DeliveryStatus.inProgress
              ? const Color(0xFFF59E0B)
              : const Color(0xFF112B46);

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFF112B46),
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
                        const SizedBox(height: 6),
                        Text(
                          stop.address,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time_rounded, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('HH:mm').format(stop.estimatedArrival),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        StatusBadge(
                          label: stop.status.label,
                          color: statusColor,
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
            ),
          );
        },
      ),
    );
  }
}
