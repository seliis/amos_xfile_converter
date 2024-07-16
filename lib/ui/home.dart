import "package:flutter/widgets.dart";
import "package:package_info_plus/package_info_plus.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:flutter/material.dart";

import "package:bakkugi/usecase/index.dart" as usecase;
import "package:bakkugi/entity/index.dart" as entity;
import "package:bakkugi/ui/index.dart" as ui;

part "issues_button.dart";
part "export_button.dart";
part "info_button.dart";

class Home extends StatelessWidget {
  const Home({super.key});

  static const String pageName = "Home";

  @override
  Widget build(context) {
    return BlocBuilder<usecase.Import, usecase.ImportState>(
      builder: (_, state) {
        Widget? getBody() {
          if (state is usecase.ImportInitial) {
            return null;
          }

          if (state is usecase.ImportSuccess) {
            ui.showingSnackBar(context, "Imported", true);

            return _SuccessBody(state: state);
          }

          if (state is usecase.ImportFailure) {
            ui.showingSnackBar(context, "Import Failed: ${state.errorMessage}", false);

            return null;
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.file_open),
              tooltip: "Import",
              onPressed: () {
                context.read<usecase.Import>().import();
              },
            ),
            title: context.read<usecase.Import>().state is usecase.ImportSuccess
                ? Text((state as usecase.ImportSuccess).workbookName)
                : const Text(
                    "Please Import a .XLSX File",
                  ),
            actions: const [
              _InfoButton(),
              SizedBox(
                width: 16,
              ),
            ],
          ),
          body: getBody(),
        );
      },
    );
  }
}

class _SuccessBody extends StatelessWidget {
  const _SuccessBody({
    required this.state,
  });

  final usecase.ImportSuccess state;

  @override
  Widget build(context) {
    Icon getStatusIcon(entity.Worksheet worksheet) {
      if (worksheet.issues.isEmpty) {
        return const Icon(Icons.check_circle_outline, color: Colors.teal);
      }

      return const Icon(Icons.error_outline, color: Colors.pink);
    }

    String getSubtitle(entity.Worksheet worksheet) {
      if (worksheet.issues.isEmpty) {
        return "Status: Export Ready";
      }

      return "Status: ${worksheet.issues.length} Issues Found";
    }

    Row getActions(entity.Worksheet worksheet) {
      const double boxSize = 48;

      return Row(
        children: [
          SizedBox(
            width: boxSize,
            child: _IssuesButton(worksheet: worksheet),
          ),
          SizedBox(
            width: boxSize,
            child: _ExportButton(worksheet: worksheet),
          ),
        ],
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          for (final worksheet in state.worksheets)
            ListTile(
              leading: getStatusIcon(worksheet),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "WorksheetName: ${worksheet.worksheetName}",
                        style: const TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        getSubtitle(worksheet),
                        style: const TextStyle(
                          fontWeight: FontWeight.w200,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  getActions(worksheet),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
