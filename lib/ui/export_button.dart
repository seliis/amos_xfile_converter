part of "home.dart";

class _ExportButton extends StatelessWidget {
  const _ExportButton({
    required this.worksheet,
  });

  final entity.Worksheet worksheet;

  @override
  Widget build(context) {
    final state = context.watch<usecase.Export>().state;

    if (state is usecase.ExportLoading) {
      if (state.worksheetName != worksheet.worksheetName) {
        return const _PrimitiveExportButton(onPressed: null);
      }

      return Transform.scale(
        scale: 0.5,
        child: const CircularProgressIndicator(),
      );
    }

    if (state is usecase.ExportFailure) {
      ui.showingSnackBar(context, "Export Failure: ${state.errorMessage}", false);
    }

    if (state is usecase.ExportSuccess) {
      ui.showingSnackBar(context, "Export Success: ${state.filePath}", true);
    }

    return _Button(worksheet: worksheet);
  }
}

class _Button extends StatelessWidget {
  const _Button({
    required this.worksheet,
  });

  final entity.Worksheet worksheet;

  @override
  Widget build(context) {
    void invokeExport() {
      context.read<usecase.Export>().export(
            worksheet.schemaConstraints,
            worksheet.worksheetRecords,
            worksheet.workbookName,
            worksheet.worksheetName,
          );
    }

    return _PrimitiveExportButton(
      onPressed: worksheet.issues.isNotEmpty ? null : invokeExport,
    );
  }
}

class _PrimitiveExportButton extends StatelessWidget {
  const _PrimitiveExportButton({
    required this.onPressed,
  });

  final void Function()? onPressed;

  @override
  Widget build(context) {
    return IconButton(
      icon: const Icon(Icons.download),
      onPressed: onPressed,
      tooltip: "Export",
    );
  }
}
