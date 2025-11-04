import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/extensions/theme_data.dart';
import 'package:shimmer/shimmer.dart';

Widget shimmerBox(
  BuildContext context, {
  double? width,
  double? height,
  double radius = 12,
}) {
  final theme = Theme.of(context);
  final w = width ?? double.infinity; // fallback width
  final h = height ?? 16.0; // fallback height

  return Shimmer.fromColors(
    baseColor: theme.shimmerBase,
    highlightColor: theme.shimmerHighlight,
    child: Container(
      margin: EdgeInsets.only(top: AppDimens.subElementBetween),
      width: w,
      height: h,
      decoration: BoxDecoration(
        color: theme.shimmerBase,
        borderRadius: BorderRadius.circular(radius),
      ),
    ),
  );
}
