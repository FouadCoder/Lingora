import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/words/domain/entities/word_entity.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_state.dart';

class HeartIconWidget extends StatefulWidget {
  final WordEntity word;
  final void Function(WordEntity updatedWord)? onFavoriteChanged;

  const HeartIconWidget({
    super.key,
    required this.word,
    this.onFavoriteChanged,
  });

  @override
  State<HeartIconWidget> createState() => _HeartIconWidgetState();
}

class _HeartIconWidgetState extends State<HeartIconWidget> {
  late bool isOptimisticFavorite;

  @override
  void initState() {
    super.initState();
    isOptimisticFavorite = widget.word.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.actionStatus == FavoriteActionStatus.added ||
            state.actionStatus == FavoriteActionStatus.removed) {
          // Call the callback if provided
          widget.onFavoriteChanged?.call(state.word!);

          showSnackBar(
            context,
            message: state.actionStatus == FavoriteActionStatus.added
                ? 'word_added_to_favorites'.tr()
                : 'word_removed_from_favorites'.tr(),
            icon: Icons.favorite,
            iconColor: Colors.red,
          );
        } else if (state.actionStatus == FavoriteActionStatus.error) {
          // Revert on error
          setState(() {
            isOptimisticFavorite = widget.word.isFavorite;
          });
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
        iconColor: isOptimisticFavorite
            ? Colors.red
            : Theme.of(context).colorScheme.primary,
        onTap: () {
          // Update UI instantly
          setState(() {
            isOptimisticFavorite = !isOptimisticFavorite;
          });

          // Call cubit
          if (!widget.word.isFavorite) {
            context.read<FavoritesCubit>().addToFavorites(widget.word);
          } else {
            context.read<FavoritesCubit>().removeFromFavorites(widget.word);
          }
        },
      ),
    );
  }
}
