import "dart:io";

import "package:flutter_bloc/flutter_bloc.dart";
import "package:file_picker/file_picker.dart";
import "package:excel/excel.dart" as excel;

import "package:bakkugi/entity/index.dart" as entity;

class Import extends Cubit<ImportState> {
  Import() : super(ImportInitial());

  static List<entity.Issue> _getIssues(List<entity.SchemaConstraint> schemaConstraints, List<List<entity.Cell>> worksheetRecords) {
    final List<entity.Issue> issues = [];

    for (final List<entity.Cell> cells in worksheetRecords) {
      for (int i = 0; i < schemaConstraints.length; i++) {
        final entity.SchemaConstraint schemaConstraint = schemaConstraints[i];
        final entity.Cell cell = cells[i];

        final entity.IssuePosition position = entity.IssuePosition(
          row: cell.rowIndex,
          column: cell.columnIndex,
        );

        if (schemaConstraint.isRequired && cell.data == "") {
          issues.add(
            entity.Issue(
              type: entity.IssueType.schemaInfraction,
              message: entity.IssueMessage.mandatoryMissing,
              position: position,
            ),
          );
        }

        if (schemaConstraint.capacity > 0 && cell.data.length > schemaConstraint.capacity) {
          issues.add(
            entity.Issue(
              type: entity.IssueType.schemaInfraction,
              message: entity.IssueMessage.capacityExceeded,
              position: position,
              additionalInfo: "Cap: ${schemaConstraint.capacity}, Len: ${cell.data.length}(+${cell.data.length - schemaConstraint.capacity})",
              data: cell.data,
            ),
          );
        }
      }
    }

    return issues;
  }

  static List<entity.Worksheet> _getWorksheets(excel.Excel workbook) {
    final List<entity.Worksheet> worksheets = [];

    for (final String worksheetName in workbook.tables.keys) {
      final excel.Sheet sheet = workbook.tables[worksheetName]!;

      final List<entity.SchemaConstraint> schemaConstraints = [];

      for (final excel.Data? data in sheet.rows.first) {
        if (data == null) {
          continue;
        }

        final List<String> arr = data.value.toString().replaceAll("]", "").split("[");

        schemaConstraints.add(
          entity.SchemaConstraint(
            name: arr[0],
            capacity: arr.length > 1 ? int.parse(arr[1]) : 0,
            isRequired: arr.length > 2 ? arr[2] == "m" : false,
          ),
        );
      }

      final List<List<entity.Cell>> worksheetRecords = [];

      for (final List<excel.Data?> row in sheet.rows.sublist(1)) {
        worksheetRecords.add(row.map((data) => entity.Cell.fromData(data)).toList());
      }

      worksheets.add(
        entity.Worksheet(
          worksheetName: worksheetName,
          schemaConstraints: schemaConstraints,
          worksheetRecords: worksheetRecords,
          issues: _getIssues(schemaConstraints, worksheetRecords),
        ),
      );
    }

    return worksheets;
  }

  Future<void> import() async {
    emit(ImportLoading());

    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        "xlsx"
      ],
    );

    if (result == null) {
      emit(ImportFailure(errorMessage: "result == null"));
      return;
    }

    late File file;

    if (result.paths.single == null) {
      emit(ImportFailure(errorMessage: "result.paths.single == null"));
      return;
    } else {
      file = File(result.paths.single!);
    }

    late excel.Excel workbook;

    try {
      workbook = excel.Excel.decodeBytes(file.readAsBytesSync());
    } on FileSystemException {
      emit(ImportFailure(errorMessage: "file.readAsBytesSync()"));
      return;
    } on Exception {
      emit(ImportFailure(errorMessage: "Excel.decodeBytes()"));
      return;
    }

    emit(
      ImportSuccess(
        workbookName: result.names.first!,
        worksheets: _getWorksheets(workbook),
      ),
    );
  }
}

sealed class ImportState {}

final class ImportInitial extends ImportState {}

final class ImportLoading extends ImportState {}

final class ImportSuccess extends ImportState {
  ImportSuccess({
    required this.workbookName,
    required this.worksheets,
  });

  final String workbookName;
  final List<entity.Worksheet> worksheets;
}

final class ImportFailure extends ImportState {
  ImportFailure({
    required this.errorMessage,
  });

  final String errorMessage;
}
