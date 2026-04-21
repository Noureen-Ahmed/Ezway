import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/data_service.dart';

class AdminScheduleScreen extends ConsumerStatefulWidget {
  const AdminScheduleScreen({super.key});

  @override
  ConsumerState<AdminScheduleScreen> createState() => _AdminScheduleScreenState();
}

class _AdminScheduleScreenState extends ConsumerState<AdminScheduleScreen> {
  bool _isLoading = false;
  List<Map<String, dynamic>>? _extractedSchedule;
  String? _statusMessage;

  Future<void> _pickAndAnalyzePDF() async {
    setState(() {
      _isLoading = true;
      _statusMessage = 'Uploading and analyzing PDF...';
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        withData: true,
      );

      if (result != null && result.files.single.bytes != null) {
        final schedule = await DataService.analyzeSchedule(
          result.files.single.bytes!,
          result.files.single.name,
        );

        setState(() {
          _extractedSchedule = schedule;
          _isLoading = false;
          _statusMessage = schedule.isEmpty 
            ? 'No schedule items found. Please try another PDF.' 
            : 'AI Analysis complete. Please review the items below.';
        });
      } else {
        setState(() {
          _isLoading = false;
          _statusMessage = null;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error: ${e.toString()}';
      });
    }
  }

  Future<void> _saveSchedule() async {
    if (_extractedSchedule == null || _extractedSchedule!.isEmpty) return;

    setState(() {
      _isLoading = true;
      _statusMessage = 'Saving schedule to database...';
    });

    try {
      final success = await DataService.saveSchedule(_extractedSchedule!);
      
      setState(() {
        _isLoading = false;
        if (success) {
          _statusMessage = 'Schedule saved successfully!';
          _extractedSchedule = null;
        } else {
          _statusMessage = 'Failed to save schedule. Check server logs.';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _statusMessage = 'Error saving: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: const Text('Admin: Schedule Manager'),
        elevation: 0,
        backgroundColor: const Color(0xFF002147),
      ),
      body: Column(
        children: [
          _buildHeader(),
          if (_statusMessage != null) _buildStatusBanner(),
          Expanded(
            child: _extractedSchedule == null 
              ? _buildUploadPrompt() 
              : _buildReviewList(),
          ),
          if (_extractedSchedule != null && !_isLoading) _buildBottomActions(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Color(0xFF002147),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'University Schedule Analyzer',
            style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Upload a university schedule PDF to automatically extract and update course schedules.',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _statusMessage!.contains('Error') || _statusMessage!.contains('Failed')
            ? Colors.red.shade50
            : Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _statusMessage!.contains('Error') || _statusMessage!.contains('Failed')
              ? Colors.red.shade200
              : Colors.blue.shade200,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _statusMessage!.contains('Error') || _statusMessage!.contains('Failed')
                ? Icons.error_outline
                : Icons.info_outline,
            color: _statusMessage!.contains('Error') || _statusMessage!.contains('Failed')
                ? Colors.red.shade700
                : Colors.blue.shade700,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _statusMessage!,
              style: TextStyle(
                color: _statusMessage!.contains('Error') || _statusMessage!.contains('Failed')
                    ? Colors.red.shade900
                    : Colors.blue.shade900,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadPrompt() {
    return Center(
      child: _isLoading 
        ? const CircularProgressIndicator(color: Color(0xFF002147))
        : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: const Color(0xFF002147).withOpacity(0.05),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.picture_as_pdf, size: 60, color: Color(0xFF002147)),
              ),
              const SizedBox(height: 24),
              const Text(
                'No PDF Uploaded',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1F2937)),
              ),
              const SizedBox(height: 8),
              const Text(
                'Select a schedule PDF to begin analysis',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _pickAndAnalyzePDF,
                icon: const Icon(Icons.upload_file),
                label: const Text('Pick Schedule PDF'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF002147),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
    );
  }

  Widget _buildReviewList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _extractedSchedule!.length,
      itemBuilder: (context, index) {
        final item = _extractedSchedule![index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['course_code'] ?? 'Unknown Code',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF002147)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFDC800).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['type'] ?? 'Lecture',
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF002147)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                TextFormField(
                  initialValue: item['course_name'],
                  decoration: const InputDecoration(labelText: 'Course Name'),
                  onChanged: (val) => item['course_name'] = val,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: item['day'],
                        decoration: const InputDecoration(labelText: 'Day'),
                        onChanged: (val) => item['day'] = val,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: item['location'],
                        decoration: const InputDecoration(labelText: 'Location'),
                        onChanged: (val) => item['location'] = val,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: item['start_time'],
                        decoration: const InputDecoration(labelText: 'Start Time'),
                        onChanged: (val) => item['start_time'] = val,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextFormField(
                        initialValue: item['end_time'],
                        decoration: const InputDecoration(labelText: 'End Time'),
                        onChanged: (val) => item['end_time'] = val,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => setState(() => _extractedSchedule = null),
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Cancel'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _saveSchedule,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Save Schedule'),
            ),
          ),
        ],
      ),
    );
  }
}
