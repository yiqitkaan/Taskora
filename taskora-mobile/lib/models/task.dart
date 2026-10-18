class Task {
  static const imagePaths = [
    'assets/images/tasks/task-mobile.png',
    'assets/images/tasks/task-backend.png',
    'assets/images/tasks/task-web.png',
    'assets/images/tasks/task-database.png',
    'assets/images/tasks/task-roadmap.png',
  ];

  const Task({
    required this.id,
    required this.title,
    required this.description,
    required this.projectName,
    required this.priority,
    required this.status,
    required this.assignee,
    required this.dueDate,
    required this.imagePath,
  });

  final int id;
  final String title;
  final String description;
  final String projectName;
  final String priority;
  final String status;
  final String assignee;
  final String dueDate;
  final String imagePath;

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'] as int,
    title: json['title'] as String,
    description: json['description'] as String,
    projectName: json['projectName'] as String,
    priority: json['priority'] as String,
    status: json['status'] as String,
    assignee: json['assignee'] as String,
    dueDate: json['dueDate'] as String,
    imagePath: json['imagePath'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'projectName': projectName,
    'priority': priority,
    'status': status,
    'assignee': assignee,
    'dueDate': dueDate,
    'imagePath': imagePath,
  };

  Task copyWith({
    String? title,
    String? description,
    String? projectName,
    String? priority,
    String? status,
    String? assignee,
    String? dueDate,
    String? imagePath,
  }) => Task(
    id: id,
    title: title ?? this.title,
    description: description ?? this.description,
    projectName: projectName ?? this.projectName,
    priority: priority ?? this.priority,
    status: status ?? this.status,
    assignee: assignee ?? this.assignee,
    dueDate: dueDate ?? this.dueDate,
    imagePath: imagePath ?? this.imagePath,
  );
}
