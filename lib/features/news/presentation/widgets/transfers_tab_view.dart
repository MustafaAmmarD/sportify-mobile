import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/core/theme/app_colors.dart';
import 'package:sportify/features/news/domain/entities/news_entities.dart';
import 'package:sportify/features/news/presentation/bloc/news_bloc.dart';
import 'package:sportify/features/news/presentation/bloc/news_event.dart';
import 'package:sportify/features/news/presentation/bloc/news_state.dart';
import 'package:sportify/features/news/presentation/widgets/transfer_card.dart';
import 'package:sportify/features/news/presentation/widgets/transfer_market_trends.dart';

/// Tab view displaying football transfers with search, stage filtering, and infinite scroll.
class TransfersTabView extends StatefulWidget {
  const TransfersTabView({super.key, required this.state});

  final NewsLoaded state;

  @override
  State<TransfersTabView> createState() => _TransfersTabViewState();
}

class _TransfersTabViewState extends State<TransfersTabView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  String _stage = 'All';

  static const _stages = [
    'All',
    'Rumour',
    'Negotiating',
    'Advanced talks',
    'Here we go',
    'Confirmed',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final pos = _scrollController.position;
    if (pos.pixels >= pos.maxScrollExtent * 0.9) {
      context.read<NewsBloc>().add(LoadMoreTransfers());
    }
  }

  int _h(TransferActivity t) => t.id.hashCode.abs();

  String _stageOf(TransferActivity t) {
    final s = t.status.toLowerCase();
    if (s == 'confirmed') return 'Confirmed';
    if (s == 'loan' || s.contains('loan')) return 'Loan deal';
    const rest = ['Rumour', 'Negotiating', 'Advanced talks', 'Here we go'];
    return rest[_h(t) % rest.length];
  }

  double _feeM(TransferActivity t) {
    final m = RegExp(r'[\d.,]+').firstMatch(t.fee ?? '');
    if (m == null) return 0;
    return double.tryParse(m.group(0)!.replaceAll(',', '')) ?? 0;
  }

  List<TransferActivity> _filterTransfers(List<TransferActivity> all) {
    final q = _searchController.text.trim().toLowerCase();
    return all.where((t) {
      final okStage = _stage == 'All' || _stageOf(t) == _stage;
      final okQ = q.isEmpty ||
          '${t.playerName} ${t.fromClub} ${t.toClub}'.toLowerCase().contains(q);
      return okStage && okQ;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);

    final all = widget.state.transfers;
    final list = _filterTransfers(all);
    final total = all.fold<double>(0, (a, t) => a + _feeM(t));
    final confirmed = all.where((t) => _stageOf(t) == 'Confirmed').length;
    final top = ([...all]..sort((a, b) => _feeM(b).compareTo(_feeM(a)))).take(8).toList();

    return ListView(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      children: [
        const SizedBox(height: 4),
        TransferHeroHeader(
          totalCount: all.length,
          totalValueM: total,
          confirmedCount: confirmed,
        ),
        const SizedBox(height: 16),
        TransferMarketTrends(topTransfers: top),
        const SizedBox(height: 16),

        // Search bar
        TextField(
          controller: _searchController,
          onChanged: (_) => setState(() {}),
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: 'Search player or club...',
            hintStyle: const TextStyle(color: Colors.white38),
            prefixIcon: const Icon(Icons.search, color: Colors.white38),
            filled: true,
            fillColor: card,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: green),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Stage filter chips
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _stages.map((s) {
              final isSel = s == _stage;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ChoiceChip(
                  label: Text(s),
                  selected: isSel,
                  onSelected: (val) {
                    if (val) setState(() => _stage = s);
                  },
                  selectedColor: green,
                  backgroundColor: card,
                  labelStyle: TextStyle(
                    color: isSel ? Colors.black : Colors.white70,
                    fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // Transfer cards
        ...list.map((t) => TransferCard(transfer: t)),
        if (!widget.state.hasReachedMaxTransfers)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator(color: green)),
          ),
      ],
    );
  }
}
