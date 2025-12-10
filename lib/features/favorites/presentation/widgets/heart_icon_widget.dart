import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/favorites/presentation/cubit/favorites_cubit.dart';
import 'package:lingora/features/favorites/presentation/cubit/favorites_state.dart';

class HeartIconWidget extends StatefulWidget {
  final bool isFavorite;
  final String? wordId;
  const HeartIconWidget({super.key, required this.isFavorite, this.wordId});

  @override
  State<HeartIconWidget> createState() => _HeartIconWidgetState();
}

class _HeartIconWidgetState extends State<HeartIconWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        // Success
        if (state.actionStatus == FavoriteActionStatus.added) {
          showSnackBar(
            context,
            message: 'word_added_to_favorites'.tr(),
            icon: Icons.favorite,
            iconColor: Colors.red,
          );
        }

        // Error
        else if (state.actionStatus == FavoriteActionStatus.error) {
          showSnackBar(
            context,
            message: 'something_went_wrong'.tr(),
            icon: Icons.error_outline,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: IconCard(
        icon: Icons.favorite,
        iconColor: widget.isFavorite
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
        onTap: () {
          if (!widget.isFavorite) {
            context.read<FavoritesCubit>().addToFavorites(
                  widget.wordId!,
                );
          } else {
            context.read<FavoritesCubit>().removeFromFavorites(
                  widget.wordId!,
                );
          }
        },
      ),
    );
  }
}
