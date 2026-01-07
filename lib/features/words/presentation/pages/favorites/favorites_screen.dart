import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_state.dart';
import 'package:lingora/features/words/presentation/widgets/word_card.dart';
import 'package:lingora/features/words/presentation/widgets/word_card_loading.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().getFavorites();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 600) {
        context.read<FavoritesCubit>().loadMoreFavorites();
      }
    });
  }

  int getCrossAxisCount() {
    if (AppPlatform.isDesktop(context)) return 3;
    if (AppPlatform.isTablet(context)) return 2;
    if (AppPlatform.isPhone(context)) return 1;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          current.actionStatus != FavoriteActionStatus.idle,
      listener: (context, state) {
        // Erorr
        showSnackBar(
          context,
          message: 'error_words_title'.tr(),
          icon: HeroIcons.exclamationTriangle,
          iconColor: Theme.of(context).colorScheme.error,
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: AppContainer(
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              // Loading
              if (state.status == FavoriteStatus.loading) {
                return MasonryGridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
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
              else if (state.status == FavoriteStatus.success) {
                return MasonryGridView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount:
                      state.favorites.length + (state.isLoadingMore ? 6 : 0),
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                  ),
                  crossAxisSpacing: AppDimens.cardBetween,
                  mainAxisSpacing: AppDimens.cardBetween,
                  itemBuilder: (context, index) {
                    if (index < state.favorites.length) {
                      return WordCard(word: state.favorites[index].word);
                    }
                    return LibraryLoadingCard();
                  },
                );
              }

              // Empty
              else if (state.status == FavoriteStatus.empty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: CustomState(
                      animation: "assets/animation/cat_sleep_orange.json",
                      title: 'empty_favorites_title'.tr(),
                      message: 'empty_favorites_message'.tr()),
                );
              }

              // Error
              else if (state.status == FavoriteStatus.error) {
                return CustomState(
                  textColor: Colors.white,
                  color: Theme.of(context).colorScheme.primary,
                  animation: "assets/animation/error_boat_orange.json",
                  title: 'error_favorites_title'.tr(),
                  message: 'error_favorites_message'.tr(),
                  buttonText: 'try_again'.tr(),
                  onTap: () {
                    if (mounted) {
                      context.read<FavoritesCubit>().getFavorites();
                    }
                  },
                );
              }

              // Default return
              return Container();
            },
          ),
        ),
      ),
    );
  }
}
