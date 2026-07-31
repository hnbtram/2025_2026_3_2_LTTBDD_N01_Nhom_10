import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/task_service.dart';
import '../widgets/task_item.dart';
import '../widgets/tree_card.dart';
import '../l10n/app_localizations.dart';
import 'add_task_screen.dart';

enum ViewMode { day, week, month }

class UpcomingScreen extends StatefulWidget {
  const UpcomingScreen({super.key});

  @override
  State<UpcomingScreen> createState() => _UpcomingScreenState();
}

class _UpcomingScreenState extends State<UpcomingScreen> {
  final TaskService _taskService = TaskService();
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  ViewMode _viewMode = ViewMode.month;
  List<Task> _tasksForSelectedDay = [];

  @override
  void initState() {
    super.initState();
    _loadTasksForDay(_selectedDay);
  }

  void _loadTasksForDay(DateTime day) {
    setState(() {
      _tasksForSelectedDay = _taskService.getTasksForDate(day);
    });
  }

  List<DateTime> _getDaysInWeek(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  List<DateTime> _getDaysInMonth(DateTime date) {
    final firstDay = DateTime(date.year, date.month, 1);
    final lastDay = DateTime(date.year, date.month + 1, 0);
    return List.generate(lastDay.day, (i) => firstDay.add(Duration(days: i)));
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final completedCount = _taskService.getCompletedTasks().length;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(localizations.translate('calendar')),
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
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month - 1,
                        1,
                      );
                      _selectedDay = _focusedDay;
                      _loadTasksForDay(_selectedDay);
                    });
                  },
                  child: const Icon(Icons.chevron_left, color: Colors.green),
                ),
                Text(
                  DateFormat('MMMM yyyy').format(_focusedDay),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _focusedDay = DateTime(
                        _focusedDay.year,
                        _focusedDay.month + 1,
                        1,
                      );
                      _selectedDay = _focusedDay;
                      _loadTasksForDay(_selectedDay);
                    });
                  },
                  child: const Icon(Icons.chevron_right, color: Colors.green),
                ),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildViewModeButton(
                    localizations.translate('week'), ViewMode.week),
                const SizedBox(width: 8),
                _buildViewModeButton(
                    localizations.translate('month'), ViewMode.month),
                const SizedBox(width: 8),
                _buildViewModeButton(
                    localizations.translate('day'), ViewMode.day),
              ],
            ),
          ),
          Container(
            height: 1,
            color: Colors.grey.shade200,
            margin: const EdgeInsets.symmetric(horizontal: 16),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: _viewMode == ViewMode.week
                        ? _buildWeekView()
                        : _viewMode == ViewMode.month
                            ? _buildMonthView()
                            : _buildDayView(),
                  ),
                  TreeCard(completedTasks: completedCount),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('EEEE, dd/MM/yyyy').format(_selectedDay),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        Text(
                          '${_tasksForSelectedDay.length} ${localizations.translate('tasks')}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_tasksForSelectedDay.isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.event_busy,
                              size: 60,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              localizations.translate('no_tasks_for_day'),
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              localizations.translate('add_new_task'),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    ..._tasksForSelectedDay.map((task) {
                      return TaskItem(
                        task: task,
                        onToggle: () {
                          _taskService.toggleTask(task.id);
                          _loadTasksForDay(_selectedDay);
                        },
                        onDelete: () {
                          _taskService.deleteTask(task.id);
                          _loadTasksForDay(_selectedDay);
                        },
                        onEdit: () {
                          _navigateToAddTask(task: task);
                        },
                      );
                    }),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddTask(),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildViewModeButton(String label, ViewMode mode) {
    final isSelected = _viewMode == mode;
    return GestureDetector(
      onTap: () {
        setState(() {
          _viewMode = mode;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? Colors.green : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade700,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildWeekView() {
    final days = _getDaysInWeek(_focusedDay);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          final isSelected = _selectedDay.year == day.year &&
              _selectedDay.month == day.month &&
              _selectedDay.day == day.day;
          final isToday = DateTime.now().year == day.year &&
              DateTime.now().month == day.month &&
              DateTime.now().day == day.day;
          final hasTasks = _taskService.getTasksForDate(day).isNotEmpty;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = day;
                _loadTasksForDay(day);
              });
            },
            child: Container(
              width: 40,
              padding: const EdgeInsets.symmetric(vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? Colors.green : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    DateFormat('E').format(day),
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday && !isSelected
                          ? Colors.green.shade100
                          : Colors.transparent,
                      border: isToday
                          ? Border.all(color: Colors.green, width: 2)
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        day.day.toString(),
                        style: TextStyle(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? Colors.white : Colors.black87,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  if (hasTasks)
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMonthView() {
    final days = _getDaysInMonth(_focusedDay);
    final firstDayOfMonth = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final startOffset = firstDayOfMonth.weekday - 1;

    final List<DateTime?> gridDays = [];
    for (int i = 0; i < startOffset; i++) {
      gridDays.add(null);
    }
    for (final day in days) {
      gridDays.add(day);
    }
    while (gridDays.length % 7 != 0) {
      gridDays.add(null);
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: ['T2', 'T3', 'T4', 'T5', 'T6', 'T7', 'CN'].map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 4),
          ...List.generate(gridDays.length ~/ 7, (row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (col) {
                final index = row * 7 + col;
                if (index >= gridDays.length) return const SizedBox.shrink();
                final day = gridDays[index];
                if (day == null) {
                  return const Expanded(child: SizedBox.shrink());
                }

                final isSelected = _selectedDay.year == day.year &&
                    _selectedDay.month == day.month &&
                    _selectedDay.day == day.day;
                final isToday = DateTime.now().year == day.year &&
                    DateTime.now().month == day.month &&
                    DateTime.now().day == day.day;
                final hasTasks = _taskService.getTasksForDate(day).isNotEmpty;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDay = day;
                        _loadTasksForDay(day);
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.green
                                  : isToday
                                      ? Colors.green.shade100
                                      : Colors.transparent,
                              border: isToday && !isSelected
                                  ? Border.all(color: Colors.green, width: 2)
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                day.day.toString(),
                                style: TextStyle(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : day.month == _focusedDay.month
                                          ? Colors.black87
                                          : Colors.grey.shade400,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          if (hasTasks)
                            Container(
                              margin: const EdgeInsets.only(top: 2),
                              width: 4,
                              height: 4,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.green,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildDayView() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios, size: 16),
                onPressed: () {
                  setState(() {
                    _selectedDay =
                        _selectedDay.subtract(const Duration(days: 1));
                    _loadTasksForDay(_selectedDay);
                  });
                },
              ),
              Text(
                DateFormat('EEEE, dd/MM/yyyy').format(_selectedDay),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward_ios, size: 16),
                onPressed: () {
                  setState(() {
                    _selectedDay = _selectedDay.add(const Duration(days: 1));
                    _loadTasksForDay(_selectedDay);
                  });
                },
              ),
            ],
          ),
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 24,
              itemBuilder: (context, index) {
                final hour = index;
                final timeStr = '${hour.toString().padLeft(2, '0')}:00';
                final isNow = DateTime.now().hour == hour &&
                    _selectedDay.year == DateTime.now().year &&
                    _selectedDay.month == DateTime.now().month &&
                    _selectedDay.day == DateTime.now().day;

                return Container(
                  width: 60,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Column(
                    children: [
                      Text(
                        timeStr,
                        style: TextStyle(
                          fontSize: 10,
                          color: isNow ? Colors.green : Colors.grey.shade600,
                          fontWeight:
                              isNow ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 80,
                        width: 2,
                        color: isNow ? Colors.green : Colors.grey.shade200,
                      ),
                      if (isNow)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'NOW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAddTask({Task? task}) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => AddTaskScreen(existingTask: task),
    );
    if (result == true) {
      _loadTasksForDay(_selectedDay);
      setState(() {});
    }
  }
}
