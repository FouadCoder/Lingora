import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:heroicons/heroicons.dart';
import 'package:lingora/core/widgets/flushbar.dart';
import 'package:lingora/core/widgets/icon_card.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_cubit.dart';
import 'package:lingora/features/words/presentation/cubit/favorites/favorites_state.dart';
import 'package:lingora/features/words/presentation/cubit/words/library_cubit.dart';

class HeartIconWidget extends StatefulWidget {
  final String wordId;
  final bool isFavorite;

  const HeartIconWidget(
      {super.key, required this.wordId, required this.isFavorite});

  @override
  State<HeartIconWidget> createState() => _HeartIconWidgetState();
}

class _HeartIconWidgetState extends State<HeartIconWidget> {
  late bool isOptimisticFavorite;

  @override
  void initState() {
    super.initState();
    isOptimisticFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FavoritesCubit, FavoritesState>(
      listenWhen: (previous, current) =>
          previous.actionStatus != current.actionStatus,
      listener: (context, state) {
        if (state.wordId != widget.wordId) return;

        for (var item in state.favorites) {
          print(
              "Heart Icon widget =========== WORD === ${item.word.original}    ===${item.word.isFavorite}");
        }

        if (state.actionStatus == FavoriteActionStatus.added) {
          context.read<LibraryCubit>().refreshWord(
                wordId: widget.wordId,
                isFavorite: true,
              );

          showSnackBar(
            context,
            message: 'word_added_to_favorites'.tr(),
            icon: HeroIcons.heart,
            iconColor: Colors.red,
          );
        }

        // Removed
        else if (state.actionStatus == FavoriteActionStatus.removed) {
          context.read<LibraryCubit>().refreshWord(
                wordId: widget.wordId,
                isFavorite: false,
              );
          showSnackBar(
            context,
            message: 'word_removed_from_favorites'.tr(),
            icon: HeroIcons.checkCircle,
            iconColor: Colors.green,
          );
        }
        // Error
        else if (state.actionStatus == FavoriteActionStatus.error) {
          setState(() {
            isOptimisticFavorite = !isOptimisticFavorite;
          });
          showSnackBar(
            context,
            message: 'something_went_wrong'.tr(),
            icon: HeroIcons.exclamationTriangle,
            iconColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: IconCard(
        iconWidget: Icon(
          Icons.favorite,
          color: isOptimisticFavorite ? Colors.red : Colors.white,
        ),
        onTap: () {
          // Update UI instantly
          setState(() {
            isOptimisticFavorite = !isOptimisticFavorite;
          });
          final word = context.read<LibraryCubit>().getWordById(widget.wordId);

          // Call cubit
          if (word.isFavorite == false) {
            context.read<FavoritesCubit>().addToFavorites(word);
          } else {
            context.read<FavoritesCubit>().removeFromFavorites(word.id);
          }
        },
      ),
    );
  }
}
