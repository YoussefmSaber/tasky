import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';

/// A widget that displays a loading placeholder for a task item.
class TaskItemLoading extends StatelessWidget {
  /// Creates a [TaskItemLoading] widget.
  const TaskItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CardLoading(
        height: 55,
        width: 55,
        borderRadius: BorderRadius.circular(50),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CardLoading(
            height: 20,
            width: 75,
            borderRadius: BorderRadius.circular(10),
          ),
          CardLoading(
            height: 20,
            width: 60,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CardLoading(
            height: 20,
            width: 200,
            borderRadius: BorderRadius.circular(10),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CardLoading(
                height: 20,
                width: 100,
                borderRadius: BorderRadius.circular(10),
              ),
              CardLoading(
                height: 20,
                width: 100,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ),
        ],
      ),
      trailing: CardLoading(
        height: 40,
        width: 20,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}