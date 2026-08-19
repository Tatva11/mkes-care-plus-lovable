class TaskItem {
  final String id;
  final String title;
  final String? description;
  final String assignedTo;
  final String? assignedBy;
  final DateTime? dueDate;
  final String priority; // 'low', 'medium', 'high', 'critical'
  final String status; // 'pending', 'in_progress', 'completed', 'overdue', 'cancelled'
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? completedAt;

  TaskItem({
    required this.id,
    required this.title,
    this.description,
    required this.assignedTo,
    this.assignedBy,
    this.dueDate,
    required this.priority,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    this.completedAt,
  });

  factory TaskItem.fromJson(Map<String, dynamic> json) {
    return TaskItem(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String?,
      assignedTo: json['assigned_to'] as String,
      assignedBy: json['assigned_by'] as String?,
      dueDate: json['due_date'] != null ? DateTime.parse(json['due_date'] as String) : null,
      priority: json['priority'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      completedAt: json['completed_at'] != null ? DateTime.parse(json['completed_at'] as String) : null,
    );
  }

  bool get isOverdue {
    if (status == 'completed' || status == 'cancelled') return false;
    if (dueDate == null) return false;
    return dueDate!.isBefore(DateTime.now());
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'assigned_to': assignedTo,
      'assigned_by': assignedBy,
      'due_date': dueDate?.toIso8601String(),
      'priority': priority,
      'status': status,
    };
  }
}
