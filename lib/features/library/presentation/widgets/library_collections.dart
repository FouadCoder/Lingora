import 'package:flutter/material.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/features/library/domain/enums/collection_enum.dart';

class CollectionsLibrary extends StatelessWidget {
  const CollectionsLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    final isPhone = AppPlatform.isPhone(context);

    if (isPhone) {
      // PHONE LAYOUT
      return Column(
        children: [
          // first row → 2 items
          Row(
            children: [
              Expanded(child: _buildItem(context, 0)),
              SizedBox(width: AppDimens.cardBetween),
              Expanded(child: _buildItem(context, 1)),
            ],
          ),
          SizedBox(height: AppDimens.cardBetween),

          // second row → full width
          _buildItem(context, 2),
        ],
      );
    }

    // TABLET / DESKTOP → 3 per row
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(
        CollectionType.values.length,
        (i) => Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: AppDimens.cardBetween),
                child: _buildItem(context, i))),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    final type = CollectionType.values[index];

    return AppCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Image.asset(type.imagePath, height: 24, width: 24),
          SizedBox(width: AppDimens.elementBetween),
          Text(type.name, style: type.wordStyle(context)),
        ],
      ),
    );
  }
}
