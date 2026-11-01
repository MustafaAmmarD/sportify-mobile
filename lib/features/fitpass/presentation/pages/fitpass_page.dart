import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/core/di/injection_container.dart';
import 'package:sportify/core/localization/sportify_l10n.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/fitpass/presentation/bloc/fitpass_bloc.dart';
import 'package:sportify/features/fitpass/presentation/bloc/fitpass_event.dart';
import 'package:sportify/features/fitpass/presentation/bloc/fitpass_state.dart';
import 'package:sportify/features/fitpass/presentation/models/fitpass_tier.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_booking_and_training.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_digital_card.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_features_section.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_partner_card.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_plan_card.dart';
import 'package:sportify/features/fitpass/presentation/widgets/fitpass_pricing_header.dart';

/// Mobile-first FIT-Pass hub featuring a digital wallet pass card,
/// nearby partner venue discovery, and categorized membership plans.
class FitPassPage extends StatelessWidget {
  const FitPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<FitPassBloc>()
        ..add(const FetchFitPassData(latitude: 52.52, longitude: 13.405)),
      child: const _FitPassView(),
    );
  }
}

class _FitPassView extends StatefulWidget {
  const _FitPassView();

  @override
  State<_FitPassView> createState() => _FitPassViewState();
}

class _FitPassViewState extends State<_FitPassView>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  bool _yearly = false;
  String _selectedCategory = FitPassTier.categories.first;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openQrSheet() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: const Color(0xFF0E1822),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const FitPassQrSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const bg = Color(0xFF070D14);
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;
    final tr = SportifyL10n.of(context);

    return ColoredBox(
      color: bg,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // ── Custom mobile header ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'FIT-Pass',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: _openQrSheet,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: card,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: border),
                      ),
                      child: const Icon(
                        Icons.qr_code_rounded,
                        color: green,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Active digital wallet pass card ──
            FitPassDigitalCard(onScanQr: _openQrSheet),
            const SizedBox(height: 16),

            // ── Segment toggle (Nearby Venues | Plans & Perks) ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    color: green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: green.withValues(alpha: 0.5)),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelColor: green,
                  unselectedLabelColor: Colors.white54,
                  labelStyle: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 13,
                  ),
                  dividerHeight: 0,
                  splashBorderRadius: BorderRadius.circular(10),
                  tabs: [
                    Tab(text: tr.fitPassTabVenues),
                    Tab(text: tr.fitPassTabTraining),
                    Tab(text: tr.fitPassTabPlans),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // ── Tab views ──
            Expanded(
              child: BlocBuilder<FitPassBloc, FitPassState>(
                builder: (context, state) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildVenuesTab(state),
                      const FitPassDigitalTrainingTab(),
                      _buildPlansTab(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVenuesTab(FitPassState state) {
    const green = AppColors.green2;
    if (state is FitPassInitial || state is FitPassLoading) {
      return const Center(child: CircularProgressIndicator(color: green));
    }
    if (state is FitPassError) {
      return Center(
        child: Text(
          state.message,
          style: const TextStyle(color: Colors.redAccent),
        ),
      );
    }
    if (state is FitPassLoaded) {
      return FitPassPartnersSection(partners: state.partners);
    }
    return const SizedBox.shrink();
  }

  Widget _buildPlansTab() {
    final plans = FitPassTier.all
        .where((p) => p.category == _selectedCategory)
        .toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 28),
      children: [
        const FitPassFeaturesSection(),
        const SizedBox(height: 20),
        FitPassPricingHeader(
          yearly: _yearly,
          onToggle: (val) => setState(() => _yearly = val),
          selectedCategory: _selectedCategory,
          onCategoryChanged: (cat) => setState(() => _selectedCategory = cat),
        ),
        const SizedBox(height: 14),
        ...plans.map(
          (plan) => FitPassPlanCard(
            key: ValueKey(plan.id),
            plan: plan,
            yearly: _yearly,
          ),
        ),
      ],
    );
  }
}
