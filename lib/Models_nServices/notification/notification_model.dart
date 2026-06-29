import 'dart:convert';

class NotificationsResponse {
  final bool status;
  final String message;
  final NotificationData data;

  NotificationsResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: NotificationData.fromJson(json['data']),
    );
  }
}

class NotificationData {
  final int? currentPage;      // 👈 Made nullable
  final List<NotificationItem> data;
  final String? firstPageUrl;
  final int? from;             // 👈 Made nullable
  final int? lastPage;         // 👈 Made nullable
  final String? lastPageUrl;
  final List<Link> links;
  final String? nextPageUrl;
  final String path;
  final int perPage;
  final String? prevPageUrl;
  final int? to;               // 👈 Made nullable
  final int total;

  NotificationData({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    required this.links,
    this.nextPageUrl,
    required this.path,
    required this.perPage,
    this.prevPageUrl,
    this.to,
    required this.total,
  });

  factory NotificationData.fromJson(dynamic json) {
    final Map<String, dynamic> map = json is String
        ? jsonDecode(json) as Map<String, dynamic>
        : json as Map<String, dynamic>;

    return NotificationData(
      currentPage: map['current_page'] as int?,
      data: (map['data'] as List)
          .map((e) => NotificationItem.fromJson(e))
          .toList(),
      firstPageUrl: map['first_page_url'] as String?,
      from: map['from'] as int?,
      lastPage: map['last_page'] as int?,
      lastPageUrl: map['last_page_url'] as String?,
      links: (map['links'] as List)
          .map((e) => Link.fromJson(e))
          .toList(),
      nextPageUrl: map['next_page_url'] as String?,
      path: map['path'] as String,
      perPage: map['per_page'] as int,
      prevPageUrl: map['prev_page_url'] as String?,
      to: map['to'] as int?,
      total: map['total'] as int,
    );
  }
}

class NotificationItem {
  final String id;
  final NotificationContent data;
  final DateTime? readAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  NotificationItem({
    required this.id,
    required this.data,
    this.readAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] as String,
      data: NotificationContent.fromJson(json['data']),
      readAt: json['read_at'] != null
          ? DateTime.parse(json['read_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  bool get isRead => readAt != null;
}

class NotificationContent {
  final String title;
  final String message;
  final String type;

  NotificationContent({
    required this.title,
    required this.message,
    required this.type,
  });

  factory NotificationContent.fromJson(dynamic json) {
    final Map<String, dynamic> map = json is String
        ? jsonDecode(json) as Map<String, dynamic>
        : json as Map<String, dynamic>;

    return NotificationContent(
      title: map['title'] as String,
      message: map['message'] as String,
      type: map['type'] as String,
    );
  }
}

class Link {
  final String? url;
  final String label;
  final int? page;
  final bool active;

  Link({
    this.url,
    required this.label,
    this.page,
    required this.active,
  });

  factory Link.fromJson(Map<String, dynamic> json) {
    return Link(
      url: json['url'] as String?,
      label: json['label'] as String,
      page: json['page'] as int?,
      active: json['active'] as bool,
    );
  }
}