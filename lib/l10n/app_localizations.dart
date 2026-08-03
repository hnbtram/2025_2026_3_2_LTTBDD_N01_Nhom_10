import 'package:flutter/material.dart';

class AppLocalizations {
  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  final String languageCode;

  AppLocalizations(this.languageCode);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  // Tiếng Việt (mặc định)
  Map<String, String> get _vi => {
        'app_title': 'Todo Tree',
        'today': 'Hôm nay',
        'upcoming': 'Sắp tới',
        'settings': 'Cài đặt',
        'notifications': 'Thông báo',
        'add_task': 'Thêm nhiệm vụ',
        'edit_task': 'Sửa nhiệm vụ',
        'delete_task': 'Xóa nhiệm vụ',
        'complete_task': 'Hoàn thành',
        'today_tasks': 'nhiệm vụ hôm nay',
        'no_tasks_today': '🎉 Không có nhiệm vụ nào hôm nay!',
        'add_task_hint': 'Hãy thêm nhiệm vụ mới để cây phát triển 🌱',
        'tree_status_seed': '🌱 Hạt mầm',
        'tree_status_seedling': '🌿 Cây con',
        'tree_status_small': '🌳 Cây nhỏ',
        'tree_status_big': '🌳 Cây lớn',
        'tree_status_flower': '🌳 Cây có hoa',
        'tree_status_max': '🎉 Cây tối đa',
        'completed_tasks': '✅ Đã hoàn thành: ',
        'remaining': 'Còn ',
        'level': 'Cấp ',
        'max': '🎉 MAX',
        'title': 'Tên nhiệm vụ *',
        'note': 'Ghi chú',
        'enter_title': 'Nhập tên nhiệm vụ...',
        'enter_note': 'Nhập ghi chú (tùy chọn)...',
        'choose_due_date': 'Chọn ngày hết hạn (tùy chọn)',
        'choose_due_time': 'Chọn giờ hết hạn (tùy chọn)',
        'labels': '🏷️ Nhãn dán',
        'selected_labels': '✅ Đã chọn: ',
        'save': 'THÊM NHIỆM VỤ',
        'update': 'CẬP NHẬT',
        'new_task': '✨ Tạo nhiệm vụ mới',
        'edit_task_title': '✏️ Sửa nhiệm vụ',
        'title_required': 'Vui lòng nhập tên nhiệm vụ',
        'overdue': '⛔ Quá hạn',
        'today_label': '📅 Hôm nay',
        'upcoming_deadline': '⏳ Sắp đến hạn',
        'completed': '✅ Đã hoàn thành',
        'no_notifications': '✨ Không có thông báo nào',
        'and_more': 'và {count} nhiệm vụ khác...',
        'history': 'Lịch sử',
        'all_tasks': 'Tất cả nhiệm vụ',
        'general': 'Chung',
        'theme': 'Giao diện',
        'theme_subtitle': 'Chọn chủ đề màu sắc',
        'notifications_setting': 'Thông báo',
        'notifications_subtitle': 'Bật/tắt thông báo',
        'version': 'Phiên bản',
        'language': 'Ngôn ngữ',
        'language_subtitle': 'Chọn ngôn ngữ hiển thị',
        'close': 'Đóng',
        'filter_result': '📋 Kết quả lọc',
        'no_tasks': 'Không có nhiệm vụ nào',
        'select_theme': 'Chọn chủ đề',
        'general_notifications': 'Thông báo chung',
        'task_reminders': 'Nhắc nhở nhiệm vụ',
        'overdue_notifications': 'Thông báo quá hạn',
        'vietnamese': 'Tiếng Việt',
        'english': 'English',
        'language_changed': 'Đã đổi ngôn ngữ sang ',
        'tasks': 'nhiệm vụ',
        'calendar': '📆 Lịch',
        'week': 'Tuần',
        'month': 'Tháng',
        'day': 'Ngày',
        'no_tasks_for_day': 'Không có nhiệm vụ nào',
        'add_new_task': 'Bấm + để thêm nhiệm vụ mới',
      };

  Map<String, String> get _en => {
        'app_title': 'Todo Tree',
        'today': 'Today',
        'upcoming': 'Upcoming',
        'settings': 'Settings',
        'notifications': 'Notifications',
        'add_task': 'Add Task',
        'edit_task': 'Edit Task',
        'delete_task': 'Delete Task',
        'complete_task': 'Complete',
        'today_tasks': 'tasks today',
        'no_tasks_today': '🎉 No tasks today!',
        'add_task_hint': 'Add a new task to grow your tree 🌱',
        'tree_status_seed': '🌱 Seed',
        'tree_status_seedling': '🌿 Seedling',
        'tree_status_small': '🌳 Small Tree',
        'tree_status_big': '🌳 Big Tree',
        'tree_status_flower': '🌳 Flowering Tree',
        'tree_status_max': '🎉 Max Level',
        'completed_tasks': '✅ Completed: ',
        'remaining': 'Remaining ',
        'level': 'Level ',
        'max': '🎉 MAX',
        'title': 'Task Title *',
        'note': 'Note',
        'enter_title': 'Enter task title...',
        'enter_note': 'Enter note (optional)...',
        'choose_due_date': 'Choose due date (optional)',
        'choose_due_time': 'Choose due time (optional)',
        'labels': '🏷️ Labels',
        'selected_labels': '✅ Selected: ',
        'save': 'ADD TASK',
        'update': 'UPDATE',
        'new_task': '✨ Create New Task',
        'edit_task_title': '✏️ Edit Task',
        'title_required': 'Please enter task title',
        'overdue': '⛔ Overdue',
        'today_label': '📅 Today',
        'upcoming_deadline': '⏳ Upcoming Deadline',
        'completed': '✅ Completed',
        'no_notifications': '✨ No notifications',
        'and_more': 'and {count} more tasks...',
        'history': 'History',
        'all_tasks': 'All Tasks',
        'general': 'General',
        'theme': 'Theme',
        'theme_subtitle': 'Choose color theme',
        'notifications_setting': 'Notifications',
        'notifications_subtitle': 'Turn on/off notifications',
        'version': 'Version',
        'language': 'Language',
        'language_subtitle': 'Choose display language',
        'close': 'Close',
        'filter_result': '📋 Filter Results',
        'no_tasks': 'No tasks',
        'select_theme': 'Select Theme',
        'general_notifications': 'General Notifications',
        'task_reminders': 'Task Reminders',
        'overdue_notifications': 'Overdue Notifications',
        'vietnamese': 'Tiếng Việt',
        'english': 'English',
        'language_changed': 'Language changed to ',
        'tasks': 'tasks',
        'calendar': '📆 Calendar',
        'week': 'Week',
        'month': 'Month',
        'day': 'Day',
        'no_tasks_for_day': 'No tasks',
        'add_new_task': 'Tap + to add a new task',
      };

  Map<String, String> get _strings => languageCode == 'en' ? _en : _vi;

  String translate(String key) {
    return _strings[key] ?? key;
  }

  String translateWithParams(String key, Map<String, String> params) {
    String text = _strings[key] ?? key;
    params.forEach((key, value) {
      text = text.replaceAll('{$key}', value);
    });
    return text;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'vi'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale.languageCode);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
