// lib/services/export_service.dart

import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart' show rootBundle;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;

class ExportService {
  // ----- PDF EXPORT -----
  static Future<void> exportToPdf({
    required String title,
    required List<String> headers,
    required List<List<String>> data,
    required String fileName,
  }) async {
    // 1) Load your Unicode font
    final fontData = await rootBundle.load('assets/fonts/OpenSans-Regular.ttf');
    final ttf = pw.Font.ttf(fontData);

    // 2) Build the PDF
    final pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (_) => [
          pw.Header(
            level: 0,
            child: pw.Text(
              title,
              style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ),
          pw.SizedBox(height: 20),
          pw.Table.fromTextArray(
            headers: headers,
            data: data,
            border: pw.TableBorder.all(),
            headerStyle: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
            headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
            cellStyle: pw.TextStyle(font: ttf),
            cellAlignments: {
              for (var i = 0; i < headers.length; i++) i: pw.Alignment.center
            },
          ),
        ],
      ),
    );

    final bytes = await pdf.save();
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final outputName = '${fileName}_$timestamp.pdf';

    if (kIsWeb) {
      // 3a) Web: download via anchor
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', outputName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // 3b) Mobile/Desktop: write to documents dir
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$outputName');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }

  // ----- EXCEL EXPORT -----
  static Future<void> exportToExcel({
    required String title,
    required List<String> headers,
    required List<List<String>> data,
    required String fileName,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[title];

    // Header row
    for (var i = 0; i < headers.length; i++) {
      final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = CellStyle(
        bold: true,
        horizontalAlign: HorizontalAlign.Center,
      );
    }

    // Data rows
    for (var r = 0; r < data.length; r++) {
      for (var c = 0; c < data[r].length; c++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1));
        cell.value = TextCellValue(data[r][c]);
        cell.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);
      }
    }

    // Auto‐fit columns
    for (var col = 0; col < headers.length; col++) {
      var maxWidth = headers[col].length;
      for (var row = 0; row < data.length; row++) {
        maxWidth = maxWidth < data[row][col].length ? data[row][col].length : maxWidth;
      }
      sheet.setColumnWidth(col, maxWidth + 2);
    }

    final bytes = excel.encode()!;
    final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    final outputName = '${fileName}_$timestamp.xlsx';

    if (kIsWeb) {
      // Web download
      final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', outputName)
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Write to file
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$outputName');
      await file.writeAsBytes(bytes);
      await OpenFile.open(file.path);
    }
  }

  // ----- DATA FORMATTERS -----
  static List<List<String>> formatBookData(List<Map<String, String>> books) => 
    books.map((b) => [
      b['bookId'] ?? '',
      b['title']  ?? '',
      b['author'] ?? '',
      b['year']   ?? '',
      b['category'] ?? '',
      b['condition'] ?? '',
      b['copies'] ?? '',
    ]).toList();

  static List<List<String>> formatUserData(List<Map<String, String>> users) =>
    users.map((u) => [
      u['userId'] ?? '',
      u['name']   ?? '',
      u['email']  ?? '',
      u['course'] ?? '',
      u['yearLevel'] ?? '',
      u['status'] ?? '',
    ]).toList();

  static List<List<String>> formatBorrowedBookData(List<dynamic> borrowedBooks) =>
    borrowedBooks.map((b) => [
      b.borrowID.toString(),
      b.userID.toString(),
      b.name.toString(),
      b.bookName.toString(),
      b.status.toString(),
      b.borrowDate.toString(),
      b.dueDate.toString(),
      b.returnDate.toString(),
    ]).toList();
}
