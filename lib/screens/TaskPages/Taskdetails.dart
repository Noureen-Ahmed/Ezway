import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/task.dart';
import '../../core/theme_extensions.dart';

class TaskDetailsPage extends StatefulWidget {
  final Task task;
  const TaskDetailsPage({super.key, required this.task});

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  late TextEditingController titleController;
  late TextEditingController descController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  TaskPriority importance = TaskPriority.medium;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task.title);
    descController = TextEditingController(text: widget.task.description ?? '');
    selectedDate = widget.task.dueDate;
    selectedTime = widget.task.dueDate != null
        ? TimeOfDay.fromDateTime(widget.task.dueDate!)
        : null;
    importance = widget.task.priority;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Details"),
        backgroundColor: const Color(0xFF002147),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Task Name", style: _labelStyle(context)),
              const SizedBox(height: 6),
              _inputBox(context, titleController, hint: "Enter task name"),
              const SizedBox(height: 16),
              Text("Description", style: _labelStyle(context)),
              const SizedBox(height: 6),
              _descriptionBox(context, descController),
              const SizedBox(height: 16),
              Text("Deadline", style: _labelStyle(context)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _dateBox(
                      context,
                      title: selectedDate == null
                          ? "Pick a date"
                          : DateFormat('MMMM dd, yyyy').format(selectedDate!),
                      onTap: pickDate,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const SizedBox(height: 6),
                  Expanded(
                    child: _dateBox(
                      context,
                      title: selectedTime == null
                          ? "Pick time"
                          : selectedTime!.format(context),
                      onTap: pickTime,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),
              Text("Importance", style: _labelStyle(context)),
              const SizedBox(height: 8),
              Row(
                children: [
                  _priorityButton(context, TaskPriority.low, "Low", Colors.green),
                  const SizedBox(width: 10),
                  _priorityButton(context, TaskPriority.medium, "Medium", Colors.orange),
                  const SizedBox(width: 10),
                  _priorityButton(context, TaskPriority.high, "High", Colors.red),
                ],
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF002147),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Save Changes",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }

  void saveChanges() {
    if (titleController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields")),
      );
      return;
    }

    final dueDate = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    final updatedTask = widget.task.copyWith(
      title: titleController.text,
      description: descController.text,
      dueDate: dueDate,
      priority: importance,
    );

    Navigator.pop(context, updatedTask);
  }

  Future pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => selectedDate = date);
  }

  Future pickTime() async {
    TimeOfDay? time = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );
    if (time != null) setState(() => selectedTime = time);
  }

  Widget _priorityButton(BuildContext context, TaskPriority p, String text, Color color) {
    bool isSelected = importance == p;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => importance = p),
        child: Container(
          height: 40,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : context.borderCol,
            ),
            color: isSelected ? color.withValues(alpha: 0.15) : Colors.transparent,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isSelected ? color : context.navyOrWhite,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle _labelStyle(BuildContext context) => TextStyle(
  color: context.navyOrWhite,
  fontSize: 14,
  fontWeight: FontWeight.w600,
);

BoxDecoration _inputDecoration(BuildContext context) => BoxDecoration(
  borderRadius: const BorderRadius.all(Radius.circular(10)),
  border: Border.fromBorderSide(BorderSide(color: context.borderCol, width: 1.0)),
  color: context.inputFill,
);

Widget _inputBox(BuildContext context, TextEditingController controller, {required String hint}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: _inputDecoration(context),
    child: TextField(
      controller: controller,
      style: TextStyle(color: context.navyOrWhite),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: hint,
        hintStyle: TextStyle(color: context.mutedText),
      ),
    ),
  );
}

Widget _descriptionBox(BuildContext context, TextEditingController controller) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: _inputDecoration(context),
    child: TextField(
      controller: controller,
      maxLines: 5,
      style: TextStyle(color: context.navyOrWhite),
      decoration: InputDecoration(
        border: InputBorder.none,
        hintStyle: TextStyle(color: context.mutedText),
      ),
    ),
  );
}

Widget _dateBox(BuildContext context, {required String title, required VoidCallback onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: 50,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: _inputDecoration(context),
      child: Text(title, style: TextStyle(color: context.navyOrWhite)),
    ),
  );
}
