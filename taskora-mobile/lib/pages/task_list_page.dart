import 'package:flutter/material.dart';

import '../data/task_data.dart';
import '../models/app_user.dart';
import '../models/task.dart';
import '../widgets/task_badge.dart';
import 'task_detail_page.dart';
import 'task_form_page.dart';

class TaskListPage extends StatefulWidget {
  const TaskListPage({
    super.key,
    this.initialTasks,
    this.currentUser,
    this.onLogout,
  });

  final List<Task>? initialTasks;
  final AppUser? currentUser;
  final VoidCallback? onLogout;

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  List<Task> _tasks = const [];
  String _search = '';
  String _status = 'Tümü';
  bool _showGrid = true;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.initialTasks case final tasks?) {
      _tasks = List.of(tasks);
      _loading = false;
    } else {
      _loadTasks();
    }
  }

  Future<void> _loadTasks() async {
    try {
      final tasks = await TaskData.loadTasks();
      if (!mounted) return;
      setState(() {
        _tasks = tasks;
        _error = null;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _error = 'Görev verileri yüklenemedi.';
        _loading = false;
      });
    }
  }

  List<Task> get _visibleTasks {
    final query = _search.trim().toLowerCase();
    return _tasks.where((task) {
      final matchesStatus = _status == 'Tümü' || task.status == _status;
      final haystack = '${task.title} ${task.description}'.toLowerCase();
      return matchesStatus && (query.isEmpty || haystack.contains(query));
    }).toList();
  }

  Future<void> _openTask(Task task) async {
    final updated = await Navigator.pushNamed(
      context,
      TaskDetailPage.routeName,
      arguments: task,
    );
    if (updated is! Task || !mounted) return;
    setState(() {
      _tasks = _tasks
          .map((item) => item.id == updated.id ? updated : item)
          .toList();
    });
    await _saveTasks();
  }

  Future<void> _createTask() async {
    final nextId =
        _tasks.fold(0, (maxId, task) => task.id > maxId ? task.id : maxId) + 1;
    final created = await Navigator.push<Task>(
      context,
      MaterialPageRoute(builder: (_) => TaskFormPage(nextId: nextId)),
    );
    if (created == null || !mounted) return;
    setState(() {
      _tasks = [..._tasks, created];
      _search = '';
      _status = 'Tümü';
    });
    await _saveTasks();
  }

  Future<void> _saveTasks() async {
    try {
      await TaskData.saveTasks(_tasks);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Görev değişikliği kaydedilemedi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleTasks = _visibleTasks;
    final showsMessage = _loading || _error != null || visibleTasks.isEmpty;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 20,
        title: const Row(
          children: [
            _TaskoraMark(),
            SizedBox(width: 10),
            Text(
              'TASKORA',
              style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: -.4),
            ),
          ],
        ),
        actions: [
          if (widget.onLogout != null)
            IconButton(
              key: const ValueKey('logout-button'),
              onPressed: widget.onLogout,
              tooltip: '${widget.currentUser?.name ?? 'Kullanıcı'} · Çıkış yap',
              icon: const Icon(Icons.logout_rounded),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadTasks,
          child: _showGrid
              ? _buildGridView(visibleTasks, showsMessage)
              : _buildListView(visibleTasks, showsMessage),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        key: const ValueKey('add-task-button'),
        onPressed: _loading ? null : _createTask,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Yeni Görev'),
      ),
    );
  }

  Widget _buildListView(List<Task> visibleTasks, bool showsMessage) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 28),
      itemCount: 1 + (showsMessage ? 1 : visibleTasks.length),
      itemBuilder: (context, index) {
        if (index == 0) return _buildHeader();
        if (_loading) {
          return const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (_error != null) return _buildMessage(_error!);
        if (visibleTasks.isEmpty) {
          return _buildMessage('Eşleşen görev bulunamadı.');
        }

        final task = visibleTasks[index - 1];
        return Padding(
          padding: EdgeInsets.fromLTRB(
            16,
            0,
            16,
            index == visibleTasks.length ? 0 : 12,
          ),
          child: _TaskCard(task: task, onTap: () => _openTask(task)),
        );
      },
    );
  }

  Widget _buildGridView(List<Task> visibleTasks, bool showsMessage) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 28),
      children: [
        _buildHeader(),
        if (_loading)
          const SizedBox(
            height: 220,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (_error != null)
          _buildMessage(_error!)
        else if (showsMessage)
          _buildMessage('Eşleşen görev bulunamadı.')
        else
          LayoutBuilder(
            builder: (context, constraints) {
              final columnCount = constraints.maxWidth >= 760 ? 3 : 2;
              return GridView.builder(
                key: const ValueKey('task-grid'),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                itemCount: visibleTasks.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columnCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: columnCount == 2 ? .68 : .82,
                ),
                itemBuilder: (context, index) {
                  final task = visibleTasks[index];
                  return _TaskGridCard(
                    task: task,
                    onTap: () => _openTask(task),
                  );
                },
              );
            },
          ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Image.asset(
                  'assets/images/taskora_banner.png',
                  height: 148,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                const Padding(
                  padding: EdgeInsets.all(22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GÖREVLERİM',
                        style: TextStyle(
                          color: Color(0xFFBDE2F8),
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.7,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Planla, takip et\nve tamamla.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          height: 1.18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          TextField(
            onChanged: (value) => setState(() => _search = value),
            decoration: const InputDecoration(
              hintText: 'Görevlerde ara...',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['Tümü', 'Bekliyor', 'Devam Ediyor', 'Tamamlandı']
                  .map(
                    (status) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(status),
                        selected: _status == status,
                        onSelected: (_) => setState(() => _status = status),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Text(
                  'Görev Listesi',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${_visibleTasks.length} görev',
                style: const TextStyle(
                  color: Color(0xFF6C7D8D),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(
                  value: true,
                  icon: Icon(Icons.grid_view_rounded),
                  label: Text('Kartlar'),
                ),
                ButtonSegment(
                  value: false,
                  icon: Icon(Icons.view_list_rounded),
                  label: Text('Liste'),
                ),
              ],
              selected: {_showGrid},
              onSelectionChanged: (selection) {
                setState(() => _showGrid = selection.first);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessage(String message) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Text(message, textAlign: TextAlign.center),
    ),
  );
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({required this.task, required this.onTap});

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColors = _statusColors(task.status);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(17),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  TaskBadge(
                    label: task.status,
                    background: statusColors.$1,
                    foreground: statusColors.$2,
                  ),
                  TaskBadge(
                    label: '${task.priority} öncelik',
                    background: const Color(0xFFFFF2EE),
                    foreground: const Color(0xFFB55B52),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Text(
                task.title,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF6C7D8D), height: 1.4),
              ),
              const SizedBox(height: 15),
              const Divider(height: 1),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.folder_outlined,
                    size: 17,
                    color: Color(0xFF2468A0),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      task.projectName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: Color(0xFF8A9BA8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskGridCard extends StatelessWidget {
  const _TaskGridCard({required this.task, required this.onTap});

  final Task task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final statusColors = _statusColors(task.status);
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: TaskBadge(
                  label: task.status,
                  background: statusColors.$1,
                  foreground: statusColors.$2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                task.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.25,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF6C7D8D),
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const Spacer(),
              Text(
                '${task.priority} öncelik',
                style: const TextStyle(
                  color: Color(0xFFB55B52),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.folder_outlined,
                    size: 16,
                    color: Color(0xFF2468A0),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      task.projectName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 19,
                    color: Color(0xFF8A9BA8),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

(Color, Color) _statusColors(String status) => switch (status) {
  'Tamamlandı' => (const Color(0xFFE9F6EE), const Color(0xFF3D805C)),
  'Devam Ediyor' => (const Color(0xFFE8F4FB), const Color(0xFF2878A6)),
  _ => (const Color(0xFFFFF5E3), const Color(0xFFA87319)),
};

class _TaskoraMark extends StatelessWidget {
  const _TaskoraMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFF2468A0),
        borderRadius: BorderRadius.circular(11),
      ),
      child: const Icon(Icons.checklist_rounded, color: Colors.white, size: 21),
    );
  }
}
