import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:my_flutter_app/screens/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  int id;
  int userId;
  String title;
  bool completed;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    required this.completed,
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
        userId: json['userId'] is int
            ? json['userId']
            : int.parse(json['userId'].toString()),
        title: json['title'] ?? '',
        completed: json['completed'] == true || json['completed'] == 'true',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'title': title,
        'completed': completed,
      };
}

enum TaskFilter { all, completed, incomplete }

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  late SharedPreferences _prefs;
  List<Task> _tasks = [];
  List<Task> _displayed = [];
  String _search = '';
  TaskFilter _filter = TaskFilter.all;
  bool _loading = false;
  int? _userId;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();

    final dynamic storedId = _prefs.get('userId');
    if (storedId is int) {
      _userId = storedId;
    } else if (storedId is String) {
      _userId = int.tryParse(storedId);
      if (_userId != null) {
        await _prefs.setInt('userId', _userId!);
      }
    }

    if (_userId == null) {
      _userId = 1;
      await _prefs.setInt('userId', 1);
    }

    await _loadFromPrefs();
    await _fetchFromApi();
  }

  String _tasksKeyForUser(int userId) => 'tasks_user_\$userId';

  Future<void> _loadFromPrefs() async {
    if (_userId == null) return;
    final key = _tasksKeyForUser(_userId!);
    final raw = _prefs.getString(key);
    if (raw != null && raw.isNotEmpty) {
      try {
        final arr = json.decode(raw) as List<dynamic>;
        _tasks = arr.map((e) => Task.fromJson(e)).toList();
      } catch (_) {
        _tasks = [];
      }
    }
    _applyFilters();
  }

  Future<void> _saveToPrefs() async {
    if (_userId == null) return;
    final key = _tasksKeyForUser(_userId!);
    final raw = json.encode(_tasks.map((t) => t.toJson()).toList());
    await _prefs.setString(key, raw);
  }

  Future<void> _fetchFromApi({String q = ''}) async {
    if (_userId == null) return;

    setState(() => _loading = true);

    final queryParams = {
      'userId': _userId.toString(),
      if (q.isNotEmpty) 'q': q,
    };

    final url = Uri.https(
      'jsonplaceholder.typicode.com',
      '/todos',
      queryParams,
    );

    try {
      final res = await http.get(url);
      if (res.statusCode == 200) {
        final arr = json.decode(res.body) as List<dynamic>;
        final apiTasks = arr.map((e) => Task.fromJson(e)).toList();

        final localOnly =
            _tasks.where((t) => apiTasks.every((a) => a.id != t.id)).toList();

        _tasks = [...apiTasks, ...localOnly];
        await _saveToPrefs();
        _applyFilters();
      } else {
        debugPrint('Failed to fetch tasks: ${res.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching tasks: $e');
    }

    setState(() => _loading = false);
  }

  void _applyFilters() {
    final query = _search.trim().toLowerCase();
    var list = _tasks;
    if (query.isNotEmpty) {
      list = list.where((t) => t.title.toLowerCase().contains(query)).toList();
    }
    if (_filter == TaskFilter.completed) {
      list = list.where((t) => t.completed).toList();
    } else if (_filter == TaskFilter.incomplete) {
      list = list.where((t) => !t.completed).toList();
    }
    setState(() => _displayed = list);
  }

  Future<void> _addTask() async {
    if (_userId == null) return;
    final controller = TextEditingController();
    final result = await showDialog<Task?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: const Text('Add Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Task title'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              final t = Task(
                id: DateTime.now().millisecondsSinceEpoch,
                userId: _userId!,
                title: text,
                completed: false,
              );
              Navigator.of(ctx).pop(t);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() => _tasks.insert(0, result));
      await _saveToPrefs();
      _applyFilters();
    }
  }

  Future<void> _editTask(Task task) async {
    final controller = TextEditingController(text: task.title);
    final result = await showDialog<Task?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: const Text('Edit Task'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Task title'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(null),
              child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              final text = controller.text.trim();
              if (text.isEmpty) return;
              final edited = Task(
                id: task.id,
                userId: task.userId,
                title: text,
                completed: task.completed,
              );
              Navigator.of(ctx).pop(edited);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result != null) {
      final idx = _tasks.indexWhere((t) => t.id == result.id);
      if (idx != -1) {
        setState(() => _tasks[idx] = result);
        await _saveToPrefs();
        _applyFilters();
      }
    }
  }

  Future<void> _deleteTask(Task task) async {
    final ok = await showDialog<bool?>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
        title: const Text('Delete Task'),
        content: Text('Delete "${task.title}"?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          ElevatedButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _tasks.removeWhere((t) => t.id == task.id));
      await _saveToPrefs();
      _applyFilters();
    }
  }

  Widget _buildFilterChips() {
    final chipLabels = {
      TaskFilter.all: 'All',
      TaskFilter.incomplete: 'Incomplete',
      TaskFilter.completed: 'Completed',
    };

    return Wrap(
      spacing: 10,
      children: chipLabels.entries.map((entry) {
        final isSelected = _filter == entry.key;
        return ChoiceChip(
          label: Text(
            entry.value,
            style: TextStyle(
              color: isSelected
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          selected: isSelected,
          showCheckmark: false,
          selectedColor: Theme.of(context).colorScheme.primary,
          backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
          side: BorderSide(
              width: 0.w,
              color: Theme.of(context).colorScheme.surfaceContainer),
          onSelected: (_) {
            setState(() => _filter = entry.key);
            _applyFilters();
          },
        );
      }).toList(),
    );
  }

  String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;
    final isWide = width > 600;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        scrolledUnderElevation: 0,
        title: Text(
          'Your Tasks',
          style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.w600),
        ),
        actions: [
          if (_loading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Fetch from API',
              onPressed: _userId == null ? null : () => _fetchFromApi(),
            ),
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
            icon: Icon(Icons.person_rounded),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _fetchFromApi(q: _search),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_tasks.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainer,
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search tasks...',
                      suffixIcon: _search.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _search = '');
                                _applyFilters();
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      isDense: true,
                    ),
                    onChanged: (v) {
                      setState(() => _search = v);
                      _applyFilters();
                    },
                  ),
                ),
              if (_tasks.isNotEmpty) const SizedBox(height: 8),
              if (_tasks.isNotEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildFilterChips(),
                  ),
                ),
              if (_tasks.isNotEmpty) const SizedBox(height: 12),
              Expanded(
                child: _displayed.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_loading && _tasks.isEmpty)
                              const SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 3,
                                  strokeCap: StrokeCap.round,
                                ),
                              )
                            else ...[
                              Text(
                                _loading ? 'Loading...' : 'No tasks found',
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(height: 8),
                              if (!_loading && _userId != null)
                                ElevatedButton(
                                  onPressed: _fetchFromApi,
                                  child: const Text('Fetch from API'),
                                ),
                            ],
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: _displayed.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withAlpha(100),
                          thickness: 0.1,
                        ),
                        itemBuilder: (ctx, idx) {
                          final t = _displayed[idx];
                          return InkWell(
                            onTap: () => _editTask(t),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isWide ? 20 : 12,
                                vertical: 10,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    margin: const EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: t.completed
                                          ? Colors.green
                                          : Colors.orange,
                                    ),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          capitalizeFirst(t.title),
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: isWide ? 18 : 16,
                                            fontWeight: FontWeight.w600,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withAlpha(220),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          "Task ID: ${t.id}",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary
                                                .withAlpha(170),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    onSelected: (v) async {
                                      if (v == 'edit') await _editTask(t);
                                      if (v == 'delete') await _deleteTask(t);
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(
                                          value: 'edit',
                                          child: Text('Edit Task')),
                                      const PopupMenuItem(
                                          value: 'delete',
                                          child: Text('Delete Task')),
                                    ],
                                    icon: const Icon(Icons.more_vert, size: 20),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTask,
        label: const Text('Add Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
