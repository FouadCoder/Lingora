import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/app_constants.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/widgets/app_card.dart';

class CollectionsLibrary extends StatelessWidget {
  const CollectionsLibrary({super.key});

  @override
  Widget build(BuildContext context) {
    List collections = [
      {
        "name": "learning".tr(),
        "path": "assets/icons/layer_10.png",
        "onTap": () {}
      },
      {
        "name": "favorites".tr(),
        "path": "assets/icons/heart_72.png",
        "onTap": () {}
      },
      {
        "name": "saved".tr(),
        "path": "assets/icons/bookmark_10.png",
        "onTap": () {}
      },
      {
        "name": "mastered".tr(),
        "path": "assets/icons/trophy_10.png",
        "onTap": () {}
      },
    ];

    return MasonryGridView.builder(
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppPlatform.isPhone(context) ? 2 : 4,
        ),
        crossAxisSpacing: AppDimens.cardBetween,
        mainAxisSpacing: AppDimens.cardBetween,
        itemCount: collections.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: collections[index]["onTap"],
            child: AppCard(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.secondary
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Image.asset(
                      collections[index]["path"],
                      height: 24,
                      width: 24,
                    ),
                    Text(
                      collections[index]["name"],
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.start,
                    ),
                  ],
                )),
          );
        });
  }
}
