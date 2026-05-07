import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:http_parser/http_parser.dart';
import '../../core/api_config.dart';
import '../../providers/app_session_provider.dart';

class AdminPanelPage extends ConsumerStatefulWidget {
  const AdminPanelPage({super.key});

  @override
  ConsumerState<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends ConsumerState<AdminPanelPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
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
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          _ScheduleSection(),
          _DoctorsSection(),
          _RegisterSection(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        selectedItemColor: const Color(0xFF002147),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Schedule'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Doctors'),
          BottomNavigationBarItem(icon: Icon(Icons.person_add), label: 'Register'),
        ],
      ),
    );
  }
}

// ==================== SCHEDULE SECTION ====================
class _ScheduleSection extends ConsumerStatefulWidget {
  const _ScheduleSection();

  @override
  ConsumerState<_ScheduleSection> createState() => _ScheduleSectionState();
}

class _ScheduleSectionState extends ConsumerState<_ScheduleSection> {
  PlatformFile? _selectedFile;
  String _semester = 'Spring';
  bool _isDryRun = false;

  _ImportStatus _status = _ImportStatus.idle;
  String? _errorMessage;
  _ImportReport? _importReport;
  _PreviewData? _previewData;

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
        _previewData = null;
        _errorMessage = null;
        _status = _ImportStatus.idle;
      });
    }
  }

  Future<void> _previewSchedule() async {
    if (_selectedFile == null) return;
    setState(() {
      _status = _ImportStatus.previewing;
      _errorMessage = null;
      _previewData = null;
    });

    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_apiBase/preview'));
      request.headers.addAll(_authHeader);
      request.fields['semester'] = _semester;
      request.fields['academicYear'] = _yearController.text;
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        _selectedFile!.bytes!,
        filename: _selectedFile!.name,
        contentType: MediaType('application', 'pdf'),
      ));

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();
      final json = jsonDecode(body) as Map<String, dynamic>;

      if (json['success'] != true) throw Exception(json['error'] ?? 'Unknown error');

      setState(() {
        _status = _ImportStatus.previewed;
        _previewData = _PreviewData.fromJson(json);
      });
    } catch (e) {
      setState(() {
        _status = _ImportStatus.error;
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
      _status = _ImportStatus.importing;
      _errorMessage = null;
      _importReport = null;
    });

    try {
      final request = http.MultipartRequest('POST', Uri.parse('$_apiBase/upload'));
      request.headers.addAll(_authHeader);
      request.fields['semester'] = _semester;
      request.fields['academicYear'] = _yearController.text;
      request.fields['dryRun'] = _isDryRun.toString();
      request.files.add(http.MultipartFile.fromBytes(
        'file',
        _selectedFile!.bytes!,
        filename: _selectedFile!.name,
        contentType: MediaType('application', 'pdf'),
      ));

      final streamed = await request.send();
      final body = await streamed.stream.bytesToString();
      final json = jsonDecode(body) as Map<String, dynamic>;

      if (json['success'] != true) throw Exception(json['error'] ?? 'Unknown error');

      setState(() {
        _status = _ImportStatus.done;
        _importReport = _ImportReport.fromJson(json['report'] as Map<String, dynamic>);
      });
    } catch (e) {
      setState(() {
        _status = _ImportStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 16),
              _buildConfigCard(theme),
              const SizedBox(height: 12),
              _buildFileCard(theme),
              const SizedBox(height: 12),
              _buildActionButtons(theme),
              const SizedBox(height: 16),
              if (_status == _ImportStatus.previewing || _status == _ImportStatus.importing)
                _buildLoadingIndicator(_status),
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
    );
  }

  Widget _buildHeader(ThemeData theme) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Upload Schedule PDF',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF002147))),
          const SizedBox(height: 4),
          Text(
            'Upload the faculty schedule PDF to extract and import course timetables.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
          ),
        ],
      );

  Widget _buildConfigCard(ThemeData theme) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Import Settings', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _semester,
                    decoration: const InputDecoration(labelText: 'Semester', border: OutlineInputBorder(), isDense: true),
                    items: ['Spring', 'Fall', 'Summer']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (v) => setState(() => _semester = v!),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: _yearController,
                    decoration: const InputDecoration(
                      labelText: 'Academic Year',
                      border: OutlineInputBorder(),
                      hintText: '2025/2026',
                      isDense: true,
                    ),
                  ),
                ),
              ]),
              const SizedBox(height: 8),
              SwitchListTile(
                title: const Text('Dry Run', style: TextStyle(fontSize: 13)),
                subtitle: const Text('Preview without saving', style: TextStyle(fontSize: 11)),
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
            padding: const EdgeInsets.all(24),
            child: Column(children: [
              Icon(
                _selectedFile != null ? Icons.picture_as_pdf : Icons.upload_file,
                size: 40,
                color: _selectedFile != null ? const Color(0xFF002147) : Colors.grey[400],
              ),
              const SizedBox(height: 8),
              if (_selectedFile != null) ...[
                Text(_selectedFile!.name,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1),
                Text('${(_selectedFile!.size / 1024).toStringAsFixed(1)} KB',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
                TextButton(onPressed: _pickFile, child: const Text('Change file')),
              ] else ...[
                Text('Tap to select a schedule PDF', style: theme.textTheme.titleSmall),
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
          icon: const Icon(Icons.preview, size: 18),
          label: const Text('Preview'),
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF002147),
            side: const BorderSide(color: Color(0xFF002147)),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        flex: 2,
        child: FilledButton.icon(
          onPressed: (!isLoading && _selectedFile != null) ? _importSchedule : null,
          icon: Icon(_isDryRun ? Icons.science : Icons.cloud_upload, size: 18),
          label: Text(_isDryRun ? 'Dry Run' : 'Import'),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF002147),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    ]);
  }

  Widget _buildLoadingIndicator(_ImportStatus status) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(children: [
          const CircularProgressIndicator(color: Color(0xFF002147)),
          const SizedBox(height: 12),
          Text(status == _ImportStatus.previewing ? 'Scraping PDF...' : 'Saving to database...',
              style: const TextStyle(color: Color(0xFF6B7280))),
        ]),
      );

  Widget _buildErrorCard(String message) => Card(
        color: Colors.red[50],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 20),
              const SizedBox(width: 8),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Error', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(message, style: const TextStyle(color: Colors.red, fontSize: 12)),
                ],
              )),
              TextButton(
                  onPressed: () => setState(() {
                        _status = _ImportStatus.idle;
                        _errorMessage = null;
                      }),
                  child: const Text('Dismiss', style: TextStyle(fontSize: 12))),
            ],
          ),
        ),
      );

  Widget _buildPreviewCard(_PreviewData data, ThemeData theme) => Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFF3B82F6))),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.blue[50], borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.preview, color: Colors.blue, size: 16),
              ),
              const SizedBox(width: 8),
              Text('Preview Results', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
            ]),
            const SizedBox(height: 8),
            _statRow('Total entries', '${data.totalEntries}'),
            _statRow('Programs found', '${data.programs.length}'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: data.programs
                  .map((p) => Chip(
                        label: Text(p, style: const TextStyle(fontSize: 11)),
                        backgroundColor: const Color(0xFFEFF6FF),
                        padding: EdgeInsets.zero,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ))
                  .toList(),
            ),
          ]),
        ),
      );

  Widget _buildResultCard(_ImportReport report, ThemeData theme) {
    final isSuccess = report.errors.isEmpty;
    return Card(
      elevation: 0,
      color: isSuccess ? Colors.green[50] : Colors.orange[50],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: isSuccess ? Colors.green : Colors.orange)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Icon(
              isSuccess ? Icons.check_circle : Icons.warning_amber,
              color: isSuccess ? Colors.green : Colors.orange,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(report.dryRun ? 'Dry Run Complete' : 'Import Complete', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          _statRow('Scraped', '${report.scrapedEntries}'),
          _statRow('Inserted', '${report.schedulesInserted}'),
          _statRow('Skipped', '${report.schedulesSkipped}'),
          _statRow('Errors', '${report.errors.length}'),
          if (report.enrollmentsLinked != null && report.enrollmentsLinked! > 0)
            _statRow('Students auto-enrolled', '${report.enrollmentsLinked}'),
        ]),
      ),
    );
  }

  Widget _statRow(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12))),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF002147), fontSize: 12)),
        ]),
      );

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }
}

// ==================== DOCTORS SECTION ====================
class _DoctorsSection extends StatefulWidget {
  const _DoctorsSection();

  @override
  State<_DoctorsSection> createState() => _DoctorsSectionState();
}

class _DoctorsSectionState extends State<_DoctorsSection> {
  List<Map<String, dynamic>> _doctors = [];
  List<Map<String, dynamic>> _courses = [];
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (!mounted) return;
    setState(() => _loading = true);
    try {
      final headers = {...ApiConfig.authHeaders, 'Content-Type': 'application/json'};
      final results = await Future.wait([
        http.get(Uri.parse('${ApiConfig.baseUrl}/admin/users?role=PROFESSOR&limit=100'), headers: headers),
        http.get(Uri.parse('${ApiConfig.baseUrl}/admin/courses?limit=200'), headers: headers),
      ]);

      final profsData = jsonDecode(results[0].body);
      final coursesData = jsonDecode(results[1].body);

      final profs = List<Map<String, dynamic>>.from(profsData['users'] ?? []);
      for (final p in profs) {
        final r = await http.get(
          Uri.parse('${ApiConfig.baseUrl}/admin/professors/${p['id']}/courses'),
          headers: headers,
        );
        final d = jsonDecode(r.body);
        p['assignedCourses'] = List<Map<String, dynamic>>.from(d['courses'] ?? []);
      }

      if (mounted) {
        setState(() {
          _doctors = profs;
          _courses = List<Map<String, dynamic>>.from(coursesData['courses'] ?? []);
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _assign(String doctorId, String courseId) async {
    try {
      final r = await http.post(
        Uri.parse('${ApiConfig.baseUrl}/admin/courses/$courseId/instructors'),
        headers: {...ApiConfig.authHeaders, 'Content-Type': 'application/json'},
        body: jsonEncode({'userId': doctorId, 'isPrimary': true}),
      );
      if (r.statusCode != 200 && r.statusCode != 201) {
        final err = jsonDecode(r.body)['error']?.toString() ?? 'Failed to assign';
        if (mounted) setState(() => _error = err);
        throw Exception(err);
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      rethrow;
    }
  }

  Future<void> _assignBatch(String doctorId, List<String> courseIds) async {
    if (courseIds.isEmpty) return;
    try {
      // Perform all assignments concurrently without reloading each time
      await Future.wait(
        courseIds.map((courseId) => _assign(doctorId, courseId)),
      );
      // Reload once after all assignments complete
      await _loadData();
    } catch (e) {
      // Error already set in _assign
    }
  }

  Future<void> _remove(String doctorId, String courseId) async {
    try {
      final r = await http.delete(
        Uri.parse('${ApiConfig.baseUrl}/admin/courses/$courseId/instructors/$doctorId'),
        headers: ApiConfig.authHeaders,
      );
      if (r.statusCode == 200) {
        await _loadData();
      }
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
  }

  Future<void> _viewProfile(Map<String, dynamic> doctor) async {
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => _DoctorProfilePage(doctor: doctor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return const Center(child: CircularProgressIndicator(color: Color(0xFF002147)));
    if (_doctors.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.people_outline, size: 64, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text('No doctors found', style: TextStyle(color: Colors.grey[600], fontSize: 16)),
            const SizedBox(height: 8),
            Text('Create a doctor account first', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
          ],
        ),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: Row(children: [
            Text('Doctors (${_doctors.length})', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF002147))),
            const Spacer(),
            IconButton(onPressed: _loadData, icon: const Icon(Icons.refresh, size: 20)),
          ]),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
              child: Row(children: [
                const Icon(Icons.error, color: Colors.red, size: 16),
                const SizedBox(width: 8),
                Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12))),
                IconButton(onPressed: () => setState(() => _error = null), icon: const Icon(Icons.close, size: 16)),
              ]),
            ),
          ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            itemCount: _doctors.length,
            itemBuilder: (context, index) => _DoctorCard(
              key: ValueKey('doctor_${_doctors[index]['id']}'),
              doctor: _doctors[index],
              courses: _courses,
              onAssign: (courseId) => _assign(_doctors[index]['id'] as String, courseId),
              onAssignBatch: (courseIds) => _assignBatch(_doctors[index]['id'] as String, courseIds),
              onRemove: (courseId) => _remove(_doctors[index]['id'] as String, courseId),
              onProfile: () => _viewProfile(_doctors[index]),
            ),
          ),
        ),
      ],
    );
  }
}

class _DoctorCard extends StatefulWidget {
  final Map<String, dynamic> doctor;
  final List<Map<String, dynamic>> courses;
  final Future<void> Function(String courseId) onAssign;
  final Future<void> Function(List<String> courseIds) onAssignBatch;
  final Future<void> Function(String courseId) onRemove;
  final VoidCallback onProfile;

  const _DoctorCard({
    super.key,
    required this.doctor,
    required this.courses,
    required this.onAssign,
    required this.onAssignBatch,
    required this.onRemove,
    required this.onProfile,
  });

  @override
  State<_DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<_DoctorCard> {
  bool _expanded = false;
  String _searchQuery = '';
  final Set<String> _selectedCourseIds = {};

  @override
  Widget build(BuildContext context) {
    final assigned = List<Map<String, dynamic>>.from(widget.doctor['assignedCourses'] ?? []);
    final assignedIds = assigned.map((c) => c['id'] as String).toSet();
    final unassigned = widget.courses.where((c) => !assignedIds.contains(c['id'])).toList();
    final filteredUnassigned = unassigned.where((c) {
      final query = _searchQuery.toLowerCase();
      return (c['code'] as String).toLowerCase().contains(query) ||
          (c['name'] as String? ?? '').toLowerCase().contains(query);
    }).toList();

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10), side: const BorderSide(color: Color(0xFFE5E7EB))),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _expanded = !_expanded;
                if (!_expanded) {
                  _selectedCourseIds.clear();
                  _searchQuery = '';
                }
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFF002147),
                    child: Text(
                      (widget.doctor['name'] as String? ?? 'D')[0].toUpperCase(),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.doctor['name'] as String? ?? '',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          widget.doctor['email'] as String? ?? '',
                          style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: assigned.isEmpty ? Colors.red[50] : Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${assigned.length} course${assigned.length != 1 ? 's' : ''}',
                      style: TextStyle(fontSize: 11, color: assigned.isEmpty ? Colors.red : Colors.green[700], fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.info_outline, size: 20, color: Color(0xFF002147)),
                    onPressed: widget.onProfile,
                    tooltip: 'View Profile',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  ),
                  const SizedBox(width: 8),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more, color: Colors.grey),
                ],
              ),
            ),
          ),
          if (_expanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (assigned.isNotEmpty) ...[
                    const Text('Assigned Courses:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey)),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: assigned
                          .map((c) => Chip(
                                label: Text('${c['code']}', style: const TextStyle(fontSize: 11), overflow: TextOverflow.ellipsis, maxLines: 1),
                                deleteIcon: const Icon(Icons.close, size: 14),
                                onDeleted: () => widget.onRemove(c['id'] as String),
                                backgroundColor: const Color(0xFFEFF6FF),
                                padding: EdgeInsets.zero,
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 12),
                  ],
                  if (unassigned.isNotEmpty) ...[
                    const Text('Add Courses:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    TextField(
                      decoration: InputDecoration(
                        hintText: 'Search courses...',
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.search, size: 18),
                      ),
                      onChanged: (value) => setState(() => _searchQuery = value),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      constraints: const BoxConstraints(maxHeight: 200),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE5E7EB)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: filteredUnassigned.length,
                        itemBuilder: (context, index) {
                          final course = filteredUnassigned[index];
                          final courseId = course['id'] as String;
                          final isSelected = _selectedCourseIds.contains(courseId);
                          return CheckboxListTile(
                            value: isSelected,
                            onChanged: (checked) {
                              setState(() {
                                if (checked == true) {
                                  _selectedCourseIds.add(courseId);
                                } else {
                                  _selectedCourseIds.remove(courseId);
                                }
                              });
                            },
                            title: Text(
                              '${course['code']} - ${course['name']}',
                              style: const TextStyle(fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                            dense: true,
                            controlAffinity: ListTileControlAffinity.leading,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: _selectedCourseIds.isNotEmpty
                        ? () async {
                            await widget.onAssignBatch(_selectedCourseIds.toList());
                            if (mounted) {
                              setState(() {
                                _selectedCourseIds.clear();
                                _searchQuery = '';
                              });
                            }
                          }
                        : null,
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('Add Selected (${_selectedCourseIds.length})'),
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF002147),
                      minimumSize: const Size.fromHeight(40),
                    ),
                  ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ==================== REGISTER SECTION ====================
class _RegisterSection extends ConsumerStatefulWidget {
  const _RegisterSection();

  @override
  ConsumerState<_RegisterSection> createState() => _RegisterSectionState();
}

class _RegisterSectionState extends ConsumerState<_RegisterSection> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  String? _departmentId;
  bool _loading = false;
  String? _error;
  String? _success;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  List<Map<String, dynamic>> _departments = [];

  @override
  void initState() {
    super.initState();
    _loadDepartments();
  }

  Future<void> _loadDepartments() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.baseUrl}/admin/departments'), headers: ApiConfig.authHeaders);
      final data = jsonDecode(response.body);
      if (data['success'] == true) {
        if (mounted) {
          setState(() => _departments = List<Map<String, dynamic>>.from(data['departments'] ?? []));
        }
      } else {
        if (mounted) setState(() => _error = 'Failed to load departments');
      }
    } catch (e) {
      if (mounted) setState(() => _error = 'Failed to load departments');
    }
  }

  Future<void> _createDoctor() async {
    if (_formKey.currentState!.validate()) {
      if (_departmentId == null) {
        setState(() => _error = 'Please select a department');
        return;
      }

      setState(() {
        _loading = true;
        _error = null;
        _success = null;
      });

      try {
        final response = await http.post(
          Uri.parse('${ApiConfig.baseUrl}/admin/users'),
          headers: ApiConfig.authHeaders,
          body: jsonEncode({
            'email': _emailController.text.trim(),
            'password': _passwordController.text,
            'name': _nameController.text.trim(),
            'role': 'PROFESSOR',
            'departmentId': _departmentId,
          }),
        );

        final data = jsonDecode(response.body);

        if (response.statusCode == 201 && data['success'] == true) {
          setState(() {
            _success = 'Doctor account created successfully!';
            _loading = false;
            _formKey.currentState!.reset();
            _emailController.clear();
            _passwordController.clear();
            _nameController.clear();
            _departmentId = null;
          });
        } else {
          setState(() {
            _error = data['error']?.toString() ?? 'Failed to create account';
            _loading = false;
          });
        }
      } catch (e) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Create Doctor Account', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF002147))),
              const SizedBox(height: 4),
              Text('Create new doctor accounts with email and password.', style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
              const SizedBox(height: 16),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, size: 20),
                          ),
                          validator: (v) => v?.isEmpty ?? true ? 'Name is required' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email, size: 20),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Email is required';
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v!)) return 'Invalid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            border: const OutlineInputBorder(),
                            prefixIcon: const Icon(Icons.lock, size: 20),
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, size: 20),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                          obscureText: _obscurePassword,
                          validator: (v) {
                            if (v?.isEmpty ?? true) return 'Password is required';
                            if (v!.length < 6) return 'Minimum 6 characters';
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          value: _departmentId,
                          decoration: const InputDecoration(
                            labelText: 'Department',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.business, size: 20),
                          ),
                          isExpanded: true,
                          items: _departments
                              .map((dept) => DropdownMenuItem(
                                    value: dept['id'] as String,
                                    child: Text('${dept['code']} - ${dept['name']}', overflow: TextOverflow.ellipsis),
                                  ))
                              .toList(),
                          onChanged: (v) => setState(() => _departmentId = v),
                          validator: (v) => v == null ? 'Please select a department' : null,
                        ),
                        const SizedBox(height: 16),
                        if (_error != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline, color: Colors.red, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12))),
                                ],
                              ),
                            ),
                          ),
                        if (_success != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                              child: Row(
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(child: Text(_success!, style: const TextStyle(color: Colors.green, fontSize: 12))),
                                ],
                              ),
                            ),
                          ),
                        FilledButton.icon(
                          onPressed: _loading ? null : _createDoctor,
                          icon: _loading
                              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : const Icon(Icons.person_add),
                          label: Text(_loading ? 'Creating...' : 'Create Doctor Account'),
                          style: FilledButton.styleFrom(
                            backgroundColor: const Color(0xFF002147),
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

// ==================== DATA MODELS ====================
enum _ImportStatus { idle, previewing, previewed, importing, done, error }

class _PreviewData {
  final int totalEntries;
  final List<String> programs;
  final List<Map<String, dynamic>> schedules;

  const _PreviewData({required this.totalEntries, required this.programs, required this.schedules});

  factory _PreviewData.fromJson(Map<String, dynamic> j) => _PreviewData(
        totalEntries: j['totalEntries'] as int,
        programs: List<String>.from(j['programs'] as List),
        schedules: List<Map<String, dynamic>>.from(j['schedules'] as List),
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
        scrapedEntries: j['scrapedEntries'] as int,
        schedulesInserted: j['schedulesInserted'] as int,
        schedulesSkipped: j['schedulesSkipped'] as int,
        errors: List<dynamic>.from(j['errors'] as List),
        programs: List<String>.from((j['programs'] as List?) ?? []),
        dryRun: j['dryRun'] as bool,
        durationMs: j['durationMs'] as int?,
        enrollmentsLinked: j['enrollmentsLinked'] as int?,
      );
}

class _DoctorProfilePage extends StatefulWidget {
  final Map<String, dynamic> doctor;

  const _DoctorProfilePage({required this.doctor});

  @override
  State<_DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<_DoctorProfilePage> {
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _loading = false;
  String? _error;
  String? _success;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    if (_newPasswordController.text.length < 6) {
      setState(() => _error = 'Password must be at least 6 characters');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
      _success = null;
    });
    try {
      final response = await http.put(
        Uri.parse('${ApiConfig.baseUrl}/admin/users/${widget.doctor['id']}/password'),
        headers: {...ApiConfig.authHeaders, 'Content-Type': 'application/json'},
        body: jsonEncode({'password': _newPasswordController.text}),
      );
      if (response.statusCode == 200) {
        setState(() {
          _success = 'Password updated successfully';
          _newPasswordController.clear();
          _confirmPasswordController.clear();
        });
      } else {
        final data = jsonDecode(response.body);
        setState(() => _error = data['error'] ?? 'Failed to update password');
      }
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final name = doctor['name'] as String? ?? '';
    final email = doctor['email'] as String? ?? '';
    final department = doctor['department']?['name'] as String? ?? 'Not assigned';
    final assignedCourses = (doctor['assignedCourses'] as List?) ?? [];
    final courseCount = assignedCourses.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Profile'),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundColor: const Color(0xFF002147),
                          child: Text(
                            name.isNotEmpty ? name[0].toUpperCase() : 'D',
                            style: const TextStyle(color: Colors.white, fontSize: 24),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF002147)),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(),
                    const SizedBox(height: 12),
                    _infoRow(Icons.business, 'Department', department),
                    const SizedBox(height: 8),
                    _infoRow(Icons.book, 'Enrolled Courses', '$courseCount'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Change Password',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF002147)),
            ),
            const SizedBox(height: 12),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: const BorderSide(color: Color(0xFFE5E7EB))),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _newPasswordController,
                      obscureText: _obscureNewPassword,
                      decoration: InputDecoration(
                        labelText: 'New Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureNewPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureNewPassword = !_obscureNewPassword),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        prefixIcon: const Icon(Icons.lock_outline, size: 20),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12))),
                          ],
                        ),
                      ),
                    ],
                    if (_success != null) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.green[50], borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.green, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(_success!, style: const TextStyle(color: Colors.green, fontSize: 12))),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: _loading ? null : _changePassword,
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF002147),
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: _loading
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : const Text('Update Password'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text('$label: ', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
      ],
    );
  }
}