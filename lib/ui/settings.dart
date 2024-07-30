import "package:flutter_bloc/flutter_bloc.dart";
import "package:file_picker/file_picker.dart";
import "package:flutter/material.dart";

import "package:bakkugi/usecase/index.dart" as usecase;
import "package:bakkugi/entity/index.dart" as entity;

class Settings extends StatelessWidget {
  const Settings({super.key});

  static const String pageName = "Settings";

  @override
  Widget build(context) {
    _Controllers.set(
      context.select(
        (usecase.Settings settings) {
          return settings.state is usecase.SettingsSuccess ? (settings.state as usecase.SettingsSuccess).settings : null;
        },
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(pageName),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            tooltip: "Save",
            onPressed: () {
              context.read<usecase.Settings>().save(
                    entity.Settings(
                      importPath: _Controllers.importPath.text,
                      exportPath: _Controllers.exportPath.text,
                    ),
                  );

              Navigator.of(context).pop();
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _FormButton(
              labelText: "Import Path",
              controller: _Controllers.importPath,
            ),
            const SizedBox(height: 16),
            _FormButton(
              labelText: "Export Path",
              controller: _Controllers.exportPath,
            ),
          ],
        ),
      ),
    );
  }
}

class _FormButton extends StatelessWidget {
  const _FormButton({
    required this.labelText,
    required this.controller,
  });

  final String labelText;
  final TextEditingController controller;

  @override
  Widget build(context) {
    return TextFormField(
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: const OutlineInputBorder(),
        labelText: labelText,
      ),
      controller: controller,
      readOnly: true,
      onTap: () async {
        final String? dir = await FilePicker.platform.getDirectoryPath();
        if (dir != null) {
          controller.text = dir;
        }
      },
    );
  }
}

class _Controllers {
  static final TextEditingController importPath = TextEditingController();
  static final TextEditingController exportPath = TextEditingController();

  static void set(entity.Settings? settings) {
    importPath.text = settings?.importPath ?? "";
    exportPath.text = settings?.exportPath ?? "";
  }
}
