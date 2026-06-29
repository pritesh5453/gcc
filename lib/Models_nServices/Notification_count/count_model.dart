class NotificationUnreadCountResponse {
  final bool status;
  final String message;
  final NotificationData data;

  NotificationUnreadCountResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory NotificationUnreadCountResponse.fromJson(Map<String, dynamic> json) {
    return NotificationUnreadCountResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: NotificationData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }
}

class NotificationData {
  final int unreadCount;

  NotificationData({required this.unreadCount});

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      unreadCount: json['unread_count'] as int,
    );
  }
}