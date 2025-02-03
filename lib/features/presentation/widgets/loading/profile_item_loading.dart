import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

class ProfileItemLoading extends StatelessWidget {
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
