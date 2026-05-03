import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/// Schedule Importer Admin Page
///
/// Allows admins to upload a schedule PDF, preview extracted data,
/// and import it into the database via the Node.js backend API.
///
/// Dependencies to add to pubspec.yaml:
///   file_picker: ^6.0.0
///   http: ^1.1.0
///   http_parser: ^4.0.2

class ScheduleImporterPage extends StatefulWidget {
  const ScheduleImporterPage({super.key});

  @override
  State<ScheduleImporterPage> createState() => _ScheduleImporterPageState();
}

class _ScheduleImporterPageState extends State<ScheduleImporterPage> {
  // ─── State ────────────────────────────────────────────────────────────────
  static const String _apiBase = 'http://localhost:3000/api/admin/schedule-import';

  PlatformFile? _selectedFile;
  String _semester     = 'Spring';
  String _academicYear = '2025/2026';
  bool   _isDryRun     = false;

  _ImportStatus _status = _ImportStatus.idle;
  String?       _errorMessage;
  ImportReport? _importReport;
  PreviewData?  _previewData;

  final _yearController = TextEditingController(text: '2025/2026');

  // ─── File picker ──────────────────────────────────────────────────────────
  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile  = result.files.first;
        _importReport  = null;
        _previewData   = null;
        _errorMessage  = null;
        _status        = _ImportStatus.idle;
      });
    }
  }

  // ─── Preview (dry-run scrape) ─────────────────────────────────────────────
  Future<void> _previewSchedule() async {
    if (_selectedFile == null) return;
    setState(() {
      _status       = _ImportStatus.previewing;
      _errorMessage = null;
      _previewData  = null;
    });

    try {
      final uri      = Uri.parse('$_apiBase/preview');
      final request  = http.MultipartRequest('POST', uri);
      request.fields['semester']     = _semester;
      request.fields['academicYear'] = _yearController.text;

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        _selectedFile!.bytes!,
        filename:    _selectedFile!.name,
        contentType: MediaType('application', 'pdf'),
      ));

      final streamed = await request.send();
      final body     = await streamed.stream.bytesToString();
      final json     = jsonDecode(body) as Map<String, dynamic>;

      if (!json['success']) throw Exception(json['error'] ?? 'Unknown error');

      setState(() {
        _status      = _ImportStatus.previewed;
        _previewData = PreviewData.fromJson(json);
      });
    } catch (e) {
      setState(() {
        _status       = _ImportStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  // ─── Import to database ───────────────────────────────────────────────────
  Future<void> _importSchedule() async {
    if (_selectedFile == null) return;

    // Confirm with user
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirm Import'),
        content: Text(
          'This will replace all schedule data for "$_semester ${_yearController.text}" '
          'for the courses in this PDF.\n\nProceed?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true),  child: const Text('Import')),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() {
      _status       = _ImportStatus.importing;
      _errorMessage = null;
      _importReport = null;
    });

    try {
      final uri     = Uri.parse('$_apiBase/upload');
      final request = http.MultipartRequest('POST', uri);
      request.fields['semester']     = _semester;
      request.fields['academicYear'] = _yearController.text;
      request.fields['dryRun']       = _isDryRun.toString();

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        _selectedFile!.bytes!,
        filename:    _selectedFile!.name,
        contentType: MediaType('application', 'pdf'),
      ));

      final streamed = await request.send();
      final body     = await streamed.stream.bytesToString();
      final json     = jsonDecode(body) as Map<String, dynamic>;

      if (!json['success']) throw Exception(json['error'] ?? 'Unknown error');

      setState(() {
        _status       = _ImportStatus.done;
        _importReport = ImportReport.fromJson(json['report'] as Map<String, dynamic>);
      });
    } catch (e) {
      setState(() {
        _status       = _ImportStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Importer'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(theme),
                const SizedBox(height: 24),
                _buildConfigCard(theme),
                const SizedBox(height: 16),
                _buildFileCard(theme),
                const SizedBox(height: 16),
                _buildActionButtons(theme),
                const SizedBox(height: 24),
                if (_status == _ImportStatus.previewing || _status == _ImportStatus.importing)
                  _buildLoadingIndicator(),
                if (_status == _ImportStatus.error && _errorMessage != null)
                  _buildErrorCard(_errorMessage!),
                if (_status == _ImportStatus.previewed && _previewData != null)
                  _buildPreviewCard(_previewData!, theme),
                if (_status == _ImportStatus.done && _importReport != null)
                  _buildResultCard(_importReport!, theme),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Upload Schedule PDF', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
      const SizedBox(height: 4),
      Text(
        'Upload the faculty schedule PDF to extract and import course timetables into the database.',
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      ),
    ],
  );

  Widget _buildConfigCard(ThemeData theme) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Import Settings', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _semester,
                decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder()),
                items: ['Spring', 'Fall', 'Summer']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _semester = v!),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: TextField(
                controller: _yearController,
                decoration: const InputDecoration(labelText: 'Academic Year', border: OutlineInputBorder(), hintText: '2025/2026'),
              ),
            ),
          ]),
          const SizedBox(height: 12),
          SwitchListTile(
            title: const Text('Dry Run (preview only — no DB changes)'),
            subtitle: const Text('Scrape the PDF and show results without saving'),
            value: _isDryRun,
            onChanged: (v) => setState(() => _isDryRun = v),
            contentPadding: EdgeInsets.zero,
          ),
        ],
      ),
    ),
  );

  Widget _buildFileCard(ThemeData theme) => Card(
    child: InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          border: Border.all(
            color: _selectedFile != null ? theme.colorScheme.primary : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(children: [
          Icon(
            _selectedFile != null ? Icons.picture_as_pdf : Icons.upload_file,
            size: 48,
            color: _selectedFile != null ? theme.colorScheme.primary : Colors.grey[400],
          ),
          const SizedBox(height: 12),
          if (_selectedFile != null) ...[
            Text(_selectedFile!.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            Text(
              '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: _pickFile, child: const Text('Change file')),
          ] else ...[
            Text('Click to select a schedule PDF', style: theme.textTheme.titleMedium),
            Text('Supports Faculty of Science schedule format', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
          ],
        ]),
      ),
    ),
  );

  Widget _buildActionButtons(ThemeData theme) {
    final isLoading = _status == _ImportStatus.previewing || _status == _ImportStatus.importing;
    return Row(children: [
      Expanded(
        child: OutlinedButton.icon(
          onPressed: (!isLoading && _selectedFile != null) ? _previewSchedule : null,
          icon: const Icon(Icons.preview),
          label: const Text('Preview'),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        flex: 2,
        child: FilledButton.icon(
          onPressed: (!isLoading && _selectedFile != null) ? _importSchedule : null,
          icon: Icon(_isDryRun ? Icons.science : Icons.cloud_upload),
          label: Text(_isDryRun ? 'Dry Run Import' : 'Import to Database'),
        ),
      ),
    ]);
  }

  Widget _buildLoadingIndicator() => const Padding(
    padding: EdgeInsets.all(32),
    child: Column(children: [
      CircularProgressIndicator(),
      SizedBox(height: 16),
      Text('Processing PDF...'),
    ]),
  );

  Widget _buildErrorCard(String message) => Card(
    color: Colors.red[50],
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(children: [
        const Icon(Icons.error_outline, color: Colors.red),
        const SizedBox(width: 12),
        Expanded(child: Text(message, style: const TextStyle(color: Colors.red))),
      ]),
    ),
  );

  Widget _buildPreviewCard(PreviewData data, ThemeData theme) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.preview, color: Colors.blue),
          const SizedBox(width: 8),
          Text('Preview Results', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        _statRow('Total schedule entries', data.totalEntries.toString()),
        _statRow('Programs found', data.programs.length.toString()),
        const Divider(height: 24),
        Text('Programs detected:', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: data.programs.map((p) => Chip(label: Text(p, style: const TextStyle(fontSize: 12)))).toList(),
        ),
        const Divider(height: 24),
        Text('Sample entries (first 5):', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        ...data.schedules.take(5).map((e) => _scheduleEntryTile(e, theme)),
      ]),
    ),
  );

  Widget _buildResultCard(ImportReport report, ThemeData theme) => Card(
    color: report.errors.isEmpty ? Colors.green[50] : Colors.orange[50],
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Icon(
            report.errors.isEmpty ? Icons.check_circle : Icons.warning_amber,
            color: report.errors.isEmpty ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text(
            report.dryRun ? 'Dry Run Complete' : 'Import Complete',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ]),
        const SizedBox(height: 12),
        _statRow('Scraped entries',    report.scrapedEntries.toString()),
        _statRow('Schedules inserted', report.schedulesInserted.toString()),
        _statRow('Skipped',            report.schedulesSkipped.toString()),
        _statRow('Errors',             report.errors.length.toString()),
        if (report.durationMs != null)
          _statRow('Duration', '${report.durationMs}ms'),
        if (report.errors.isNotEmpty) ...[
          const Divider(height: 24),
          Text('Errors (${report.errors.length}):', style: theme.textTheme.labelLarge?.copyWith(color: Colors.orange[800])),
          const SizedBox(height: 8),
          ...report.errors.take(5).map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text('• ${e['entry']}: ${(e['reasons'] as List).join(', ')}',
                style: const TextStyle(fontSize: 12, color: Colors.red)),
          )),
          if (report.errors.length > 5)
            Text('...and ${report.errors.length - 5} more', style: const TextStyle(fontSize: 12)),
        ],
      ]),
    ),
  );

  Widget _statRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: Colors.grey))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
    ]),
  );

  Widget _scheduleEntryTile(Map<String, dynamic> entry, ThemeData theme) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.grey[100],
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(children: [
      Container(
        width: 70,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          entry['courseCode'] ?? 'N/A',
          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: theme.colorScheme.onPrimaryContainer),
        ),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(entry['program'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        Text(
          '${entry['dayOfWeek'] ?? '?'} ${entry['startTime'] ?? '?'} – ${entry['endTime'] ?? '?'}',
          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
        ),
      ])),
      if (entry['location'] != null)
        Text(entry['location'], style: TextStyle(fontSize: 11, color: Colors.grey[500])),
    ]),
  );

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }
}

// ─── Data models ─────────────────────────────────────────────────────────────

enum _ImportStatus { idle, previewing, previewed, importing, done, error }

class PreviewData {
  final int totalEntries;
  final List<String> programs;
  final List<Map<String, dynamic>> schedules;

  const PreviewData({required this.totalEntries, required this.programs, required this.schedules});

  factory PreviewData.fromJson(Map<String, dynamic> j) => PreviewData(
    totalEntries: j['totalEntries'] as int,
    programs:     List<String>.from(j['programs'] as List),
    schedules:    List<Map<String, dynamic>>.from(j['schedules'] as List),
  );
}

class ImportReport {
  final int scrapedEntries;
  final int schedulesInserted;
  final int schedulesSkipped;
  final List<dynamic> errors;
  final List<String> programs;
  final bool dryRun;
  final int? durationMs;

  const ImportReport({
    required this.scrapedEntries,
    required this.schedulesInserted,
    required this.schedulesSkipped,
    required this.errors,
    required this.programs,
    required this.dryRun,
    this.durationMs,
  });

  factory ImportReport.fromJson(Map<String, dynamic> j) => ImportReport(
    scrapedEntries:    j['scrapedEntries']    as int,
    schedulesInserted: j['schedulesInserted'] as int,
    schedulesSkipped:  j['schedulesSkipped']  as int,
    errors:            List<dynamic>.from(j['errors'] as List),
    programs:          List<String>.from((j['programs'] as List?) ?? []),
    dryRun:            j['dryRun'] as bool,
    durationMs:        j['durationMs'] as int?,
  );
}
