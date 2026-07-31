import 'package:flutter/material.dart';
import 'tree_widget.dart';
import '../l10n/app_localizations.dart';

class TreeCard extends StatelessWidget {
  final int completedTasks;

  const TreeCard({
    super.key,
    required this.completedTasks,
  });

  int getTreeLevel() {
    if (completedTasks >= 20) return 8;
    if (completedTasks >= 15) return 7;
    if (completedTasks >= 12) return 6;
    if (completedTasks >= 9) return 5;
    if (completedTasks >= 6) return 4;
    if (completedTasks >= 4) return 3;
    if (completedTasks >= 2) return 2;
    if (completedTasks >= 1) return 1;
    return 0;
  }

  String getTreeStatus(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final level = getTreeLevel();
    if (level == 0) return localizations.translate('tree_status_seed');
    if (level <= 2) return localizations.translate('tree_status_seedling');
    if (level <= 4) return localizations.translate('tree_status_small');
    if (level <= 6) return localizations.translate('tree_status_big');
    if (level <= 7) return localizations.translate('tree_status_flower');
    return localizations.translate('tree_status_max');
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final level = getTreeLevel();
    const maxLevel = 8;
    final progress = level / maxLevel;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.08),
            blurRadius: 12,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: Colors.green.shade50,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: TreeWidget(
              completedTasks: completedTasks,
              isMini: true,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      getTreeStatus(context),
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${localizations.translate('level')}${level + 1}/$maxLevel',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      level >= 7 ? Colors.orange : Colors.green,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${localizations.translate('completed_tasks')}$completedTasks',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (level < maxLevel)
                      Text(
                        '${localizations.translate('remaining')}${20 - completedTasks}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade500,
                        ),
                      )
                    else
                      Text(
                        localizations.translate('max'),
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
