import 'package:equatable/equatable.dart';

class AppError extends Equatable implements Exception {
  final String title;
  final String description;
  final String? details;

  const AppError(this.title, this.description, [this.details]);

  @override
  List<Object?> get props => [title, description, details];
}
