import 'package:contribution_heatmap/contribution_heatmap.dart';
import 'package:flutter/material.dart';

class ActivityHeatmap extends StatelessWidget {
  final List<ContributionEntry> entries;
  final Function(DateTime, int)? onTap;
  final bool splittedMonthView;
  final bool showMonthLabels;
  final bool showWeekdayLabels;
  final double cellSize;
  final double cellRadius;
  final DateTime minDate;
  final DateTime maxDate;
  const ActivityHeatmap(
      {super.key,
      required this.entries,
      this.onTap,
      this.splittedMonthView = false,
      this.showMonthLabels = false,
      this.showWeekdayLabels = true,
      this.cellSize = 15,
      this.cellRadius = 8,
      required this.minDate,
      required this.maxDate});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ContributionHeatmap(
        minDate: minDate,
        maxDate: maxDate,
        splittedMonthView: splittedMonthView,
        showMonthLabels: showMonthLabels,
        showWeekdayLabels: showWeekdayLabels,
        cellSize: cellSize,
        cellRadius: cellRadius,
        colorScale: (value) {
          final base = Theme.of(context).colorScheme.secondary;
          switch (value) {
            case 0:
              return Theme.of(context).colorScheme.onSurface; // no activity
            case 1:
              return base.withValues(alpha: 0.3); // lighter tint
            case 2:
              return base.withValues(alpha: 0.6);
            case 3:
              return base.withValues(alpha: 0.8);
            default:
              return base; // full strength
          }
        },
        entries: entries,
        onCellTap: (date, value) {
          onTap?.call(date, value);
        },
      ),
    );
  }
}
