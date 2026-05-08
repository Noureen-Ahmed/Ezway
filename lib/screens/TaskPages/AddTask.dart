import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../notification_service.dart';
import '../../core/theme_extensions.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  String importance = "Medium";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text("Add Task"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel("Task Name"),
              const SizedBox(height: 6),
              _buildInputBox(titleController, hint: "What needs to be done?"),
              const SizedBox(height: 16),
              _buildLabel("Description"),
              const SizedBox(height: 6),
              _buildLargeInputBox(descController, hint: "Add some details..."),
              const SizedBox(height: 16),
              _buildLabel("Deadline"),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _buildDateControl(
                      title: selectedDate == null
                          ? "Date"
                          : DateFormat('MMM dd, yyyy').format(selectedDate!),
                      icon: Icons.calendar_today,
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateControl(
                      title: selectedTime == null
                          ? "Time"
                          : selectedTime!.format(context),
                      icon: Icons.access_time,
                      onTap: _pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              _buildLabel("Priority"),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildPriorityButton("Low", Colors.green),
                  const SizedBox(width: 10),
                  _buildPriorityButton("Medium", Colors.orange),
                  const SizedBox(width: 10),
                  _buildPriorityButton("High", Colors.red),
                ],
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002147),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  onPressed: _saveTask,
                  child: const Text(
                    "Create Task",
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 80), // Added bottom padding
            ],
          ),
        ),
      ),
    );
  }

  void _saveTask() {
    if (titleController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a task name")),
      );
      return;
    }

    DateTime? dueDate;
    if (selectedDate != null && selectedTime != null) {
      dueDate = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );
    }

    final int notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    if (dueDate != null) {
      NotificationService.scheduleTaskNotifications(
        id: notificationId,
        title: titleController.text,
        dueDate: dueDate,
        body: descController.text.isNotEmpty 
            ? descController.text 
            : 'Your task is due!',
      );
    }

    Navigator.pop(context, {
      "title": titleController.text,
      "description": descController.text,
      "dueDate": dueDate,
      "priority": importance,
    });
  }

  Future<void> _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future<void> _pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        color: context.navyOrWhite,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildInputBox(TextEditingController controller, {required String hint}) {
    return TextField(
      controller: controller,
      style: TextStyle(color: context.navyOrWhite),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: context.inputFill,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.borderCol, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildLargeInputBox(TextEditingController controller, {required String hint}) {
    return TextField(
      controller: controller,
      maxLines: 4,
      style: TextStyle(color: context.navyOrWhite),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: context.inputFill,
        contentPadding: const EdgeInsets.all(16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: context.borderCol, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildDateControl({required String title, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: context.inputFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: context.navyOrWhite),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(color: context.navyOrWhite, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriorityButton(String text, Color color) {
    bool isSelected = importance == text;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => importance = text),
        child: Container(
          height: 44,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
            color: isSelected ? color.withValues(alpha: 0.1) : context.inputFill,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? color : const Color(0xFF6B7280),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
