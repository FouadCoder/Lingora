import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/set_theme_usecase.dart';
import 'package:lingora/features/settings/presentation/cubit/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SetThemeUsecase setThemeUsecase;
  final GetThemeUsecase getThemeUsecase;
  ThemeCubit(this.setThemeUsecase, this.getThemeUsecase)
      : super(ThemeState.dark);

  // set Theme
  Future<void> setTheme(ThemeState theme) async {
    await setThemeUsecase.call(theme);
    emit(theme);
  }

  // Get Theme
  Future<void> getTheme() async {
    ThemeState them = await getThemeUsecase.call();
    emit(them);
  }
}
