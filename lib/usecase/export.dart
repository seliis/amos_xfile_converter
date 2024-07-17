import "dart:io";

import "package:file_picker/file_picker.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:intl/intl.dart";

import "package:bakkugi/entity/index.dart" as entity;

class Export extends Cubit<ExportState> {
  Export() : super(ExportInitial());

  static List<String> _getChunks(List<entity.SchemaConstraint> schemaConstraints, List<List<entity.Cell>> records) {
    final List<String> chunks = [];

    for (int i = 0; i < records.length; i++) {
      final List<entity.Cell> record = records[i];
      String string = "";

      for (int i = 0; i < record.length; i++) {
        final schemaConstraint = schemaConstraints[i];

        final List<String> segment = List.filled(schemaConstraint.capacity, " ");

        final entity.Cell cell = record[i];

        for (int j = 0; j < cell.data.length; j++) {
          segment[j] = cell.data[j];
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

  static String _getSaveName(String worksheetName) {
    final String timeStamp = DateFormat("yyyyMMdd_HHmmss").format(DateTime.now());

    return "xfile_${worksheetName.toLowerCase()}_$timeStamp.txt";
  }

  static Future<void> _bufferWrite(List<String> chunks, File file) async {
    final buffer = StringBuffer();

    for (int i = 0; i < chunks.length; i++) {
      buffer.write(chunks[i]);
    }

    await file.writeAsString(buffer.toString(), mode: FileMode.write);
  }

  Future<void> export(List<entity.SchemaConstraint> schemaConstraints, List<List<entity.Cell>> records, String worksheetName) async {
    emit(ExportLoading());

    final List<String> chunks = _getChunks(schemaConstraints, records);

    String? savePath = await FilePicker.platform.saveFile(
      fileName: _getSaveName(worksheetName),
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

final class ExportLoading extends ExportState {}

final class ExportSuccess extends ExportState {
  final String filePath;

  ExportSuccess({required this.filePath});
}

final class ExportFailure extends ExportState {
  final String errorMessage;

  ExportFailure({required this.errorMessage});
}
