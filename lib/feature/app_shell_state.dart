import 'package:equatable/equatable.dart';

class AppShellState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppShellErrorState extends AppShellState {
  final String? message;

  AppShellErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
