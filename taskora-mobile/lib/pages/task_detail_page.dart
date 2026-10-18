import 'package:flutter/material.dart';

import '../models/task.dart';
import '../widgets/task_badge.dart';
import 'task_form_page.dart';

class TaskDetailPage extends StatefulWidget {
  const TaskDetailPage({super.key});

  static const routeName = '/task-detail';

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  Task? _task;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _task ??= ModalRoute.of(context)!.settings.arguments! as Task;
  }

  void _advanceStatus() {
    final current = _task!;
    final next = switch (current.status) {
      'Bekliyor' => 'Devam Ediyor',
      'Devam Ediyor' => 'Tamamlandı',
      _ => 'Bekliyor',
    };
    Navigator.pop(context, current.copyWith(status: next));
  }

  Future<void> _editTask() async {
    final current = _task!;
    final updated = await Navigator.push<Task>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskFormPage(nextId: current.id, task: current),
      ),
    );
    if (updated == null || !mounted) return;
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    final task = _task!;
    return Scaffold(
      appBar: AppBar(title: const Text('Görev Detayı')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(18),
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  task.imagePath,
                  key: const ValueKey('task-detail-image'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        TaskBadge(
                          label: task.status,
                          background: const Color(0xFFE8F4FB),
                          foreground: const Color(0xFF2878A6),
                        ),
                        TaskBadge(
                          label: '${task.priority} öncelik',
                          background: const Color(0xFFFFF2EE),
                          foreground: const Color(0xFFB55B52),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      task.title,
                      style: const TextStyle(
                        color: Color(0xFF183047),
                        fontSize: 25,
                        height: 1.2,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      task.description,
                      style: const TextStyle(
                        color: Color(0xFF607383),
                        fontSize: 15,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Divider(),
                    _DetailRow(
                      icon: Icons.folder_outlined,
                      label: 'Proje',
                      value: task.projectName,
                    ),
                    _DetailRow(
                      icon: Icons.person_outline_rounded,
                      label: 'Sorumlu',
                      value: task.assignee,
                    ),
                    _DetailRow(
                      icon: Icons.event_outlined,
                      label: 'Son Tarih',
                      value: task.dueDate,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              key: const ValueKey('edit-task-button'),
              onPressed: _editTask,
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Görevi Düzenle'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            FilledButton.icon(
              key: const ValueKey('advance-status-button'),
              onPressed: _advanceStatus,
              icon: const Icon(Icons.update_rounded),
              label: Text(
                task.status == 'Tamamlandı'
                    ? 'Görevi Yeniden Aç'
                    : 'Durumu İlerlet',
              ),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Değişiklik bu cihazda yerel olarak saklanır.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF718391), fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(top: 5),
      leading: Icon(icon, size: 21, color: const Color(0xFF2468A0)),
      title: Text(
        label,
        style: const TextStyle(color: Color(0xFF718391), fontSize: 12),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 3),
        child: Text(
          value,
          style: const TextStyle(
            color: Color(0xFF183047),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
