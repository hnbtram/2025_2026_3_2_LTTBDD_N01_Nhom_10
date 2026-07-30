class Task {
  final String id;
  final String title;
  bool isCompleted;
  final DateTime createdAt;
  DateTime? dueDate;
  TaskTime? dueTime;
  List<String> labels;
  String? note;

  Task({
    required this.id,
    required this.title,
    this.isCompleted = false,
    DateTime? createdAt,
    this.dueDate,
    this.dueTime,
    this.labels = const [],
    this.note,
  }) : createdAt = createdAt ?? DateTime.now();

  Task copyWith({
    String? id,
    String? title,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? dueDate,
    TaskTime? dueTime,
    List<String>? labels,
    String? note,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      dueTime: dueTime ?? this.dueTime,
      labels: labels ?? this.labels,
      note: note ?? this.note,
    );
  }

  bool get isOverdue {
    if (dueDate == null) return false;
    final now = DateTime.now();
    final dueDateTime = DateTime(
      dueDate!.year,
      dueDate!.month,
      dueDate!.day,
      dueTime?.hour ?? 23,
      dueTime?.minute ?? 59,
    );
    return !isCompleted && dueDateTime.isBefore(now);
  }

  bool get isDueToday {
    if (dueDate == null) return false;
    final now = DateTime.now();
    return dueDate!.year == now.year &&
        dueDate!.month == now.month &&
        dueDate!.day == now.day;
  }

  bool isDueOnDate(DateTime date) {
    if (dueDate == null) return false;
    return dueDate!.year == date.year &&
        dueDate!.month == date.month &&
        dueDate!.day == date.day;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'isCompleted': isCompleted,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'dueTime': dueTime != null ? '${dueTime!.hour}:${dueTime!.minute}' : null,
    'labels': labels,
    'note': note,
  };

  factory Task.fromJson(Map<String, dynamic> json) {
    TaskTime? time;
    if (json['dueTime'] != null) {
      final parts = (json['dueTime'] as String).split(':');
      time = TaskTime(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return Task(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      createdAt: DateTime.parse(json['createdAt']),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      dueTime: time,
      labels: List<String>.from(json['labels'] ?? []),
      note: json['note'],
    );
  }
}

class TaskTime {
  final int hour;
  final int minute;

  const TaskTime({required this.hour, required this.minute});
}
