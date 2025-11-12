import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/utils/app_constants.dart';
import 'package:lingora/core/utils/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/core/widgets/app_container.dart';
import 'package:lingora/core/widgets/custom_status.dart';
import 'package:lingora/core/widgets/flushbar.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().getFavorites();
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
          current.actionStatus != FavoritesActionStatus.idle,
      listener: (context, state) {
        // Erorr
        showSnackBar(
          context,
          message: 'error_words_title'.tr(),
          icon: Icons.error_outline,
          iconColor: Theme.of(context).colorScheme.error,
        );
      },
      child: Scaffold(
        appBar: AppBar(),
        body: AppContainer(
          child: BlocBuilder<FavoritesCubit, FavoritesState>(
            builder: (context, state) {
              // Loading state
              if (state.status == FavoritesStatus.loading) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: CustomState(
                    animation: "assets/animation/loading_star.json",
                    title: "",
                    message: "loading_favorites".tr(),
                  ),
                );
              }

              // Success state
              else if (state.status == FavoritesStatus.success) {
                return MasonryGridView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: state.favorites.length,
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                  ),
                  crossAxisSpacing: AppDimens.cardBetween,
                  mainAxisSpacing: AppDimens.cardBetween,
                  itemBuilder: (context, index) {
                    return Container(); // TODO FIX THIS LATER
                    // return WordCard(
                    //     word: state.favorites[index].translatedWord!);
                  },
                );
              }

              // Empty
              else if (state.status == FavoritesStatus.empty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height * 0.80,
                  child: CustomState(
                      animation: "assets/animation/empty_box_character.json",
                      title: 'empty_favorites_title'.tr(),
                      message: 'empty_favorites_message'.tr()),
                );
              }

              // Error
              else if (state.status == FavoritesStatus.failure) {
                return CustomState(
                  textColor: Colors.white,
                  color: Theme.of(context).colorScheme.secondary,
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
