import { Controller, Get, Param, Query } from '@nestjs/common';
import { DashboardService } from './dashboard.service';

@Controller('dashboard')
export class DashboardController {
  constructor(private readonly dashboardService: DashboardService) {}

  @Get('stats')
  async getDashboardStats() {
    try {
      const stats = await this.dashboardService.getDashboardStats();
      return {
        success: true,
        data: stats,
        message: 'Dashboard stats retrieved successfully',
      };
    } catch (error) {
      return {
        success: false,
        data: null,
        message: 'Failed to retrieve dashboard stats',
        error: error.message,
      };
    }
  }

  @Get('today-events')
  async getTodayEvents() {
    try {
      const events = await this.dashboardService.getTodayEvents();
      return {
        success: true,
        data: events,
        message: events.length > 0 ? 'Today events retrieved successfully' : 'No events for today',
      };
    } catch (error) {
      return {
        success: false,
        data: [],
        message: 'Failed to retrieve today events',
        error: error.message,
      };
    }
  }

  @Get('user-profile/:userId')
  async getUserProfile(@Param('userId') userId: string) {
    try {
      const userProfile = await this.dashboardService.getUserProfile(parseInt(userId));
      if (userProfile) {
        return {
          success: true,
          data: userProfile,
          message: 'User profile retrieved successfully',
        };
      } else {
        return {
          success: false,
          data: null,
          message: 'User not found',
        };
      }
    } catch (error) {
      return {
        success: false,
        data: null,
        message: 'Failed to retrieve user profile',
        error: error.message,
      };
    }
  }

  @Get('recent-notices')
  async getRecentNotices(@Query('limit') limit: string = '5') {
    try {
      const notices = await this.dashboardService.getRecentNotices(parseInt(limit));
      return {
        success: true,
        data: notices,
        message: 'Recent notices retrieved successfully',
      };
    } catch (error) {
      return {
        success: false,
        data: [],
        message: 'Failed to retrieve recent notices',
        error: error.message,
      };
    }
  }

  @Get('home-data')
  async getHomeData() {
    try {
      const [stats, todayEvents, recentNotices] = await Promise.all([
        this.dashboardService.getDashboardStats(),
        this.dashboardService.getTodayEvents(),
        this.dashboardService.getRecentNotices(3),
      ]);

      return {
        success: true,
        data: {
          stats,
          todayEvents,
          recentNotices,
        },
        message: 'Home data retrieved successfully',
      };
    } catch (error) {
      return {
        success: false,
        data: null,
        message: 'Failed to retrieve home data',
        error: error.message,
      };
    }
  }
}
