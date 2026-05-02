import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/task_model.dart';
import '../../providers/task_provider.dart';

class TaskEditor extends StatefulWidget {
  final TaskModel? task;

  const TaskEditor({super.key, this.task});

  @override
  State<TaskEditor> createState() => _TaskEditorState();
}

class _TaskEditorState extends State<TaskEditor> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final isEditing = widget.task != null;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 32,
        left: 32,
        right: 32,
        top: 32,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              isEditing ? 'Edit Task' : 'New Task',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
            ),
            const SizedBox(height: 32),
            _buildInputField(
              controller: _titleController,
              label: 'Title',
              icon: Icons.title_rounded,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Enter title';
                return null;
              },
            ),
            const SizedBox(height: 20),
            _buildInputField(
              controller: _descriptionController,
              label: 'Description (optional)',
              icon: Icons.description_outlined,
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final messenger = ScaffoldMessenger.of(context);
                  final navigator = Navigator.of(context);

                  String? error;
                  if (isEditing) {
                    widget.task!.title = _titleController.text.trim();
                    widget.task!.description = _descriptionController.text.trim();
                    error = await taskProvider.updateTask(widget.task!);
                  } else {
                    error = await taskProvider.addTask(
                      _titleController.text.trim(),
                      _descriptionController.text.trim(),
                    );
                  }

                  if (error != null) {
                    if (mounted) {
                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(error),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  } else {
                    if (mounted) navigator.pop();
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 20),
                elevation: 0,
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                isEditing ? 'Save Changes' : 'Create Task',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxLines,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(bottom: 0),
          child: Icon(icon, size: 22),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.3),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      ),
    );
  }
}
