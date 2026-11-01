import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sportify/features/auth/presentation/widgets/register_step_header.dart';
import 'package:sportify/features/feed/domain/entities/feed_post.dart';
import 'package:sportify/features/feed/presentation/pages/player_profile_page.dart';
import 'package:sportify/features/feed/presentation/widgets/feed_highlight_card.dart';

void main() {
  final samplePost = FeedPost.fromJson(const {
    'id': 'post_1',
    'authorId': 'player_finn_larsen',
    'authorName': 'Finn Larsen',
    'videoUrl': 'https://www.youtube.com/watch?v=aqz-KE-bpKQ',
    'positionCode': 'CAM',
    'positionFull': 'Attacking Midfielder',
    'jerseyNumber': 20,
    'fitScore': 91,
    'aiRating': 95,
    'age': 21,
    'nationality': 'Venezuela',
    'countryCode': 'VE',
    'countryFlag': '🇻🇪',
    'availabilityStatus': 'On Loan',
    'clubName': 'SV Werder Bremen',
    'clubCity': 'Bremen',
    'leagueName': 'Bundesliga',
    'clubCountry': 'Germany',
    'competitionLevel': 'Professional',
    'division': '1st division',
    'marketValue': '€7M',
    'preferredFoot': 'Left',
    'heightCm': 188,
    'languages': ['English', 'Arabic'],
    'goals': 13,
    'assists': 8,
    'appearances': 20,
    'minutesPlayed': 1360,
    'traits': ['Set-pieces', 'Vision'],
    'radarStats': {
      'pace': 91,
      'shooting': 93,
      'passing': 99,
      'dribbling': 99,
      'defending': 75,
      'physical': 90,
    },
    'transferWishes': [
      {
        'clubName': 'Juventus',
        'country': 'Italy',
        'league': 'Serie A',
        'tier': 'Elite',
      },
      {
        'clubName': 'Newcastle United',
        'country': 'England',
        'league': 'Premier League',
        'tier': 'Professional',
      },
      {
        'clubName': 'Inter Milan',
        'country': 'Italy',
        'league': 'Serie A',
        'tier': 'Elite',
      },
    ],
    'createdAt': '2026-10-28T08:30:00Z',
  });

  testWidgets('RegisterStepHeader renders labels properly', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RegisterStepHeader(
            current: 1,
            labels: ['Role', 'Details', 'Consent'],
          ),
        ),
      ),
    );

    expect(find.text('Role'), findsOneWidget);
    expect(find.text('Details'), findsOneWidget);
    expect(find.text('Consent'), findsOneWidget);
  });

  testWidgets(
    'FeedHighlightCard renders dynamic backend data and navigates to PlayerProfilePage',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: FeedHighlightCard(post: samplePost),
            ),
          ),
        ),
      );

      expect(find.text('Finn Larsen'), findsOneWidget);
      expect(find.text('CAM'), findsOneWidget);
      expect(find.text('91'), findsOneWidget);
      expect(find.text('SV Werder Bremen'), findsOneWidget);

      await tester.tap(find.text('View Profile'));
      await tester.pumpAndSettle();

      expect(find.byType(PlayerProfilePage), findsOneWidget);
      expect(find.text('#20'), findsOneWidget);
      expect(find.text('13'), findsOneWidget);
      expect(find.text('1,360'), findsOneWidget);
      expect(find.text('AI Profile Rating'), findsOneWidget);
      expect(find.text('95'), findsOneWidget);
      expect(find.text('Set-pieces'), findsOneWidget);
      expect(find.text('Vision'), findsOneWidget);
      expect(find.text('Juventus'), findsOneWidget);
      expect(find.text('Newcastle United'), findsOneWidget);
      expect(find.text('Inter Milan'), findsOneWidget);

      // Switch to Statistics tab and verify dynamic Per-90 & Market Value Trend
      await tester.tap(find.text('Statistics'));
      await tester.pumpAndSettle();

      expect(find.text('Season Output'), findsOneWidget);
      expect(find.text('0.86'), findsOneWidget);
      expect(find.text('0.53'), findsOneWidget);
      expect(find.text('21'), findsOneWidget);
      expect(find.text('Attribute Breakdown'), findsOneWidget);
      expect(find.text('Market Value Trend'), findsOneWidget);
      expect(find.text('Now €7M'), findsOneWidget);

      // Switch to Highlights tab and verify dynamic scouting reels
      await tester.tap(find.text('Highlights'));
      await tester.pumpAndSettle();

      expect(find.text('Watch Scouting Reel'), findsOneWidget);
      expect(find.text('Scouting Reels'), findsOneWidget);
      expect(find.text('3 clips'), findsOneWidget);

    },
  );
}
