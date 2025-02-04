import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

/// A widget that displays a loading indicator for a profile item.
class ProfileItemLoading extends StatelessWidget {
  /// Creates a [ProfileItemLoading] widget.
  const ProfileItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CardLoading(
          margin: const EdgeInsets.all(16),
          borderRadius: BorderRadius.circular(12),
          height: 75,
          width: double.infinity),
    );
  }
}