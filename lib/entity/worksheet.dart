class Worksheet {
  const Worksheet({
    required this.worksheetName,
    required this.schemaConstraints,
    required this.worksheetRecords,
    required this.issues,
  });

  final String worksheetName;
  final List<SchemaConstraint> schemaConstraints;
  final List<List<String?>> worksheetRecords;
  final List<Issue> issues;
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
  });

  final IssueType type;
  final IssueMessage message;
  final IssuePosition position;
}

class IssuePosition {
  const IssuePosition({
    required this.row,
    required this.column,
  });

  final int row;
  final int column;
}
