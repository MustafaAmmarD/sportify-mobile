import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sportify/core/localization/cubit/locale_cubit.dart';

/// A segmented button to switch between EN, DE, and AR.
class LanguageSwitcher extends StatelessWidget {
  const LanguageSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final currentLocale = context.watch<LocaleCubit>().state.languageCode;

    return SegmentedButton<String>(
      segments: const [
        ButtonSegment(value: 'en', label: Text('EN')),
        ButtonSegment(value: 'de', label: Text('DE')),
        ButtonSegment(value: 'ar', label: Text('عربي')),
      ],
      selected: {currentLocale},
      onSelectionChanged: (set) {
        context.read<LocaleCubit>().setLocale(set.first);
      },
    );
  }
}
