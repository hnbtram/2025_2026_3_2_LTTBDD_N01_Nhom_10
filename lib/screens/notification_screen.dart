import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import '../l10n/app_localizations.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TaskService _taskService = TaskService();
  late List<Task> _overdueTasks;
  late List<Task> _todayTasks;
  late List<Task> _upcomingTasks;
  late List<Task> _completedTasks;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _overdueTasks = _taskService.getOverdueTasks();
      _todayTasks = _taskService.getTodayTasks();
      _upcomingTasks = _taskService.getUpcomingTasks().take(5).toList();
      _completedTasks = _taskService.getCompletedTasks().take(5).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text('🔔 ${localizations.translate('notifications')}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildNotificationSection(
              title: localizations.translate('overdue'),
              icon: Icons.warning,
              color: Colors.red,
              tasks: _overdueTasks,
            ),
            const SizedBox(height: 16),
            _buildNotificationSection(
              title: localizations.translate('today_label'),
              icon: Icons.today,
              color: Colors.blue,
              tasks: _todayTasks,
            ),
            const SizedBox(height: 16),
            _buildNotificationSection(
              title: localizations.translate('upcoming_deadline'),
              icon: Icons.event_available,
              color: Colors.orange,
              tasks: _upcomingTasks,
              showLimit: true,
            ),
            const SizedBox(height: 16),
            _buildNotificationSection(
              title: localizations.translate('completed'),
              icon: Icons.check_circle,
              color: Colors.green,
              tasks: _completedTasks,
              showLimit: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSection({
    required String title,
    required IconData icon,
    required Color color,
    required List<Task> tasks,
    bool showLimit = false,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final displayTasks = showLimit ? tasks.take(5).toList() : tasks;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const Spacer(),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    tasks.length.toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (displayTasks.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: Text(
                    localizations.translate('no_notifications'),
                    style: TextStyle(color: Colors.grey.shade500),
                  ),
                ),
              )
            else
              ...displayTasks
                  .map((task) => _buildNotificationItem(task, color)),
            if (showLimit && tasks.length > 5)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Center(
                  child: Text(
                    localizations.translateWithParams(
                        'and_more', {'count': (tasks.length - 5).toString()}),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Task task, Color color) {
    String timeInfo = '';
    if (task.dueDate != null) {
      timeInfo = DateFormat(
        'dd/MM/yyyy',
      ).format(task.dueDate!);
      if (task.dueTime != null) {
        timeInfo +=
            ' ${task.dueTime!.hour.toString().padLeft(2, '0')}:${task.dueTime!.minute.toString().padLeft(2, '0')}';
      }
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            task.isCompleted ? Icons.check_circle : Icons.circle_outlined,
            color: task.isCompleted ? Colors.green : color,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (timeInfo.isNotEmpty)
                  Text(
                    '📅 $timeInfo',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                if (task.labels.isNotEmpty)
                  Wrap(
                    spacing: 4,
                    children: task.labels.map((label) {
                      return Chip(
                        label: Text(
                          label,
                          style: const TextStyle(fontSize: 10),
                        ),
                        backgroundColor: Colors.grey.shade200,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.symmetric(horizontal: 6),
                      );
                    }).toList(),
                  ),
              ],
            ),
          ),
          if (task.isOverdue)
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.red,
              size: 20,
            ),
        ],
      ),
    );
  }
}
