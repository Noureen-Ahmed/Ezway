import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../core/api_config.dart';
import '../../providers/app_session_provider.dart';
import 'package:flutter/services.dart';

class ScheduleImportPage extends ConsumerStatefulWidget {
  const ScheduleImportPage({super.key});

  @override
  ConsumerState<ScheduleImportPage> createState() => _ScheduleImportPageState();
}

class _ScheduleImportPageState extends ConsumerState<ScheduleImportPage> {
  PlatformFile? _selectedFile;
  String _semester     = 'Spring';
  final String _academicYear = '2025/2026';
  bool   _isDryRun     = false;

  _ImportStatus _status = _ImportStatus.idle;
  String?       _errorMessage;
  _ImportReport? _importReport;
  _PreviewData?  _previewData;

  final _yearController = TextEditingController(text: '2025/2026');

  String get _apiBase => '${ApiConfig.baseUrl}/admin/schedule-import';

  Map<String, String> get _authHeader {
    final token = ApiConfig.authToken;
    return token != null ? {'Authorization': 'Bearer $token'} : {};
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true,
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _selectedFile = result.files.first;
        _importReport = null;
        _previewData  = null;
        _errorMessage = null;
        _status       = _ImportStatus.idle;
      });
    }
  }

  Future<void> _previewSchedule() async {
    if (_selectedFile == null) return;
    setState(() {
      _status       = _ImportStatus.previewing;
      _errorMessage = null;
      _previewData  = null;
    });

    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_apiBase/preview'));
      request.headers.addAll(_authHeader);
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

      if (json['success'] != true) throw Exception(json['error'] ?? 'Unknown error');

      setState(() {
        _status      = _ImportStatus.previewed;
        _previewData = _PreviewData.fromJson(json);
      });
    } catch (e) {
      setState(() {
        _status       = _ImportStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  Future<void> _importSchedule() async {
    if (_selectedFile == null) return;

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
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Import')),
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
      final request = http.MultipartRequest('POST', Uri.parse('$_apiBase/upload'));
      request.headers.addAll(_authHeader);
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

      if (json['success'] != true) throw Exception(json['error'] ?? 'Unknown error');

      setState(() {
        _status       = _ImportStatus.done;
        _importReport = _ImportReport.fromJson(json['report'] as Map<String, dynamic>);
      });
    } catch (e) {
      setState(() {
        _status       = _ImportStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Admin Panel'),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () async {
              await ref.read(appSessionControllerProvider.notifier).logout();
            },
          ),
        ],
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
                  _buildLoadingIndicator(_status),
                if (_status == _ImportStatus.error && _errorMessage != null)
                  _buildErrorCard(_errorMessage!),
                if (_status == _ImportStatus.previewed && _previewData != null)
                  _buildPreviewCard(_previewData!, theme),
                if (_status == _ImportStatus.done && _importReport != null)
                  _buildResultCard(_importReport!, theme),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                _ProfessorCourseAssignmentSection(authHeader: _authHeader, apiBase: ApiConfig.baseUrl),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                _EnrollmentSyncSection(authHeader: _authHeader, apiBase: ApiConfig.baseUrl),
                const SizedBox(height: 32),
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
      Text('Upload Schedule PDF',
          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF002147))),
      const SizedBox(height: 4),
      Text(
        'Upload the faculty schedule PDF to extract and import course timetables into the database.',
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
      ),
    ],
  );

  Widget _buildConfigCard(ThemeData theme) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
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
                initialValue: _semester,
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
                decoration: const InputDecoration(
                  labelText: 'Academic Year',
                  border: OutlineInputBorder(),
                  hintText: '2025/2026',
                ),
              ),
            ),
          ]),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Dry Run'),
            subtitle: const Text('Scrape PDF and preview results without saving to database'),
            value: _isDryRun,
            onChanged: (v) => setState(() => _isDryRun = v),
            contentPadding: EdgeInsets.zero,
            activeThumbColor: const Color(0xFF002147),
          ),
        ],
      ),
    ),
  );

  Widget _buildFileCard(ThemeData theme) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(
        color: _selectedFile != null ? const Color(0xFF002147) : const Color(0xFFE5E7EB),
        width: _selectedFile != null ? 2 : 1,
      ),
    ),
    child: InkWell(
      onTap: _pickFile,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(children: [
          Icon(
            _selectedFile != null ? Icons.picture_as_pdf : Icons.upload_file,
            size: 48,
            color: _selectedFile != null ? const Color(0xFF002147) : Colors.grey[400],
          ),
          const SizedBox(height: 12),
          if (_selectedFile != null) ...[
            Text(_selectedFile!.name,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            Text(
              '${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: _pickFile, child: const Text('Change file')),
          ] else ...[
            Text('Tap to select a schedule PDF', style: theme.textTheme.titleMedium),
            const SizedBox(height: 4),
            Text('Supports Faculty of Science schedule format',
                style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[500])),
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
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF002147),
            side: const BorderSide(color: Color(0xFF002147)),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        flex: 2,
        child: FilledButton.icon(
          onPressed: (!isLoading && _selectedFile != null) ? _importSchedule : null,
          icon: Icon(_isDryRun ? Icons.science : Icons.cloud_upload),
          label: Text(_isDryRun ? 'Dry Run Import' : 'Import to Database'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF002147),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    ]);
  }

  Widget _buildLoadingIndicator(_ImportStatus status) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 32),
    child: Column(children: [
      const CircularProgressIndicator(color: Color(0xFF002147)),
      const SizedBox(height: 16),
      Text(
        status == _ImportStatus.previewing ? 'Scraping PDF...' : 'Saving to database...',
        style: const TextStyle(color: Color(0xFF6B7280)),
      ),
    ]),
  );

  Widget _buildErrorCard(String message) => Card(
    color: Colors.red[50],
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Error', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text(message, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => setState(() { _status = _ImportStatus.idle; _errorMessage = null; }),
                child: const Text('Dismiss'),
              ),
            ],
          )),
        ],
      ),
    ),
  );

  Widget _buildPreviewCard(_PreviewData data, ThemeData theme) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: const BorderSide(color: Color(0xFF3B82F6)),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
            child: const Icon(Icons.preview, color: Colors.blue, size: 18),
          ),
          const SizedBox(width: 8),
          Text('Preview Results', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
        ]),
        const SizedBox(height: 12),
        _statRow('Total schedule entries', '${data.totalEntries}'),
        _statRow('Programs found', '${data.programs.length}'),
        const Divider(height: 24),
        Text('Programs detected', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8, runSpacing: 8,
          children: data.programs.map((p) => Chip(
            label: Text(p, style: const TextStyle(fontSize: 12)),
            backgroundColor: const Color(0xFFEFF6FF),
          )).toList(),
        ),
        const Divider(height: 24),
        Text('Sample entries (first 5)', style: theme.textTheme.labelLarge),
        const SizedBox(height: 8),
        ...data.schedules.take(5).map((e) => _scheduleEntryTile(e, theme)),
      ]),
    ),
  );

  Widget _buildResultCard(_ImportReport report, ThemeData theme) {
    final isSuccess = report.errors.isEmpty;
    return Card(
      elevation: 0,
      color: isSuccess ? Colors.green[50] : Colors.orange[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: isSuccess ? Colors.green : Colors.orange),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.warning_amber,
              color: isSuccess ? Colors.green : Colors.orange,
            ),
            const SizedBox(width: 8),
            Text(
              report.dryRun ? 'Dry Run Complete' : 'Import Complete',
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ]),
          const SizedBox(height: 12),
          _statRow('Scraped entries',    '${report.scrapedEntries}'),
          _statRow('Schedules inserted', '${report.schedulesInserted}'),
          _statRow('Skipped',            '${report.schedulesSkipped}'),
          _statRow('Errors',             '${report.errors.length}'),
          if (report.enrollmentsLinked != null)
            _statRow('Enrollments linked', '${report.enrollmentsLinked}'),
          if (report.durationMs != null)
            _statRow('Duration', '${report.durationMs}ms'),
          if (report.errors.isNotEmpty) ...[
            const Divider(height: 24),
            Text('Errors (${report.errors.length})',
                style: theme.textTheme.labelLarge?.copyWith(color: Colors.orange[800])),
            const SizedBox(height: 8),
            ...report.errors.take(5).map((e) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(
                '• ${e['entry']}: ${(e['reasons'] as List).join(', ')}',
                style: const TextStyle(fontSize: 12, color: Colors.red),
              ),
            )),
            if (report.errors.length > 5)
              Text('...and ${report.errors.length - 5} more',
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
          ],
        ]),
      ),
    );
  }

  Widget _statRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF6B7280)))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF002147))),
    ]),
  );

  Widget _scheduleEntryTile(Map<String, dynamic> entry, ThemeData theme) => Container(
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: const Color(0xFFE5E7EB)),
    ),
    child: Row(children: [
      Container(
        width: 72,
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFF002147).withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          entry['courseCode'] ?? 'N/A',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF002147)),
          overflow: TextOverflow.ellipsis,
        ),
      ),
      const SizedBox(width: 10),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(entry['program'] ?? '', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        Text(
          '${entry['dayOfWeek'] ?? '?'}  ${entry['startTime'] ?? '?'} – ${entry['endTime'] ?? '?'}',
          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
        ),
      ])),
      if (entry['location'] != null)
        Text(entry['location'].toString(), style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280))),
    ]),
  );

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }
}

// ─── Professor → Course assignment section ────────────────────────────────────

class _ProfessorCourseAssignmentSection extends StatefulWidget {
  final Map<String, String> authHeader;
  final String apiBase;
  const _ProfessorCourseAssignmentSection({required this.authHeader, required this.apiBase});

  @override
  State<_ProfessorCourseAssignmentSection> createState() => _ProfessorCourseAssignmentSectionState();
}

class _ProfessorCourseAssignmentSectionState extends State<_ProfessorCourseAssignmentSection> {
  List<Map<String, dynamic>> _professors = [];
  List<Map<String, dynamic>> _allCourses = [];
  bool _loading = false;
  String? _error;
  String? _success;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final headers = {...widget.authHeader, 'Content-Type': 'application/json'};
      final results = await Future.wait([
        http.get(Uri.parse('${widget.apiBase}/admin/users?role=PROFESSOR&limit=100'), headers: headers),
        http.get(Uri.parse('${widget.apiBase}/admin/courses?limit=200'), headers: headers),
      ]);
      final profsData = jsonDecode(results[0].body);
      final coursesData = jsonDecode(results[1].body);

      // For each professor, also load their assigned courses
      final profs = List<Map<String, dynamic>>.from(profsData['users'] ?? []);
      for (final p in profs) {
        final r = await http.get(
          Uri.parse('${widget.apiBase}/admin/professors/${p['id']}/courses'),
          headers: headers,
        );
        final d = jsonDecode(r.body);
        p['assignedCourses'] = List<Map<String, dynamic>>.from(d['courses'] ?? []);
      }

      setState(() {
        _professors = profs;
        _allCourses = List<Map<String, dynamic>>.from(coursesData['courses'] ?? []);
        _loading = false;
      });
    } catch (e) {
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  Future<void> _assign(String professorId, String courseId) async {
    try {
      final r = await http.post(
        Uri.parse('${widget.apiBase}/admin/courses/$courseId/instructors'),
        headers: {...widget.authHeader, 'Content-Type': 'application/json'},
        body: jsonEncode({'userId': professorId, 'isPrimary': true}),
      );
      if (r.statusCode == 200 || r.statusCode == 201) {
        setState(() => _success = 'Assigned successfully');
        await _load();
      } else {
        setState(() => _error = jsonDecode(r.body)['error']?.toString() ?? 'Failed');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _remove(String professorId, String courseId) async {
    try {
      final r = await http.delete(
        Uri.parse('${widget.apiBase}/admin/courses/$courseId/instructors/$professorId'),
        headers: widget.authHeader,
      );
      if (r.statusCode == 200) {
        setState(() => _success = 'Removed');
        await _load();
      } else {
        setState(() => _error = 'Failed to remove');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Text('Doctor → Course Assignment',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF002147))),
          const Spacer(),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh), tooltip: 'Refresh'),
        ]),
        const SizedBox(height: 4),
        Text('Assign each doctor to their courses so they can upload content.',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600])),
        const SizedBox(height: 16),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        if (_success != null)
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
            child: Text(_success!, style: const TextStyle(color: Colors.green)),
          ),
        if (_loading)
          const Center(child: CircularProgressIndicator(color: Color(0xFF002147)))
        else if (_professors.isEmpty)
          Card(
            color: Colors.orange[50],
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No professor accounts found. Create a professor account first.'),
            ),
          )
        else
          ..._professors.map((prof) => _ProfessorCard(
            professor: prof,
            allCourses: _allCourses,
            onAssign: (courseId) => _assign(prof['id'] as String, courseId),
            onRemove: (courseId) => _remove(prof['id'] as String, courseId),
          )),
      ],
    );
  }
}

class _ProfessorCard extends StatefulWidget {
  final Map<String, dynamic> professor;
  final List<Map<String, dynamic>> allCourses;
  final Future<void> Function(String courseId) onAssign;
  final Future<void> Function(String courseId) onRemove;

  const _ProfessorCard({required this.professor, required this.allCourses, required this.onAssign, required this.onRemove});

  @override
  State<_ProfessorCard> createState() => _ProfessorCardState();
}

class _ProfessorCardState extends State<_ProfessorCard> {
  String? _selectedCourseId;

  @override
  Widget build(BuildContext context) {
    final assigned = List<Map<String, dynamic>>.from(widget.professor['assignedCourses'] ?? []);
    final assignedIds = assigned.map((c) => c['id'] as String).toSet();
    final unassigned = widget.allCourses.where((c) => !assignedIds.contains(c['id'])).toList();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: assigned.isEmpty ? Colors.red.shade200 : const Color(0xFFE5E7EB),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            CircleAvatar(
              backgroundColor: const Color(0xFF002147),
              child: Text(
                (widget.professor['name'] as String? ?? 'P')[0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(widget.professor['name'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text(widget.professor['email'] as String? ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: assigned.isEmpty ? Colors.red[50] : Colors.green[50],
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                assigned.isEmpty ? 'No courses assigned' : '${assigned.length} course(s)',
                style: TextStyle(
                  fontSize: 12,
                  color: assigned.isEmpty ? Colors.red : Colors.green[700],
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ]),

          if (assigned.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text('Assigned courses:', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: assigned.map((c) => Chip(
                label: Text('${c['code']} - ${c['name']}', style: const TextStyle(fontSize: 11)),
                deleteIcon: const Icon(Icons.close, size: 14),
                onDeleted: () => widget.onRemove(c['id'] as String),
                backgroundColor: const Color(0xFFEFF6FF),
              )).toList(),
            ),
          ],

          if (unassigned.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: _selectedCourseId,
                  decoration: const InputDecoration(
                    labelText: 'Add a course',
                    border: OutlineInputBorder(),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: unassigned.map((c) => DropdownMenuItem(
                    value: c['id'] as String,
                    child: Text('${c['code']} – ${c['name']}', style: const TextStyle(fontSize: 13)),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedCourseId = v),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: _selectedCourseId != null
                    ? () async {
                        await widget.onAssign(_selectedCourseId!);
                        setState(() => _selectedCourseId = null);
                      }
                    : null,
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF002147)),
                child: const Text('Assign'),
              ),
            ]),
          ],
        ]),
      ),
    );
  }
}

// ─── Enrollment sync section ──────────────────────────────────────────────────

class _EnrollmentSyncSection extends StatefulWidget {
  final Map<String, String> authHeader;
  final String apiBase;
  const _EnrollmentSyncSection({required this.authHeader, required this.apiBase});

  @override
  State<_EnrollmentSyncSection> createState() => _EnrollmentSyncSectionState();
}

class _EnrollmentSyncSectionState extends State<_EnrollmentSyncSection> {
  bool _loading = false;
  Map<String, dynamic>? _result;
  String? _error;

  Future<void> _runSync() async {
    setState(() { _loading = true; _error = null; _result = null; });
    try {
      final r = await http.post(
        Uri.parse('${widget.apiBase}/admin/sync-enrollments'),
        headers: widget.authHeader,
      );
      final data = jsonDecode(r.body) as Map<String, dynamic>;
      if (data['success'] == true) {
        setState(() { _result = data; _loading = false; });
      } else {
        setState(() { _error = data['error']?.toString() ?? 'Failed'; _loading = false; });
      }
    } catch (e) {
      setState(() { _loading = false; _error = e.toString(); });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Student Enrollment Sync',
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF002147))),
        const SizedBox(height: 4),
        Text(
          'Re-matches students\' UMS courses to DB courses and creates enrollment records. '
          'Run this if students are not receiving notifications after the doctor uploads content.',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _loading ? null : _runSync,
          icon: _loading
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : const Icon(Icons.sync),
          label: Text(_loading ? 'Syncing...' : 'Fix Enrollments Now'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF002147),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          ),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
            child: Text(_error!, style: const TextStyle(color: Colors.red)),
          ),
        ],
        if (_result != null) ...[
          const SizedBox(height: 12),
          Card(
            color: Colors.green[50],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.green),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Row(children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Sync Complete', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.green)),
                ]),
                const SizedBox(height: 12),
                _infoRow('Enrollments created/updated', '${_result!['totalEnrolled'] ?? 0}'),
                _infoRow('Unmatched UMS courses', '${_result!['unmatchedCount'] ?? 0}'),
                if ((_result!['unmatchedCount'] ?? 0) > 0) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Unmatched courses below — the course codes in the DB don\'t match what UMS returns. '
                    'Fix the course codes in DB to match these:',
                    style: TextStyle(fontSize: 12, color: Colors.orange),
                  ),
                  const SizedBox(height: 8),
                  ...List<Map<String, dynamic>>.from(_result!['unmatchedCourses'] ?? []).take(10).map((m) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Row(children: [
                        const Icon(Icons.warning_amber, size: 14, color: Colors.orange),
                        const SizedBox(width: 6),
                        Expanded(child: Text(
                          '${m['umsCode']} – ${m['umsName']} (student: ${m['student']})',
                          style: const TextStyle(fontSize: 11),
                        )),
                        GestureDetector(
                          onTap: () => Clipboard.setData(ClipboardData(text: m['umsCode'] as String? ?? '')),
                          child: const Icon(Icons.copy, size: 14, color: Colors.grey),
                        ),
                      ]),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ],
    );
  }

  Widget _infoRow(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF6B7280)))),
      Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF002147))),
    ]),
  );
}

// ─── Data models ──────────────────────────────────────────────────────────────

enum _ImportStatus { idle, previewing, previewed, importing, done, error }

class _PreviewData {
  final int totalEntries;
  final List<String> programs;
  final List<Map<String, dynamic>> schedules;

  const _PreviewData({required this.totalEntries, required this.programs, required this.schedules});

  factory _PreviewData.fromJson(Map<String, dynamic> j) => _PreviewData(
    totalEntries: j['totalEntries'] as int,
    programs:     List<String>.from(j['programs'] as List),
    schedules:    List<Map<String, dynamic>>.from(j['schedules'] as List),
  );
}

class _ImportReport {
  final int scrapedEntries;
  final int schedulesInserted;
  final int schedulesSkipped;
  final List<dynamic> errors;
  final List<String> programs;
  final bool dryRun;
  final int? durationMs;
  final int? enrollmentsLinked;

  const _ImportReport({
    required this.scrapedEntries,
    required this.schedulesInserted,
    required this.schedulesSkipped,
    required this.errors,
    required this.programs,
    required this.dryRun,
    this.durationMs,
    this.enrollmentsLinked,
  });

  factory _ImportReport.fromJson(Map<String, dynamic> j) => _ImportReport(
    scrapedEntries:    j['scrapedEntries']    as int,
    schedulesInserted: j['schedulesInserted'] as int,
    schedulesSkipped:  j['schedulesSkipped']  as int,
    errors:            List<dynamic>.from(j['errors'] as List),
    programs:          List<String>.from((j['programs'] as List?) ?? []),
    dryRun:            j['dryRun'] as bool,
    durationMs:        j['durationMs'] as int?,
    enrollmentsLinked: j['enrollmentsLinked'] as int?,
  );
}

