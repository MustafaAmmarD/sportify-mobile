import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/fitpass/domain/entities/fitpass_entities.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_booking_and_training.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_digital_card.dart';

/// Renders a partner gym, pool, or sports club card with booking & QR check-in.
class FitPassPartnerCard extends StatelessWidget {
  const FitPassPartnerCard({super.key, required this.partner});

  final FitPassPartner partner;

  IconData get _typeIcon {
    final t = partner.type.toLowerCase();
    if (t.contains('pool')) return Icons.pool_rounded;
    if (t.contains('yoga')) return Icons.self_improvement_rounded;
    return Icons.fitness_center_rounded;
  }

  void _openCheckIn(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0E1822),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => FitPassQrSheet(venueName: partner.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: green.withValues(alpha: 0.3)),
                ),
                child: Icon(_typeIcon, color: green, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            partner.name,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFACC15).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star_rounded, color: Color(0xFFFACC15), size: 12),
                              const SizedBox(width: 2),
                              Text(
                                partner.rating.toStringAsFixed(1),
                                style: const TextStyle(color: Color(0xFFFACC15), fontSize: 11, fontWeight: FontWeight.w800),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(partner.address, style: const TextStyle(color: Colors.white54, fontSize: 12), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(6)),
                          child: Text(partner.type, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600)),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.near_me_rounded, color: green, size: 12),
                        const SizedBox(width: 3),
                        Text('${partner.distanceKm.toStringAsFixed(1)} km away', style: const TextStyle(color: Colors.white60, fontSize: 11, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => showFitPassBookingSheet(context, partner),
                  icon: const Icon(Icons.calendar_month_rounded, size: 16, color: Colors.white70),
                  label: const Text('Book Slot', style: TextStyle(color: Colors.white, fontSize: 12.5, fontWeight: FontWeight.w800)),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: border),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _openCheckIn(context),
                  icon: const Icon(Icons.qr_code_scanner_rounded, size: 16, color: Colors.black),
                  label: const Text('Check in', style: TextStyle(color: Colors.black, fontSize: 12.5, fontWeight: FontWeight.w900)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    elevation: 0,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Interactive tab view for discovering nearby FIT-Pass partner venues.
class FitPassPartnersSection extends StatefulWidget {
  const FitPassPartnersSection({super.key, required this.partners});

  final List<FitPassPartner> partners;

  @override
  State<FitPassPartnersSection> createState() => _FitPassPartnersSectionState();
}

class _FitPassPartnersSectionState extends State<FitPassPartnersSection> {
  final _searchController = TextEditingController();
  String _selectedType = 'All';
  bool _showMap = true;

  static const _types = ['All', 'Gym', 'Pool', 'Yoga Studio'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FitPassPartner> get _filtered {
    final q = _searchController.text.trim().toLowerCase();
    return widget.partners.where((p) {
      final matchesType = _selectedType == 'All' || p.type.toLowerCase() == _selectedType.toLowerCase();
      final matchesQuery = q.isEmpty || '${p.name} ${p.address} ${p.type}'.toLowerCase().contains(q);
      return matchesType && matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822), border = Color(0xFF1B2A38), green = AppColors.green2;
    final list = _filtered;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: const TextStyle(color: Colors.white, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Search gyms, pools, or studios...',
                  hintStyle: const TextStyle(color: Colors.white38),
                  prefixIcon: const Icon(Icons.search_rounded, color: Colors.white38),
                  filled: true,
                  fillColor: card,
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: green)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() => _showMap = !_showMap),
              child: Container(
                height: 46,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: _showMap ? green.withValues(alpha: 0.15) : card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _showMap ? green : border),
                ),
                child: Icon(_showMap ? Icons.map_rounded : Icons.map_outlined, color: _showMap ? green : Colors.white70, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_showMap && list.isNotEmpty)
          FitPassDiscoveryMapCard(
            partners: list,
            onBookPartner: (p) => showFitPassBookingSheet(context, p),
          ),
        SizedBox(
          height: 34,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _types.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, i) {
              final t = _types[i];
              final sel = t == _selectedType;
              return GestureDetector(
                onTap: () => setState(() => _selectedType = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: sel ? green.withValues(alpha: 0.15) : card,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: sel ? green : border),
                  ),
                  child: Text(t, style: TextStyle(color: sel ? green : Colors.white70, fontSize: 12, fontWeight: FontWeight.w700)),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        if (list.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('No matching partner locations found.', style: TextStyle(color: Colors.white54, fontSize: 13))),
          )
        else
          ...list.map((p) => FitPassPartnerCard(partner: p)),
      ],
    );
  }
}
