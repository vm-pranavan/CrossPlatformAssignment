import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/task_provider.dart';
import 'task_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<TaskProvider>(context, listen: false).fetchTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final taskProvider = Provider.of<TaskProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light
          ? const Color(0xFFF8FAFC)
          : const Color(0xFF020617),
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: TextButton.icon(
              onPressed: () => authProvider.logout(),
              icon: Icon(Icons.logout_rounded, size: 18, color: Theme.of(context).colorScheme.error),
              label: Text(
                'Sign out',
                style: TextStyle(color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.w600),
              ),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error.withOpacity(0.1),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
      body: taskProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Your Tasks',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          Text(
                            '${taskProvider.tasks.length} tasks assigned to you',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showTaskEditor(context),
                        icon: const Icon(Icons.add_rounded, size: 20),
                        label: const Text('Add Task'),
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32, indent: 24, endIndent: 24),
                Expanded(
                  child: taskProvider.tasks.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.separated(
                          padding: const EdgeInsets.all(24),
                          itemCount: taskProvider.tasks.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final task = taskProvider.tasks[index];
                            return _buildTaskItem(context, task);
                          },
                        ),
                ),
              ],
            ),
    );
  }

  void _showTaskEditor(BuildContext context, [dynamic task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditor(task: task),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.assignment_turned_in_rounded,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'All caught up!',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Create a task to start tracking your progress.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(BuildContext context, dynamic task) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: task.isCompleted
              ? Colors.transparent
              : Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => taskProvider.toggleTaskStatus(task),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Transform.scale(
                scale: 1.2,
                child: Checkbox(
                  value: task.isCompleted,
                  onChanged: (_) => taskProvider.toggleTaskStatus(task),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
                            color: task.isCompleted
                                ? Theme.of(context).colorScheme.onSurfaceVariant
                                : Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                    if (task.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        task.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              _buildTaskActions(context, task),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTaskActions(BuildContext context, dynamic task) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined, size: 20),
          onPressed: () => _showTaskEditor(context, task),
          visualDensity: VisualDensity.compact,
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline_rounded, size: 20),
          onPressed: () => _confirmDelete(context, task),
          visualDensity: VisualDensity.compact,
          color: Theme.of(context).colorScheme.error.withOpacity(0.7),
        ),
      ],
    );
  }


  void _confirmDelete(BuildContext context, dynamic task) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Provider.of<TaskProvider>(context, listen: false).deleteTask(task);
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }
}
