import '../models/notice_board.dart';
import '../repositories/notice_repository.dart';

class NoticeService {
  final NoticeRepository _noticeRepository;

  NoticeService(this._noticeRepository);

  Future<List<NoticeBoard>> getAllNotices() async {
    try {
      return await _noticeRepository.getAll();
    } catch (e) {
      print('Error fetching notices: $e');
      return [];
    }
  }

  Future<NoticeBoard?> getNoticeById(int id) async {
    try {
      return await _noticeRepository.getById(id);
    } catch (e) {
      print('Error fetching notice: $e');
      return null;
    }
  }

  Future<NoticeBoard?> createNotice(NoticeBoard notice) async {
    try {
      return await _noticeRepository.create(notice);
    } catch (e) {
      print('Error creating notice: $e');
      return null;
    }
  }

  Future<bool> updateNotice(NoticeBoard notice) async {
    try {
      await _noticeRepository.update(notice);
      return true;
    } catch (e) {
      print('Error updating notice: $e');
      return false;
    }
  }

  Future<bool> deleteNotice(int id) async {
    try {
      return await _noticeRepository.delete(id);
    } catch (e) {
      print('Error deleting notice: $e');
      return false;
    }
  }

  Future<List<NoticeBoard>> getRecentNotices(int limit) async {
    try {
      return await _noticeRepository.getRecentNotices(limit);
    } catch (e) {
      print('Error fetching recent notices: $e');
      return [];
    }
  }

  Future<List<NoticeBoard>> getNoticesByDateRange(DateTime startDate, DateTime endDate) async {
    try {
      return await _noticeRepository.getNoticesByDateRange(startDate, endDate);
    } catch (e) {
      print('Error fetching notices by date range: $e');
      return [];
    }
  }

  Future<List<NoticeBoard>> searchNotices(String query) async {
    try {
      return await _noticeRepository.searchNotices(query);
    } catch (e) {
      print('Error searching notices: $e');
      return [];
    }
  }

  Future<List<NoticeBoard>> getImportantNotices() async {
    try {
      return await _noticeRepository.getImportantNotices();
    } catch (e) {
      print('Error fetching important notices: $e');
      return [];
    }
  }

  Future<bool> markNoticeAsRead(int noticeId) async {
    try {
      return await _noticeRepository.markAsRead(noticeId);
    } catch (e) {
      print('Error marking notice as read: $e');
      return false;
    }
  }

  Future<int> getUnreadNoticeCount() async {
    try {
      return await _noticeRepository.getUnreadCount();
    } catch (e) {
      print('Error getting unread count: $e');
      return 0;
    }
  }

  Future<List<NoticeBoard>> getNoticesByCategory(String category) async {
    try {
      final allNotices = await _noticeRepository.getAll();
      return allNotices.where((notice) =>
        notice.title.toLowerCase().contains(category.toLowerCase()) ||
        notice.content.toLowerCase().contains(category.toLowerCase())
      ).toList();
    } catch (e) {
      print('Error fetching notices by category: $e');
      return [];
    }
  }

  Future<List<NoticeBoard>> getUrgentNotices() async {
    try {
      final allNotices = await _noticeRepository.getAll();
      return allNotices.where((notice) =>
        notice.title.toLowerCase().contains('urgent') ||
        notice.title.toLowerCase().contains('emergency') ||
        notice.title.toLowerCase().contains('important')
      ).toList();
    } catch (e) {
      print('Error fetching urgent notices: $e');
      return [];
    }
  }
}
