import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import { NoticeBoard } from '../entities/notice-board.entity';

@Injectable()
export class DashboardService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    @InjectRepository(NoticeBoard)
    private noticeRepository: Repository<NoticeBoard>,
  ) {}

  async getDashboardStats(): Promise<{
    totalUsers: number;
    totalNotices: number;
    recentNotices: number;
    unreadNotifications: number;
  }> {
    try {
      const [totalUsers, totalNotices, recentNotices, unreadNotifications] = await Promise.all([
        this.userRepository.count({ where: { status: 1 } }),
        this.noticeRepository.count(),
        this.noticeRepository.count({
          where: {
            createdAt: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // Last 7 days
          },
        }),
        this.noticeRepository.count({
          where: {
            createdAt: new Date(Date.now() - 24 * 60 * 60 * 1000), // Last 24 hours
          },
        }),
      ]);

      return {
        totalUsers,
        totalNotices,
        recentNotices,
        unreadNotifications,
      };
    } catch (error) {
      console.error('Error fetching dashboard stats:', error);
      return {
        totalUsers: 0,
        totalNotices: 0,
        recentNotices: 0,
        unreadNotifications: 0,
      };
    }
  }

  async getTodayEvents(): Promise<NoticeBoard[]> {
    try {
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      
      const tomorrow = new Date(today);
      tomorrow.setDate(tomorrow.getDate() + 1);

      return await this.noticeRepository.find({
        where: {
          createdAt: {
            $gte: today,
            $lt: tomorrow,
          } as any,
        },
        order: { createdAt: 'DESC' },
        take: 5,
      });
    } catch (error) {
      console.error('Error fetching today events:', error);
      return [];
    }
  }

  async getUserProfile(userId: number): Promise<User | null> {
    try {
      return await this.userRepository.findOne({
        where: { id: userId },
        select: ['id', 'name', 'email', 'phoneNumber', 'role', 'nationalId', 'city', 'state', 'country', 'status', 'createdAt', 'updatedAt'],
      });
    } catch (error) {
      console.error('Error fetching user profile:', error);
      return null;
    }
  }

  async getRecentNotices(limit: number = 5): Promise<NoticeBoard[]> {
    try {
      return await this.noticeRepository.find({
        order: { createdAt: 'DESC' },
        take: limit,
      });
    } catch (error) {
      console.error('Error fetching recent notices:', error);
      return [];
    }
  }
}
