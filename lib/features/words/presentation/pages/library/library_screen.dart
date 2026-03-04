import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/status/network_error_status.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_state.dart';
import 'package:lingora/features/words/presentation/widgets/library_collections.dart';
import 'package:lingora/features/words/presentation/widgets/word_card.dart';
import 'package:lingora/features/words/presentation/widgets/word_card_loading.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

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
      body: BlocConsumer<LibraryCubit, LibraryState>(
        listener: (context, state) {
          if (state.status == LibraryStatus.failure) {
            showSnackBar(
              context,
              message: 'snack_word_error'.tr(),
              icon: HeroIcons.exclamationTriangle,
              iconColor: Theme.of(context).colorScheme.error,
            );
          }
          // Network Error
          if (state.status == LibraryStatus.networkError) {
            showErrorNetworkSnackBar(context);
          }
          // Error
          if (state.actionStatus == LibraryActionStatus.failure) {
            showSnackBar(
              context,
              message: 'snack_word_error'.tr(),
              icon: HeroIcons.exclamationTriangle,
              iconColor: Theme.of(context).colorScheme.error,
            );
          }
          // Refresh Limit Exceeded
          if (state.actionStatus == LibraryActionStatus.limitExceeded) {
            showSnackBar(
              context,
              message: 'refresh_wait'.tr(
                  namedArgs: {'minutes': state.minutesUntilRefresh.toString()}),
              icon: HeroIcons.clock,
              iconColor: Colors.yellow,
            );
          }
        },
        builder: (context, state) {
          return AppContainer(
            child: Column(
              children: [
                BlocBuilder<LibraryCubit, LibraryState>(
                    builder: (context, state) {
                  if (state.status == LibraryStatus.loading) {
                    // Loading
                    return Expanded(
                      child: MasonryGridView.builder(
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
                      ),
                    );
                  }

                  // Success
                  else if (state.status == LibraryStatus.success) {
                    return Expanded(
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppDimens.radiusL),
                            child: LiquidPullToRefresh(
                                onRefresh: () => context
                                    .read<LibraryCubit>()
                                    .refreshLibrary(),
                                backgroundColor: Colors.black,
                                color: Theme.of(context).colorScheme.primary,
                                showChildOpacityTransition: false,
                                height: 100,
                                springAnimationDurationInMilliseconds: 500,
                                child: Container(
                                    margin: EdgeInsets.only(
                                        top: AppDimens.paddingS),
                                    child: CustomScrollView(
                                      controller: _scrollController,
                                      slivers: [
                                        // Collections
                                        SliverToBoxAdapter(
                                          child: Text(
                                            "collections".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: SizedBox(
                                            height:
                                                AppDimens.titleContentBetween,
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                            child: CollectionsLibrary()),

                                        SliverToBoxAdapter(
                                          child: SizedBox(
                                            height: AppDimens.sectionBetween,
                                          ),
                                        ),
                                        // Words
                                        SliverToBoxAdapter(
                                          child: Text(
                                            "learning_feed".tr(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                        ),
                                        SliverToBoxAdapter(
                                          child: SizedBox(
                                            height:
                                                AppDimens.titleContentBetween,
                                          ),
                                        ),

                                        // Words List
                                        SliverMasonryGrid.count(
                                          crossAxisCount: getCrossAxisCount(),
                                          mainAxisSpacing:
                                              AppDimens.cardBetween,
                                          crossAxisSpacing:
                                              AppDimens.cardBetween,
                                          childCount:
                                              state.libraryWords.length +
                                                  (state.isLoadingMore ? 6 : 0),
                                          itemBuilder: (context, index) {
                                            if (index <
                                                state.libraryWords.length) {
                                              return WordCard(
                                                  word: state
                                                      .libraryWords[index]);
                                            }
                                            return LibraryLoadingCard();
                                          },
                                        )
                                      ],
                                    )))));
                  }

                  // Empty
                  else if (state.status == LibraryStatus.empty) {
                    return Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(AppDimens.radiusL),
                        child: LiquidPullToRefresh(
                          onRefresh: () =>
                              context.read<LibraryCubit>().refreshLibrary(),
                          backgroundColor: Colors.black,
                          color: Theme.of(context).colorScheme.primary,
                          showChildOpacityTransition: false,
                          height: 100,
                          springAnimationDurationInMilliseconds: 500,
                          child: Container(
                            margin: EdgeInsets.only(top: AppDimens.paddingS),
                            child: CustomState(
                              color: Theme.of(context).colorScheme.primary,
                              animation:
                                  "assets/animation/empty_box_character.json",
                              title: 'empty_library_title'.tr(),
                              message: 'empty_library_message'.tr(),
                              buttonText: 'learn_new_words'.tr(),
                              onTap: () => context.push('/translate'),
                              textColor: Colors.white,
                              titleColor: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    );
                  }

                  // Network Error
                  else if (state.status == LibraryStatus.networkError) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: NetworkErrorView(
                            onTap: () {
                              context.read<LibraryCubit>().getLibrary();
                            },
                          ),
                        ),
                      ),
                    );
                  }

                  // Error
                  else if (state.status == LibraryStatus.failure) {
                    return Expanded(
                      child: SingleChildScrollView(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: CustomState(
                            textColor: Colors.white,
                            color: Theme.of(context).colorScheme.primary,
                            animation:
                                "assets/animation/error_boat_orange.json",
                            title: 'error_words_title'.tr(),
                            message: 'error_words_message'.tr(),
                            buttonText: 'try_again'.tr(),
                            onTap: () {
                              context.read<LibraryCubit>().getLibrary();
                            },
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                })
              ],
            ),
          );
        },
      ),
    );
  }
}
