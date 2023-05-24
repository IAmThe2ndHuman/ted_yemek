import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

class AppError extends Equatable implements Exception {
  final String title;
  final String description;
  final String? details;
  final IconData? icon;
  final void Function()? customCallback;

  const AppError(this.title, this.description, [this.details, this.icon, this.customCallback]);

  @override
  List<Object?> get props => [title, description, details, icon, customCallback];
}
