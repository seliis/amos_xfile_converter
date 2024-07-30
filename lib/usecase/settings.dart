import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "package:bakkugi/entity/index.dart" as entity;

class Settings extends Cubit<SettingsState> {
  Settings() : super(SettingsInitial());

  void init() async {
    emit(SettingsLoading());

    final prefs = await SharedPreferences.getInstance();

    final importPath = prefs.getString("import_path");
    final exportPath = prefs.getString("export_path");

    emit(SettingsSuccess(
      settings: entity.Settings(
        importPath: importPath,
        exportPath: exportPath,
      ),
    ));
  }

  void save(entity.Settings settings) async {
    emit(SettingsLoading());

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("import_path", settings.importPath ?? "");
    await prefs.setString("export_path", settings.exportPath ?? "");

    emit(SettingsSuccess(settings: settings));
  }
}

sealed class SettingsState {}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsSuccess extends SettingsState {
  SettingsSuccess({
    required this.settings,
  });

  final entity.Settings settings;
}

class SettingsFailure extends SettingsState {}
