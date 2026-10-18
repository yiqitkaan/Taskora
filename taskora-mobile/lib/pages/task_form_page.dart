import 'dart:math';

import 'package:flutter/material.dart';

import '../models/task.dart';

class TaskFormPage extends StatefulWidget {
  const TaskFormPage({required this.nextId, this.task, super.key});

  final int nextId;
  final Task? task;

  bool get isEditing => task != null;

  @override
  State<TaskFormPage> createState() => _TaskFormPageState();
}

class _TaskFormPageState extends State<TaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _projectController;
  late final TextEditingController _assigneeController;
  late final TextEditingController _dueDateController;
  late String _priority;
  late String _status;

  @override
  void initState() {
    super.initState();
    final task = widget.task;
    _titleController = TextEditingController(text: task?.title ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _projectController = TextEditingController(
      text: task?.projectName ?? 'Taskora',
    );
    _assigneeController = TextEditingController(
      text: task?.assignee ?? 'Yiğit Kaan Bilir',
    );
    _dueDateController = TextEditingController(text: task?.dueDate ?? '');
    _priority = task?.priority ?? 'Orta';
    _status = task?.status ?? 'Bekliyor';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _projectController.dispose();
    _assigneeController.dispose();
    _dueDateController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) return 'Bu alan zorunludur.';
    return null;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Task(
        id: widget.task?.id ?? widget.nextId,
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        projectName: _projectController.text.trim(),
        priority: _priority,
        status: _status,
        assignee: _assigneeController.text.trim(),
        dueDate: _dueDateController.text.trim(),
        imagePath:
            widget.task?.imagePath ??
            Task.imagePaths[Random().nextInt(Task.imagePaths.length)],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Görevi Düzenle' : 'Yeni Görev'),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              children: [
                TextFormField(
                  key: const ValueKey('task-title-field'),
                  controller: _titleController,
                  validator: _required,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Görev başlığı',
                    prefixIcon: Icon(Icons.task_alt_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const ValueKey('task-description-field'),
                  controller: _descriptionController,
                  validator: _required,
                  minLines: 3,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: 'Açıklama',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.notes_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const ValueKey('task-project-field'),
                  controller: _projectController,
                  validator: _required,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Proje',
                    prefixIcon: Icon(Icons.folder_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const ValueKey('task-assignee-field'),
                  controller: _assigneeController,
                  validator: _required,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Sorumlu',
                    prefixIcon: Icon(Icons.person_outline_rounded),
                  ),
                ),
                const SizedBox(height: 14),
                TextFormField(
                  key: const ValueKey('task-due-date-field'),
                  controller: _dueDateController,
                  validator: _required,
                  textInputAction: TextInputAction.done,
                  decoration: const InputDecoration(
                    labelText: 'Son tarih',
                    hintText: 'Örn. 28 Ekim 2026',
                    prefixIcon: Icon(Icons.event_outlined),
                  ),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const ValueKey('task-priority-field'),
                  initialValue: _priority,
                  decoration: const InputDecoration(
                    labelText: 'Öncelik',
                    prefixIcon: Icon(Icons.flag_outlined),
                  ),
                  items: ['Düşük', 'Orta', 'Yüksek']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _priority = value!),
                ),
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  key: const ValueKey('task-status-field'),
                  initialValue: _status,
                  decoration: const InputDecoration(
                    labelText: 'Durum',
                    prefixIcon: Icon(Icons.track_changes_rounded),
                  ),
                  items: ['Bekliyor', 'Devam Ediyor', 'Tamamlandı']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) => setState(() => _status = value!),
                ),
                const SizedBox(height: 22),
                FilledButton.icon(
                  key: const ValueKey('save-task-button'),
                  onPressed: _save,
                  icon: const Icon(Icons.save_outlined),
                  label: Text(
                    widget.isEditing ? 'Değişiklikleri Kaydet' : 'Görevi Ekle',
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
                  'Değişiklikler bu cihazda yerel olarak saklanır.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF718391), fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
