import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gcc/Models_nServices/notification/notification_model.dart';
import 'package:gcc/Models_nServices/notification/notification_svc.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationService _service = NotificationService();

  List<NotificationItem> _notifications = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _errorMessage;
  int _currentPage = 1;
  int _lastPage = 1;
  bool _hasMorePages = true;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadNotifications();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMorePages && !_isLoading) {
        _loadMore();
      }
    }
  }

  // ─── Load first page ──────────────────────────────────────────────────
  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = 1;
      _notifications = [];
      _hasMorePages = true;
    });

    try {
      final response = await _service.getNotifications(
        page: _currentPage,
        perPage: 20,
      );

      setState(() {
        final data = response.data;
        _notifications = data.data;
        _currentPage = data.currentPage ?? 1;
        _lastPage = data.lastPage ?? 1;
        _hasMorePages = (_currentPage < _lastPage) && data.data.isNotEmpty;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = _getErrorMessage(e);
        _isLoading = false;
      });
    }
  }

  // ─── Load more (pagination) ──────────────────────────────────────────
  Future<void> _loadMore() async {
    if (!_hasMorePages || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
      _currentPage++;
    });

    try {
      final response = await _service.getNotifications(
        page: _currentPage,
        perPage: 20,
      );

      setState(() {
        final data = response.data;
        _notifications.addAll(data.data);
        _currentPage = data.currentPage ?? _currentPage;
        _lastPage = data.lastPage ?? 1;
        _hasMorePages = (_currentPage < _lastPage) && data.data.isNotEmpty;
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() => _isLoadingMore = false);
      _showSnackBar('Failed to load more: ${_getErrorMessage(e)}', isError: true);
    }
  }

  // ─── Pull-to-refresh ──────────────────────────────────────────────────
  Future<void> _refresh() => _loadNotifications();

  // ─── Mark a single notification as read ──────────────────────────────
  // Future<void> _markAsRead(String id) async {
  //   try {
  //     final success = await _service.markAsRead(id);
  //     if (success) {
  //       setState(() {
  //         final index = _notifications.indexWhere((n) => n.id == id);
  //         if (index != -1) {
  //           final item = _notifications[index];
  //           _notifications[index] = NotificationItem(
  //             id: item.id,
  //             data: item.data,
  //             readAt: DateTime.now(),
  //             createdAt: item.createdAt,
  //             updatedAt: item.updatedAt,
  //           );
  //         }
  //       });
  //       _showSnackBar('Marked as read');
  //     } else {
  //       _showSnackBar('Failed to mark as read', isError: true);
  //     }
  //   } catch (e) {
  //     _showSnackBar('Error: ${_getErrorMessage(e)}', isError: true);
  //   }
  // }

  // ─── Mark all as read ─────────────────────────────────────────────────
  Future<void> _markAllAsRead() async {
    try {
      final success = await _service.markAllAsRead();
      if (success) {
        setState(() {
          _notifications = _notifications.map((item) {
            return NotificationItem(
              id: item.id,
              data: item.data,
              readAt: DateTime.now(),
              createdAt: item.createdAt,
              updatedAt: item.updatedAt,
            );
          }).toList();
        });
        _showSnackBar('All notifications marked as read');
      } else {
        _showSnackBar('Failed to mark all as read', isError: true);
      }
    } catch (e) {
      _showSnackBar('Error: ${_getErrorMessage(e)}', isError: true);
    }
  }

  // ─── Show details in bottom sheet ─────────────────────────────────────
  void _showDetails(NotificationItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color(0xFF1B6B2F).withOpacity(0.1),
                    child: Text(
                      item.data.type[0],
                      style: const TextStyle(
                        color: Color(0xFF1B6B2F),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.data.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _formatDate(item.createdAt),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!item.isRead)
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B6B2F),
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                item.data.message,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6B2F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────
  String _getErrorMessage(dynamic e) {
    if (e is DioException) {
      if (e.response?.statusCode == 401) {
        return 'Session expired. Please login again.';
      }
      return e.message ?? 'Something went wrong';
    }
    return e.toString();
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? Colors.red : const Color(0xFF1B6B2F),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 7) {
      const months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } else if (diff.inDays >= 1) {
      return '${diff.inDays}d ago';
    } else if (diff.inHours >= 1) {
      return '${diff.inHours}h ago';
    } else if (diff.inMinutes >= 1) {
      return '${diff.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  // ─── Build ──────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FBF8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            const Text(
              'Notifications',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B6B2F),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Stay updated',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorWidget()
          : _notifications.isEmpty
          ? _buildEmptyWidget()
          : RefreshIndicator(
            onRefresh: _refresh,
            color: const Color(0xFF1B6B2F),
            child: ListView.separated(
              controller: _scrollController,
              itemCount: _notifications.length + (_isLoadingMore ? 1 : 0),
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 70,
                color: Colors.grey[200],
              ),
              itemBuilder: (context, index) {
                if (index == _notifications.length && _isLoadingMore) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _buildNotificationItem(_notifications[index]);
              },
            ),
          ),
    );
  }

  Widget _buildErrorWidget() {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: const Color(0xFF1B6B2F),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(_errorMessage!, textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _loadNotifications,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B6B2F),
                    ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return RefreshIndicator(
      onRefresh: _refresh,
      color: const Color(0xFF1B6B2F),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.7,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('🔔', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                const Text(
                  'No notifications yet',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ll notify you when something happens',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _loadNotifications,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B6B2F),
                  ),
                  child: const Text('Refresh', style: TextStyle(color: Colors.white),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationItem(NotificationItem item) {
    final isRead = item.isRead;
    final type = item.data.type;

    IconData iconData;
    Color iconColor;
    switch (type.toLowerCase()) {
      case 'buy':
        iconData = Icons.shopping_bag_outlined;
        iconColor = Colors.green;
        break;
      case 'sell':
        iconData = Icons.trending_down_outlined;
        iconColor = Colors.red;
        break;
      case 'reward':
      case 'referral':
        iconData = Icons.card_giftcard_outlined;
        iconColor = Colors.orange;
        break;
      default:
        iconData = Icons.notifications_outlined;
        iconColor = Colors.grey;
    }

    return Container(
      color: isRead ? Colors.white : const Color(0xFFF0FAF2),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(iconData, color: iconColor, size: 22),
        ),
        title: Text(
          item.data.title,
          style: TextStyle(
            fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
            fontSize: 14,
            color: isRead ? Colors.black87 : Colors.black,
          ),
        ),
        subtitle: Text(
          item.data.message,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            color: isRead ? Colors.grey[600] : Colors.grey[800],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatDate(item.createdAt),
              style: TextStyle(
                fontSize: 11,
                color: isRead ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(width: 6),
            if (!isRead)
              Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFF1B6B2F),
                  shape: BoxShape.circle,
                ),
              ),
            const Icon(Icons.chevron_right, color: Colors.grey, size: 18),
          ],
        ),
        onTap: () {
          if (!isRead) {
            
          }
          _showDetails(item);
        },
      ),
    );
  }
}