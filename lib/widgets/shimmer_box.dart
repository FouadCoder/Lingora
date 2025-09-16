import 'package:flutter/material.dart';
import 'package:lingora/extensions/theme_data.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerBox(
  BuildContext context, {
  double? width,
  double? height,
  double radius = 8,
}) {
  final theme = Theme.of(context);
  final w = width ?? double.infinity; // fallback width
  final h = height ?? 16.0; // fallback height

  return Shimmer.fromColors(
    baseColor: theme.shimmerBase,
    highlightColor: theme.shimmerHighlight,
    child: Container(
      margin: EdgeInsets.only(top: 5),
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: theme.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
