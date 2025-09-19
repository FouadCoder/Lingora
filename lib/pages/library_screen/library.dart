import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/pages/library_screen/widgets/library_card.dart';
import 'package:lingora/pages/library_screen/widgets/library_loading_card.dart';
import 'package:lingora/widgets/app_container.dart';
import 'package:lingora/widgets/flushbar.dart';
import 'package:lingora/widgets/status/custom_status.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FetchTranslatedLibraryCubit>().getLibrary();
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
      body: BlocListener<FetchTranslatedLibraryCubit,
          FetchTranslatedLibraryState>(
        listener: (context, state) {
          if (state.status == FetchTranslatedLibraryStatus.failure) {
            showSnackBar(
              context,
              '',
              'snack_word_error'.tr(),
              Icons.error_outline,
              Theme.of(context).colorScheme.error,
            );
          }
        },
        child: AppContainer(
            child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<FetchTranslatedLibraryCubit,
                  FetchTranslatedLibraryState>(builder: (context, state) {
                if (state.status == FetchTranslatedLibraryStatus.loading) {
                  // Loading
                  return MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(),
                    ),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 8,
                    itemBuilder: (context, index) {
                      return LibraryLoadingCard();
                    },
                  );
                }

                // Success
                else if (state.status == FetchTranslatedLibraryStatus.success) {
                  return MasonryGridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.libraryWords.length,
                    gridDelegate:
                        SliverSimpleGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: getCrossAxisCount(),
                    ),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 8,
                    itemBuilder: (context, index) {
                      return WordCard(word: state.libraryWords[index]);
                    },
                  );
                }

                // Error
                else if (state.status == FetchTranslatedLibraryStatus.failure) {
                  return SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: CustomState(
                        textColor: Colors.white,
                        color: Theme.of(context).colorScheme.secondary,
                        animation: "assets/animation/error_boat_orange.json",
                        spaceInScreen: 0.0,
                        title: 'error_words_title'.tr(),
                        message: 'error_words_message'.tr(),
                        buttonText: 'try_again'.tr(),
                        onTap: () {
                          context
                              .read<FetchTranslatedLibraryCubit>()
                              .getLibrary();
                        },
                      ),
                    ),
                  );
                }
                return Container();
              })
            ],
          ),
        )),
      ),
    );
  }
}
