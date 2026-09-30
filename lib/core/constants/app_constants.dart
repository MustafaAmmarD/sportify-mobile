/// App-wide constants that don't belong to a specific feature.
abstract class AppConstants {
  /// Application name displayed in UI.
  static const String appName = 'Sportify';

  /// Default club ID used for shortlist operations.
  /// Tony hardcoded this for the evaluation demo.
  /// TODO(mustafa): Confirm with Tony if this will become dynamic.
  static const int defaultClubId = 1;

  /// Connection timeout for API requests (in milliseconds).
  static const int connectionTimeout = 15000;

  /// Receive timeout for API requests (in milliseconds).
  static const int receiveTimeout = 15000;
}
