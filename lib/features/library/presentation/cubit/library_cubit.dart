import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/library/domain/usecases/get_library_usecase.dart';
import 'package:lingora/features/library/presentation/cubit/library_state.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LibraryCubit extends Cubit<LibraryState> {
  final SupabaseClient supabaseClient;
  final GetLibraryUsecase getLibraryUsecase;
  LibraryCubit(this.supabaseClient, this.getLibraryUsecase)
      : super(const LibraryState());

  void getLibrary() async {
    try {
      emit(state.copyWith(status: LibraryStatus.loading));

      // If user is not logged in
      final userId = supabaseClient.auth.currentUser?.id;
      if (userId == null) {
        emit(state.copyWith(
          status: LibraryStatus.failure,
        ));
        return;
      }

      // Get library
      final libraryWords = await getLibraryUsecase.call();

      emit(state.copyWith(
          status: LibraryStatus.success, libraryWords: libraryWords));
    } catch (e) {
      print("Error loading library =================================$e");
      emit(state.copyWith(status: LibraryStatus.failure));
    }
  }
}
