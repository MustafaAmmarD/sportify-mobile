import 'package:flutter/material.dart';

/// Top horizontal strip displaying verified international sources.
class NewsSourcesStrip extends StatelessWidget {
  const NewsSourcesStrip({super.key});

  @override
  Widget build(BuildContext context) {
    const border = Color(0xFF1B2A38);

    Widget pill(String s) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFF111E2A),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: border),
          ),
          child: Text(
            s,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        );

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text(
            'International sources',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          pill('BBC Sport'),
          pill('The Guardian'),
          pill('Sky Sports'),
          pill('90min'),
        ],
      ),
    );
  }
}
