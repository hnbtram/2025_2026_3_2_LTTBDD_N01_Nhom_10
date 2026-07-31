import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/task_service.dart';
import '../models/task.dart';
import '../l10n/app_localizations.dart';
import '../main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TaskService _taskService = TaskService();
  String _currentLanguage = 'vi';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lang = prefs.getString('language') ?? 'vi';
      setState(() {
        _currentLanguage = lang;
      });
    } catch (e) {
      print('Không thể đọc ngôn ngữ: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final completedTasks = _taskService.getCompletedTasks();
    final overdueTasks = _taskService.getOverdueTasks();
    final totalTasks = _taskService.allTasks.length;
    final allLabels = _taskService.getAllLabels();

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(localizations.translate('settings')),
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============ KHU VỰC 1: LỊCH SỬ ============
            _buildSection(
              title: localizations.translate('history'),
              children: [
                _buildMenuItem(
                  icon: Icons.check_circle_outline,
                  iconColor: Colors.green,
                  title: localizations.translate('completed'),
                  subtitle:
                      '${completedTasks.length} ${localizations.translate('tasks')}',
                  onTap: () => _showFilteredTasks(completed: true),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.warning_amber_outlined,
                  iconColor: Colors.red,
                  title: localizations.translate('overdue'),
                  subtitle:
                      '${overdueTasks.length} ${localizations.translate('tasks')}',
                  onTap: () => _showFilteredTasks(overdue: true),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.all_inbox,
                  iconColor: Colors.blue,
                  title: localizations.translate('all_tasks'),
                  subtitle: '$totalTasks ${localizations.translate('tasks')}',
                  onTap: () => _showFilteredTasks(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // ============ KHU VỰC 2: NHÃN DÁN ============
            _buildSection(
              title: localizations.translate('labels'),
              children: allLabels.isEmpty
                  ? [
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Center(
                          child: Text(
                            'Chưa có nhãn dán nào',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ]
                  : allLabels.map((label) {
                      final tasksWithLabel =
                          _taskService.getTasksByLabel(label);
                      return Column(
                        children: [
                          _buildMenuItem(
                            icon: Icons.label_outline,
                            iconColor: _getLabelColor(label),
                            title: label,
                            subtitle:
                                '${tasksWithLabel.length} ${localizations.translate('tasks')}',
                            onTap: () => _showFilteredTasks(
                              labels: [label],
                            ),
                          ),
                          if (label != allLabels.last) _buildDivider(),
                        ],
                      );
                    }).toList(),
            ),

            const SizedBox(height: 16),

            // ============ KHU VỰC 3: CHUNG ============
            _buildSection(
              title: localizations.translate('general'),
              children: [
                _buildMenuItem(
                  icon: Icons.language,
                  iconColor: Colors.blue,
                  title: localizations.translate('language'),
                  subtitle: localizations.translate('language_subtitle'),
                  onTap: () => _showLanguageDialog(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentLanguage == 'vi' ? '🇻🇳' : '🇬🇧',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        color: Colors.grey,
                        size: 20,
                      ),
                    ],
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.palette_outlined,
                  iconColor: Colors.purple,
                  title: localizations.translate('theme'),
                  subtitle: localizations.translate('theme_subtitle'),
                  onTap: () => _showThemeDialog(),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.notifications_outlined,
                  iconColor: Colors.orange,
                  title: localizations.translate('notifications_setting'),
                  subtitle: localizations.translate('notifications_subtitle'),
                  onTap: () => _showNotificationDialog(),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                    size: 20,
                  ),
                ),
                _buildDivider(),
                _buildMenuItem(
                  icon: Icons.info_outline,
                  iconColor: Colors.blue,
                  title: localizations.translate('version'),
                  subtitle: 'v1.0.0',
                  onTap: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ),
            trailing ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 1,
      color: Colors.grey.shade100,
    );
  }

  Color _getLabelColor(String label) {
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.orange,
      Colors.purple,
      Colors.pink,
      Colors.teal,
      Colors.indigo,
    ];
    final index = label.length % colors.length;
    return colors[index];
  }

  void _showFilteredTasks({
    bool? completed,
    bool? overdue,
    List<String>? labels,
  }) {
    final localizations = AppLocalizations.of(context)!;
    final filtered = _taskService.filterTasks(
      completed: completed,
      labels: labels?.isNotEmpty == true ? labels : null,
    );

    String title = localizations.translate('filter_result');
    if (completed == true) title = localizations.translate('completed');
    if (overdue == true) title = localizations.translate('overdue');
    if (labels != null && labels.isNotEmpty) title = '🏷️ ${labels.join(", ")}';

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      localizations.translate('close'),
                      style: const TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.inbox_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            localizations.translate('no_tasks'),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final task = filtered[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              task.isCompleted
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color:
                                  task.isCompleted ? Colors.green : Colors.grey,
                              size: 20,
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isCompleted
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                            subtitle: task.dueDate != null
                                ? Text(
                                    '📅 ${DateFormat('dd/MM/yyyy').format(task.dueDate!)}')
                                : null,
                            trailing: task.labels.isNotEmpty
                                ? Chip(
                                    label: Text(
                                      task.labels.first,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    backgroundColor: Colors.green.shade100,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.language, color: Colors.blue),
            const SizedBox(width: 8),
            Text(AppLocalizations.of(context)!.translate('language')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('vi', '🇻🇳', 'Tiếng Việt'),
            const Divider(),
            _buildLanguageOption('en', '🇬🇧', 'English'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.translate('close')),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(String code, String flag, String name) {
    final isSelected = _currentLanguage == code;
    return ListTile(
      leading: Text(flag, style: const TextStyle(fontSize: 24)),
      title: Text(name),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: Colors.green)
          : null,
      onTap: () async {
        try {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('language', code);
          setState(() {
            _currentLanguage = code;
          });
          Navigator.pop(context);

          MyApp.setLocale(context, Locale(code));

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  code == 'vi'
                      ? 'Đã đổi ngôn ngữ sang Tiếng Việt'
                      : 'Language changed to English',
                ),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          print('Lỗi đổi ngôn ngữ: $e');
        }
      },
    );
  }

  void _showThemeDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.palette, color: Colors.purple),
            const SizedBox(width: 8),
            Text(localizations.translate('select_theme')),
          ],
        ),
        content: Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _buildThemeOption(Colors.green, 'Xanh lá', true),
            _buildThemeOption(Colors.blue, 'Xanh dương', false),
            _buildThemeOption(Colors.orange, 'Cam', false),
            _buildThemeOption(Colors.purple, 'Tím', false),
            _buildThemeOption(Colors.pink, 'Hồng', false),
            _buildThemeOption(Colors.red, 'Đỏ', false),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(Color color, String name, bool isSelected) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã chọn chủ đề $name'),
            backgroundColor: color,
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: Colors.green.shade700, width: 3)
                  : null,
            ),
            child: isSelected
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : null,
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  void _showNotificationDialog() {
    final localizations = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            const Icon(Icons.notifications, color: Colors.orange),
            const SizedBox(width: 8),
            Text(localizations.translate('notifications_setting')),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: Text(localizations.translate('general_notifications')),
              value: true,
              onChanged: (value) {},
              activeThumbColor: Colors.green,
            ),
            SwitchListTile(
              title: Text(localizations.translate('task_reminders')),
              value: true,
              onChanged: (value) {},
              activeThumbColor: Colors.green,
            ),
            SwitchListTile(
              title: Text(localizations.translate('overdue_notifications')),
              value: false,
              onChanged: (value) {},
              activeThumbColor: Colors.red,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.translate('close')),
          ),
        ],
      ),
    );
  }
}
