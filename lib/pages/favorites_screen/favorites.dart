import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/widgets/custom_status.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<FavoritesCubit, FavoritesState>(
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
            if (state.favorites.isEmpty) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.80,
                child: CustomState(
                  animation: "assets/animation/empty_box_character.json",
                  title: 'empty_favorites_title'.tr(),
                  message: 'empty_favorites_message'.tr(),
                ),
              );
            }

            // Display favorites list
            return ListView.builder(
              itemCount: state.favorites.length,
              itemBuilder: (context, index) {
                //Todo
                final favorite = state.favorites[index];
                return Container();
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

          // Error state
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
    );
  }
}
