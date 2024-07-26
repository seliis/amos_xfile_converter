import "package:excel/excel.dart" as excel;
import "package:flutter/material.dart";

class Worksheet {
  const Worksheet({
    required this.workbookName,
    required this.worksheetName,
    required this.schemaConstraints,
    required this.worksheetRecords,
    required this.issues,
  });

  final String workbookName;
  final String worksheetName;
  final List<SchemaConstraint> schemaConstraints;
  final List<List<Cell>> worksheetRecords;
  final List<Issue> issues;
}

class Cell {
  const Cell({
    required this.data,
    required this.rowIndex,
    required this.columnIndex,
  });

  final String data;
  final int rowIndex;
  final int columnIndex;

  factory Cell.fromData(excel.Data? data) {
    return Cell(
      data: data?.value != null ? data!.value.toString() : "",
      rowIndex: data?.rowIndex != null ? data!.rowIndex + 1 : 0,
      columnIndex: data?.columnIndex != null ? data!.columnIndex + 1 : 0,
    );
  }
}

class SchemaConstraint {
  const SchemaConstraint({
    required this.name,
    required this.capacity,
    required this.isRequired,
  });

  final String name;
  final int capacity;
  final bool isRequired;
}

enum IssueType {
  schemaInfraction;

  String get display {
    switch (this) {
      case schemaInfraction:
        return "Schema Infraction";
    }
  }

  Icon get icon {
    switch (this) {
      case schemaInfraction:
        return const Icon(Icons.warning_amber_rounded, color: Colors.pink);
    }
  }
}

enum IssueMessage {
  mandatoryMissing,
  capacityExceeded;

  String get display {
    switch (this) {
      case mandatoryMissing:
        return "Mandatory Missing";
      case capacityExceeded:
        return "Capacity Exceeded";
    }
  }
}

class Issue {
  const Issue({
    required this.type,
    required this.message,
    required this.position,
    this.additionalInfo,
    this.data,
  });

  final IssueType type;
  final IssueMessage message;
  final IssuePosition position;
  final String? additionalInfo;
  final String? data;
}

class IssuePosition {
  const IssuePosition({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;
}
