import '../models/notice_board.dart';
import 'base_repository.dart';

abstract class NoticeRepository extends BaseRepository<NoticeBoard> {
  Future<List<NoticeBoard>> getRecentNotices(int limit);
  Future<List<NoticeBoard>> getNoticesByDateRange(DateTime startDate, DateTime endDate);
  Future<List<NoticeBoard>> searchNotices(String query);
  Future<List<NoticeBoard>> getImportantNotices();
  Future<bool> markAsRead(int noticeId);
  Future<int> getUnreadCount();
}
