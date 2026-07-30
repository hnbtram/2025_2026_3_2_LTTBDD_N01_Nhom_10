import '../models/task.dart';

class TaskService {
  static final TaskService _instance = TaskService._internal();
  factory TaskService() => _instance;
  TaskService._internal();

  final List<Task> _tasks = [];

  List<Task> get allTasks => _tasks;

  List<Task> getTodayTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.isCompleted) return false;
      if (task.dueDate == null) return false;
      return task.dueDate!.year == now.year &&
          task.dueDate!.month == now.month &&
          task.dueDate!.day == now.day;
    }).toList();
  }

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) {
      if (task.isCompleted) return false;
      if (task.dueDate == null) return false;
      return task.dueDate!.year == date.year &&
          task.dueDate!.month == date.month &&
          task.dueDate!.day == date.day;
    }).toList();
  }

  List<Task> getUpcomingTasks() {
    final now = DateTime.now();
    return _tasks.where((task) {
      if (task.isCompleted) return false;
      if (task.dueDate == null) return false;
      final taskDate = DateTime(
        task.dueDate!.year,
        task.dueDate!.month,
        task.dueDate!.day,
      );
      final today = DateTime(now.year, now.month, now.day);
      return taskDate.isAfter(today);
    }).toList()..sort((a, b) => a.dueDate!.compareTo(b.dueDate!));
  }

  List<Task> getOverdueTasks() {
    final now = DateTime.now();
    return _tasks.where((task) => task.isOverdue).toList();
  }

  List<Task> getCompletedTasks() {
    return _tasks.where((task) => task.isCompleted).toList();
  }

  List<Task> getTasksByLabel(String label) {
    return _tasks.where((task) => task.labels.contains(label)).toList();
  }

  List<String> getAllLabels() {
    final labels = <String>{};
    for (final task in _tasks) {
      labels.addAll(task.labels);
    }
    return labels.toList();
  }

  void addTask(Task task) {
    _tasks.add(task);
  }

  void toggleTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index != -1) {
      _tasks[index] = _tasks[index].copyWith(
        isCompleted: !_tasks[index].isCompleted,
      );
    }
  }

  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  void updateTask(Task task) {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
    }
  }

  List<Task> searchTasks(String query) {
    if (query.isEmpty) return _tasks;
    return _tasks
        .where(
          (task) =>
              task.title.toLowerCase().contains(query.toLowerCase()) ||
              (task.note?.toLowerCase().contains(query.toLowerCase()) ?? false),
        )
        .toList();
  }

  List<Task> filterTasks({
    bool? completed,
    List<String>? labels,
    DateTime? dueDate,
  }) {
    return _tasks.where((task) {
      if (completed != null && task.isCompleted != completed) return false;
      if (labels != null && labels.isNotEmpty) {
        if (!labels.any((l) => task.labels.contains(l))) return false;
      }
      if (dueDate != null && task.dueDate != null) {
        if (task.dueDate!.year != dueDate.year ||
            task.dueDate!.month != dueDate.month ||
            task.dueDate!.day != dueDate.day) {
          return false;
        }
      }
      return true;
    }).toList();
  }

  // Dữ liệu mẫu để test
  void addSampleData() {
    final now = DateTime.now();
    _tasks.addAll([
      Task(
        id: '1',
        title: 'Hoàn thành bài tập Flutter',
        dueDate: now,
        labels: ['Học tập'],
        note: 'Làm bài tập lớn cuối kỳ',
      ),
      Task(
        id: '2',
        title: 'Đi chợ mua đồ',
        dueDate: now.add(const Duration(days: 1)),
        dueTime: const TaskTime(hour: 18, minute: 0), // ✅ Đổi
        labels: ['Cá nhân'],
      ),
      Task(
        id: '3',
        title: 'Họp nhóm dự án',
        dueDate: now.add(const Duration(days: 2)),
        dueTime: const TaskTime(hour: 14, minute: 30), // ✅ Đổi
        labels: ['Công việc'],
        note: 'Phòng họp A201',
      ),
      Task(
        id: '4',
        title: 'Nộp báo cáo',
        dueDate: now.add(const Duration(days: 3)),
        labels: ['Học tập', 'Quan trọng'],
      ),
      Task(
        id: '5',
        title: 'Tập thể dục buổi sáng',
        dueDate: now,
        labels: ['Sức khỏe'],
      ),
    ]);
  }
}
