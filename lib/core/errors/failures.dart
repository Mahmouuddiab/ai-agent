import 'package:equatable/equatable.dart';

/// Base Failure class for Clean Architecture.
/// All domain-level errors extend this class.
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure(this.message, {this.statusCode});

  @override
  List<Object?> get props => [message, statusCode];
}

/// Returned when an API, remote database, or HTTP network request fails.
class ServerFailure extends Failure {
  const ServerFailure(
      super.message, {
        super.statusCode,
      });
}

/// Returned when a local database (Hive, SQLite, Shared Preferences) read/write fails.
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to access local cache']);
}

/// Returned when there is no active internet connection.
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No Internet Connection']);
}

/// Returned when user authentication or permission check fails.
class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed']);
}

/// Returned when data mapping, JSON decoding, or validation fails.
class ParsingFailure extends Failure {
  const ParsingFailure([super.message = 'Failed to parse response data']);
}