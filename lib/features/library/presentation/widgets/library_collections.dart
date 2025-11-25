import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_card.dart';
import 'package:lingora/features/library/domain/enums/collection_enum.dart';

class CollectionsLibrary extends StatelessWidget {
  const CollectionsLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    return MasonryGridView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppPlatform.isPhone(context) ? 2 : 4,
        ),
        crossAxisSpacing: AppDimens.cardBetween,
        mainAxisSpacing: AppDimens.cardBetween,
        itemCount: CollectionType.values.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: AppCard(
                child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image.asset(
                  CollectionType.values[index].imagePath,
                  height: 24,
                  width: 24,
                ),
                Text(
                  CollectionType.values[index].name,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.start,
                ),
              ],
            )),
          );
        });
  }
}
