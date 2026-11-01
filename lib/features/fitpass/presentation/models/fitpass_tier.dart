import 'package:flutter/material.dart';

/// Represents a FIT-Pass subscription tier with display metadata.
class FitPassTier {
  const FitPassTier({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.monthlyPrice,
    required this.features,
    required this.color,
    this.category = 'Players',
    this.isPopular = false,
  });

  final String id;
  final String name;
  final String subtitle;
  final double monthlyPrice;
  final List<String> features;
  final Color color;
  final String category;
  final bool isPopular;

  static const List<String> categories = [
    'Players',
    'Youth & Family',
    'Pro & Clubs',
  ];

  static const List<FitPassTier> all = [
    FitPassTier(
      id: 'digital',
      name: 'Digital',
      subtitle: 'Online-only access',
      monthlyPrice: 5,
      color: Color(0xFF38BDF8),
      category: 'Players',
      features: [
        'Online courses',
        'Wellness content',
        'Community access',
        'Mobile-first learning',
      ],
    ),
    FitPassTier(
      id: 'bronze',
      name: 'Bronze',
      subtitle: 'Start your journey',
      monthlyPrice: 9,
      color: Color(0xFFF97316),
      category: 'Players',
      features: [
        'Basic training plans',
        'Community access',
        'Profile listing',
        'Limited highlight uploads',
      ],
    ),
    FitPassTier(
      id: 'silver',
      name: 'Silver',
      subtitle: 'Most popular for players',
      monthlyPrice: 19,
      color: Color(0xFF94A3B8),
      category: 'Players',
      isPopular: true,
      features: [
        'All Bronze features',
        'Partner gym access',
        'Unlimited highlights',
        'Performance tracking',
        'Priority in search',
      ],
    ),
    FitPassTier(
      id: 'gold',
      name: 'Gold',
      subtitle: 'Elite development',
      monthlyPrice: 39,
      color: Color(0xFFF59E0B),
      category: 'Players',
      features: [
        'All Silver features',
        'Online courses library',
        'Wellness & nutrition',
        '1:1 coaching credits',
        'Verified profile badge',
      ],
    ),
    FitPassTier(
      id: 'platinum',
      name: 'Platinum',
      subtitle: 'Semi-pro & pro pathway',
      monthlyPrice: 79,
      color: Color(0xFFA78BFA),
      category: 'Players',
      features: [
        'All Gold features',
        'Agent introduction credits',
        'Media pack export',
        'Priority club matching',
        'Dedicated support line',
      ],
    ),
    FitPassTier(
      id: 'youth',
      name: 'Youth',
      subtitle: 'For players under 18',
      monthlyPrice: 7,
      color: Color(0xFFFACC15),
      category: 'Youth & Family',
      features: [
        'Age-appropriate training',
        'Parent dashboard',
        'Academy finder',
        '5 highlight uploads',
        'Safeguarding tools',
      ],
    ),
    FitPassTier(
      id: 'family',
      name: 'Family',
      subtitle: 'Up to 4 linked profiles',
      monthlyPrice: 29,
      color: Color(0xFFEC4899),
      category: 'Youth & Family',
      isPopular: true,
      features: [
        '4 family member profiles',
        'Shared gym passes',
        'Family progress dashboard',
        'All Silver features',
        'Parent controls',
      ],
    ),
    FitPassTier(
      id: 'scout',
      name: 'Scout',
      subtitle: 'For scouts & agents',
      monthlyPrice: 59,
      color: Color(0xFF818CF8),
      category: 'Pro & Clubs',
      features: [
        'Advanced player search',
        'Export scouting reports',
        'Watchlist alerts',
        '50 contact credits/mo',
        'AI fit scores',
      ],
    ),
    FitPassTier(
      id: 'academy',
      name: 'Academy',
      subtitle: 'Youth academies & schools',
      monthlyPrice: 99,
      color: Color(0xFF34D399),
      category: 'Pro & Clubs',
      features: [
        'Squad management (30 players)',
        'Parent communication hub',
        'Trial day tools',
        'Progress reports',
        'Coach assignment',
      ],
    ),
    FitPassTier(
      id: 'club',
      name: 'Club+',
      subtitle: 'For clubs & academies',
      monthlyPrice: 149,
      color: Color(0xFF22C55E),
      category: 'Pro & Clubs',
      isPopular: true,
      features: [
        'AI recommendations',
        'Unlimited shortlists',
        'Squad analytics',
        'Recruitment dashboard',
        'Direct player contact',
      ],
    ),
    FitPassTier(
      id: 'enterprise',
      name: 'Enterprise',
      subtitle: 'Federations & multi-club groups',
      monthlyPrice: 249,
      color: Color(0xFF7C3AED),
      category: 'Pro & Clubs',
      features: [
        'Unlimited seats',
        'White-label reports',
        'API access',
        'Multi-site dashboard',
        'Dedicated success manager',
      ],
    ),
  ];
}
