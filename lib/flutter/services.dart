import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

Future<List<Map<String, dynamic>>> loadCSV(String path) async {
  final csvData = await rootBundle.loadString(path);
  List<List<dynamic>> rowsAsListOfValues =
      const CsvToListConverter().convert(csvData);

  // Convert the CSV data into a list of maps
  List<Map<String, dynamic>> csvAsMapList = [];
  for (var row in rowsAsListOfValues.skip(1)) {
    csvAsMapList.add({
      'S.no': row[1],
      'Title': row[2],
      'Desc': row[3],
      'Type': row[4],
      'BodyPart': row[5],
      'Equipment': row[6],
      'Level': row[7],
    });
  }

  return csvAsMapList;
}
