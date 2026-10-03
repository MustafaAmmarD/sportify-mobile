/// Sportify API endpoint constants.
///
/// All API paths are defined here to avoid hardcoding strings
/// throughout the codebase.
abstract class ApiConstants {
  /// Base URL for the Sportify backend API.
  ///
  /// Currently pointing to Tony's evaluation backend on Render.
  /// This will be updated when a production server is available.
  static const String baseUrl = 'https://sportify-dashboard-4nyy.onrender.com';

  // ── Scouting Endpoints ──

  /// GET - Returns list of all players.
  /// Supports query params: position, search, sort_by, sort_dir
  static const String players = '/api/players';

  /// GET - Returns detailed stats for a single player.
  static String playerDetail(int id) => '/api/players/$id';

  /// GET - Returns the shortlist for a club.
  /// Requires query param: club_id
  static const String shortlist = '/api/shortlist';

  /// DELETE - Removes a player from the shortlist.
  static String removeFromShortlist(int playerId) => '/api/shortlist/$playerId';
}
