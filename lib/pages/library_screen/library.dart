import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lingora/core/platfrom.dart';
import 'package:lingora/cubit/cubit_app.dart';
import 'package:lingora/cubit/state_app.dart';
import 'package:lingora/pages/library_screen/widgets/library_loading_card.dart';
import 'package:lingora/widgets/app_container.dart';

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
      body: AppContainer(
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
                  gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: getCrossAxisCount(),
                  ),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 8,
                  itemBuilder: (context, index) {
                    return LibraryLoadingCard();
                  },
                );
              }
              return Container();
            })
          ],
        ),
      )),
    );
  }
}
