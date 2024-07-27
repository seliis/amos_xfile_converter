import "package:excel/excel.dart" as excel;

class Workbook {
  const Workbook({
    required this.instance,
    required this.name,
  });

  final excel.Excel instance;
  final String name;
}
