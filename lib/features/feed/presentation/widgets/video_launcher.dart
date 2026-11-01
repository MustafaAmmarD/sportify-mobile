import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens a video URL directly in the YouTube app (or the browser as fallback).
///
/// Never throws: failures are reported through a SnackBar instead of crashing.
Future<void> openVideoUrl(BuildContext context, String url) async {
  final messenger = ScaffoldMessenger.maybeOf(context);
  final uri = Uri.tryParse(url);
  if (uri == null || url.isEmpty) {
    messenger?.showSnackBar(const SnackBar(content: Text('Video link is invalid.')));
    return;
  }
  try {
    var ok = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!ok) ok = await launchUrl(uri, mode: LaunchMode.platformDefault);
    if (!ok) {
      messenger?.showSnackBar(const SnackBar(content: Text('Could not open the video.')));
    }
  } catch (_) {
    messenger?.showSnackBar(const SnackBar(content: Text('Could not open the video.')));
  }
}

