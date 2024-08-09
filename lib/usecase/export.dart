import "dart:io";

import "package:shared_preferences/shared_preferences.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:file_picker/file_picker.dart";
import "package:intl/intl.dart";

import "package:bakkugi/entity/index.dart" as entity;

class Export extends Cubit<ExportState> {
  Export() : super(ExportInitial());

  static List<String> _getChunks(List<entity.SchemaConstraint> schemaConstraints, List<List<entity.Cell>> records) {
    final List<String> chunks = [];

    for (int i = 0; i < records.length; i++) {
      final List<entity.Cell> record = records[i];
      String string = "";

      for (int j = 0; j < record.length; j++) {
        final schemaConstraint = schemaConstraints[j];

        final List<String> segment = List.filled(schemaConstraint.capacity, " ");

        final entity.Cell cell = record[j];

        for (int k = 0; k < cell.data.length; k++) {
          segment[k] = cell.data[k];
        }

        string += segment.join();
      }

      if (i < records.length - 1) {
        string += "\n";
      }

      chunks.add(string);
    }

    return chunks;
  }

  static String _getSaveName(String workbookName, String worksheetName) {
    final String timeStamp = DateFormat("yyyyMMdd_HHmmss").format(DateTime.now());

    return "xfile_${workbookName}_${worksheetName}_$timeStamp.txt".toLowerCase();
  }

  static Future<void> _bufferWrite(List<String> chunks, File file) async {
    final buffer = StringBuffer();

    for (int i = 0; i < chunks.length; i++) {
      buffer.write(chunks[i]);
    }

    await file.writeAsString(buffer.toString(), mode: FileMode.write);
  }

  Future<void> export(List<entity.SchemaConstraint> schemaConstraints, List<List<entity.Cell>> records, String workbookName, String worksheetName) async {
    emit(ExportLoading(worksheetName: worksheetName));

    final List<String> chunks = _getChunks(schemaConstraints, records);

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    String? savePath = await FilePicker.platform.saveFile(
      fileName: _getSaveName(workbookName, worksheetName),
      initialDirectory: prefs.getString("export_path"),
      type: FileType.custom,
      allowedExtensions: [
        "txt",
      ],
    );

    if (savePath == null) {
      emit(ExportFailure(errorMessage: "savePath == null"));
      return;
    }

    await _bufferWrite(chunks, File(savePath));

    emit(ExportSuccess(filePath: savePath));
  }
}

sealed class ExportState {}

final class ExportInitial extends ExportState {}

final class ExportLoading extends ExportState {
  final String worksheetName;

  ExportLoading({required this.worksheetName});
}

final class ExportSuccess extends ExportState {
  final String filePath;

  ExportSuccess({required this.filePath});
}

final class ExportFailure extends ExportState {
  final String errorMessage;

  ExportFailure({required this.errorMessage});
}
