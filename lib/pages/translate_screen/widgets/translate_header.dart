import 'package:flutter/material.dart';
import 'package:lingora/core/app_constants.dart';

class TranslatHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const TranslatHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.07)),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 20,
          ),
        ),
        SizedBox(width: AppDimens.buttonTagHorizontal),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}
