import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_state.dart';
import 'package:lingora/features/words/presentation/widgets/library_collections.dart';
import 'package:lingora/features/words/presentation/widgets/word_card.dart';
import 'package:lingora/features/words/presentation/widgets/word_card_loading.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/custom_status.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    context.read<LibraryCubit>().getLibrary();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 600) {
        context.read<LibraryCubit>().loadMoreLibrary();
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
      body: BlocListener<LibraryCubit, LibraryState>(
        listener: (context, state) {
          if (state.status == LibraryStatus.failure) {
            showSnackBar(
              context,
              message: 'snack_word_error'.tr(),
              icon: Icons.error_outline,
              iconColor: Theme.of(context).colorScheme.error,
            );
          }
        },
        child: AppContainer(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                BlocBuilder<LibraryCubit, LibraryState>(
                    builder: (context, state) {
                  if (state.status == LibraryStatus.loading) {
                    // Loading
                    return MasonryGridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 8,
                      gridDelegate:
                          SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
                  else if (state.status == LibraryStatus.success) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Collections
                        Text(
                          "collections".tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: AppDimens.titleContentBetween,
                        ),
                        CollectionsLibrary(),

                        SizedBox(
                          height: AppDimens.sectionBetween,
                        ),
                        // Words
                        Text(
                          "learning_feed".tr(),
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        SizedBox(
                          height: AppDimens.titleContentBetween,
                        ),

                        // Words
                        MasonryGridView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.libraryWords.length +
                              (state.isLoadingMore ? 6 : 0),
                          gridDelegate:
                              SliverSimpleGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: getCrossAxisCount(),
                          ),
                          crossAxisSpacing: AppDimens.cardBetween,
                          mainAxisSpacing: AppDimens.cardBetween,
                          itemBuilder: (context, index) {
                            if (index < state.libraryWords.length) {
                              return WordCard(
                                word: state.libraryWords[index],
                              );
                            }
                            return LibraryLoadingCard();
                          },
                        ),
                      ],
                    );
                  }

                  // Empty
                  else if (state.status == LibraryStatus.empty) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: CustomState(
                        color: Theme.of(context).colorScheme.secondary,
                        animation: "assets/animation/empty_box_character.json",
                        title: 'empty_library_title'.tr(),
                        message: 'empty_library_message'.tr(),
                        titleColor: Theme.of(context).colorScheme.secondary,
                      ),
                    );
                  }

                  // Error
                  else if (state.status == LibraryStatus.failure) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: CustomState(
                        textColor: Colors.white,
                        color: Theme.of(context).colorScheme.primary,
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
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
