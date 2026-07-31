import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_item.dart';
import '../widgets/tree_card.dart';
import '../l10n/app_localizations.dart';
import 'add_task_screen.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});

  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  final TaskService _taskService = TaskService();
  List<Task> _todayTasks = [];
  int _completedCount = 0;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks() {
    setState(() {
      _todayTasks = _taskService.getTodayTasks();
      _completedCount = _taskService.getCompletedTasks().length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final today = DateFormat('EEEE, dd/MM/yyyy').format(now);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(localizations.translate('today')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.green),
            onPressed: () {
              Navigator.pushNamed(context, '/notifications');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  today,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${_todayTasks.length} ${localizations.translate('today_tasks')}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          TreeCard(completedTasks: _completedCount),
          Container(
            height: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: _todayTasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.celebration_outlined,
                          size: 80,
                          color: Colors.green,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          localizations.translate('no_tasks_today'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.translate('add_task_hint'),
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(bottom: 80),
                    itemCount: _todayTasks.length,
                    itemBuilder: (context, index) {
                      final task = _todayTasks[index];
                      return TaskItem(
                        task: task,
                        onToggle: () {
                          _taskService.toggleTask(task.id);
                          _loadTasks();
                          _showSnackbar(
                            task.isCompleted
                                ? '✅ Hoàn thành: ${task.title} 🌱 Cây đang lớn!'
                                : '🔄 Đã bỏ đánh dấu',
                          );
                        },
                        onDelete: () {
                          _taskService.deleteTask(task.id);
                          _loadTasks();
                          _showSnackbar('🗑️ Đã xóa: ${task.title}');
                        },
                        onEdit: () {
                          _navigateToAddTask(task: task);
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddTask();
        },
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void _navigateToAddTask({Task? task}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddTaskScreen(existingTask: task),
    );
    if (result == true) {
      _loadTasks();
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
