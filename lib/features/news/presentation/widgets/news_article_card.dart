import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/news_entities.dart';
import 'news_matches_and_reader.dart';

Widget _buildNewsImage(NewsItem n, double height) {
  final placeholder = Container(
    height: height,
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF12202D), Color(0xFF0A131C)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
    ),
  );
  if (n.imageUrl == null) return placeholder;
  return Image.network(
    n.imageUrl!,
    height: height,
    width: double.infinity,
    fit: BoxFit.cover,
    errorBuilder: (_, __, ___) => placeholder,
  );
}

Widget _buildCategoryTag(String text, {bool green = false}) {
  const greenColor = AppColors.green2;
  const border = Color(0xFF1B2A38);

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: green ? greenColor.withOpacity(0.12) : const Color(0xFF070D14),
      borderRadius: BorderRadius.circular(6),
      border: Border.all(color: green ? greenColor.withOpacity(0.4) : border),
    ),
    child: Text(
      text.toUpperCase(),
      style: TextStyle(
        color: green ? greenColor : Colors.white,
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.6,
      ),
    ),
  );
}

/// Hero card highlighting the top/breaking news article.
class NewsHeroCard extends StatelessWidget {
  const NewsHeroCard({super.key, required this.item});

  final NewsItem item;

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);
    const green = AppColors.green2;

    return GestureDetector(
      onTap: () => showNewsArticleReaderSheet(context, item),
      child: Container(
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNewsImage(item, 200),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCategoryTag(item.category, green: true),
                  const SizedBox(height: 12),
                  Text(
                    item.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      height: 1.2,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.summary,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '${item.source} · ${item.publishedAt.toString().substring(0, 10)}',
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  const SizedBox(height: 10),
                  const Text('Read more →', style: TextStyle(color: green, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Standard compact news article card.
class NewsArticleCard extends StatelessWidget {
  const NewsArticleCard({super.key, required this.item});

  final NewsItem item;

  String _ago(DateTime d) {
    final diff = DateTime.now().difference(d);
    if (diff.inMinutes < 60) return '${diff.inMinutes.clamp(1, 59)}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);

    return GestureDetector(
      onTap: () => showNewsArticleReaderSheet(context, item),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
        ),
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              height: 100,
              child: _buildNewsImage(item, 100),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCategoryTag(item.category),
                    const SizedBox(height: 6),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.source} · ${_ago(item.publishedAt)}',
                      style: const TextStyle(color: Colors.white38, fontSize: 11),
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
