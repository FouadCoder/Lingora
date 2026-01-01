import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/features/words/domain/enums/collection_enum.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_state.dart';
import 'package:lingora/features/words/presentation/widgets/word_card.dart';
import 'package:lingora/features/words/presentation/widgets/word_card_loading.dart';

class CollectionWordsScreen extends StatefulWidget {
  final CollectionType collectionType;
  const CollectionWordsScreen({super.key, required this.collectionType});

  @override
  State<CollectionWordsScreen> createState() => _CollectionWordsScreenState();
}

class _CollectionWordsScreenState extends State<CollectionWordsScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context
        .read<LibraryCubit>()
        .getWordsByCollection(widget.collectionType.name);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 600) {
        context
            .read<LibraryCubit>()
            .loadMoreCollections(widget.collectionType.name);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int getCrossAxisCount() {
      if (AppPlatform.isDesktop(context)) return 3;
      if (AppPlatform.isTablet(context)) return 2;
      if (AppPlatform.isPhone(context)) return 1;
      return 1;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.collectionType.displayName,
          style: widget.collectionType.wordStyle(context),
        ),
      ),
      body: AppContainer(
        child: SingleChildScrollView(
          child: BlocBuilder<LibraryCubit, LibraryState>(
              builder: (context, state) {
            if (state.collectionStatus == LibraryStatus.loading) {
              // Loading
              return MasonryGridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 8,
                gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: getCrossAxisCount(),
                ),
                crossAxisSpacing: AppDimens.cardBetween,
                mainAxisSpacing: AppDimens.cardBetween,
                itemBuilder: (context, index) {
                  return LibraryLoadingCard();
                },
              );
            }

            // Success
            else if (state.collectionStatus == LibraryStatus.success) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Words
                  MasonryGridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.collectionsWords.length +
                        (state.isLoadingMore ? 6 : 0),
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(),
                    ),
                    crossAxisSpacing: AppDimens.cardBetween,
                    mainAxisSpacing: AppDimens.cardBetween,
                    itemBuilder: (context, index) {
                      if (index < state.collectionsWords.length) {
                        return WordCard(
                          word: state.collectionsWords[index],
                        );
                      }
                      return LibraryLoadingCard();
                    },
                  ),
                ],
              );
            }

            // Empty
            else if (state.collectionStatus == LibraryStatus.empty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: CustomState(
                  color: Theme.of(context).colorScheme.secondary,
                  animation: "assets/animation/empty_box_character.json",
                  title: 'empty_collection_title'.tr(),
                  message: 'empty_collection_message'.tr(),
                  titleColor: Theme.of(context).colorScheme.secondary,
                ),
              );
            }

            // Error
            else if (state.collectionStatus == LibraryStatus.failure) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: CustomState(
                  textColor: Colors.white,
                  color: Theme.of(context).colorScheme.secondary,
                  animation: "assets/animation/error_boat_orange.json",
                  title: 'error_words_title'.tr(),
                  message: 'error_words_message'.tr(),
                  buttonText: 'try_again'.tr(),
                  onTap: () {
                    context.read<LibraryCubit>().getLibrary();
                  },
                ),
              );
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
