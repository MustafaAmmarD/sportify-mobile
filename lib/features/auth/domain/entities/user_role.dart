import 'package:freezed_annotation/freezed_annotation.dart';

/// The 7 user roles defined in the Phase 1 MVP Roadmap.
enum UserRole {
  @JsonValue('player')
  player,
  @JsonValue('club')
  club,
  @JsonValue('agent')
  agent,
  @JsonValue('scout')
  scout,
  @JsonValue('coach')
  coach,
  @JsonValue('fan')
  fan,
  @JsonValue('company_hr')
  companyHr,
}
