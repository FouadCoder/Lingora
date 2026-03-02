import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingora/core/service/launch_service.dart';
import 'package:lingora/features/settings/domain/usecases/get_system_theme_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/get_theme_usecase.dart';
import 'package:lingora/features/settings/domain/usecases/set_theme_usecase.dart';
import 'package:lingora/features/settings/presentation/cubit/theme/theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  final SetThemeUsecase setThemeUsecase;
  final GetThemeUsecase getThemeUsecase;
  final GetSystemThemeUsecase getSystemThemeUsecase;
  final LaunchService launchService;

  ThemeCubit(this.setThemeUsecase, this.getThemeUsecase,
      this.getSystemThemeUsecase, this.launchService)
      : super(ThemeState.dark);

  // set Theme
  Future<void> setTheme(ThemeState theme) async {
    await setThemeUsecase.call(theme);
    emit(theme);
  }

  // Get Theme
  Future<void> getTheme() async {
    final appOpenCount = await launchService.getAppOpenCount();
    // First open
    if (appOpenCount == 1) {
      ThemeState theme = await getSystemThemeUsecase.call();
      await setTheme(theme);
      emit(theme);
    } else {
      ThemeState them = await getThemeUsecase.call();
      emit(them);
    }
  }
}
