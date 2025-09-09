import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Activity } from '../entities/activity.entity';

@Injectable()
export class ActivityService {
  constructor(
    @InjectRepository(Activity)
    private readonly activityRepository: Repository<Activity>,
  ) {}

  async findAll(): Promise<Activity[]> {
    try {
      return await this.activityRepository.find({
        order: { startDate: 'ASC' },
      });
    } catch (error) {
      console.error('Error fetching activities:', error);
      throw new Error('Failed to fetch activities');
    }
  }

  async findOne(id: number): Promise<Activity | null> {
    try {
      return await this.activityRepository.findOne({ where: { id } });
    } catch (error) {
      console.error('Error fetching activity:', error);
      throw new Error('Failed to fetch activity');
    }
  }

  async create(activityData: Partial<Activity>): Promise<Activity> {
    try {
      const activity = this.activityRepository.create(activityData);
      return await this.activityRepository.save(activity);
    } catch (error) {
      console.error('Error creating activity:', error);
      throw new Error('Failed to create activity');
    }
  }

  async update(id: number, updateData: Partial<Activity>): Promise<Activity | null> {
    try {
      await this.activityRepository.update(id, updateData);
      return await this.findOne(id);
    } catch (error) {
      console.error('Error updating activity:', error);
      throw new Error('Failed to update activity');
    }
  }

  async remove(id: number): Promise<void> {
    try {
      await this.activityRepository.delete(id);
    } catch (error) {
      console.error('Error deleting activity:', error);
      throw new Error('Failed to delete activity');
    }
  }

  async findByUserId(userId: number): Promise<Activity[]> {
    try {
      return await this.activityRepository.find({
        where: { userId },
        order: { startDate: 'ASC' },
      });
    } catch (error) {
      console.error('Error fetching user activities:', error);
      throw new Error('Failed to fetch user activities');
    }
  }

  async findByStatus(status: number): Promise<Activity[]> {
    try {
      return await this.activityRepository.find({
        where: { status },
        order: { startDate: 'ASC' },
      });
    } catch (error) {
      console.error('Error fetching activities by status:', error);
      throw new Error('Failed to fetch activities by status');
    }
  }

  async findByActivityType(activityType: string): Promise<Activity[]> {
    try {
      return await this.activityRepository.find({
        where: { activityType },
        order: { startDate: 'ASC' },
      });
    } catch (error) {
      console.error('Error fetching activities by type:', error);
      throw new Error('Failed to fetch activities by type');
    }
  }

  async findByDateRange(startDate: string, endDate: string): Promise<Activity[]> {
    try {
      return await this.activityRepository
        .createQueryBuilder('activity')
        .where('activity.startDate BETWEEN :startDate AND :endDate', { startDate, endDate })
        .orderBy('activity.startDate', 'ASC')
        .getMany();
    } catch (error) {
      console.error('Error fetching activities by date range:', error);
      throw new Error('Failed to fetch activities by date range');
    }
  }

  async findByLocation(location: string): Promise<Activity[]> {
    try {
      return await this.activityRepository
        .createQueryBuilder('activity')
        .where('activity.location LIKE :location', { location: `%${location}%` })
        .orderBy('activity.startDate', 'ASC')
        .getMany();
    } catch (error) {
      console.error('Error fetching activities by location:', error);
      throw new Error('Failed to fetch activities by location');
    }
  }

  async getUpcomingActivities(): Promise<Activity[]> {
    try {
      const today = new Date().toISOString().split('T')[0];
      return await this.activityRepository
        .createQueryBuilder('activity')
        .where('activity.startDate >= :today', { today })
        .orderBy('activity.startDate', 'ASC')
        .getMany();
    } catch (error) {
      console.error('Error fetching upcoming activities:', error);
      throw new Error('Failed to fetch upcoming activities');
    }
  }

  async getCompletedActivities(): Promise<Activity[]> {
    try {
      const today = new Date().toISOString().split('T')[0];
      return await this.activityRepository
        .createQueryBuilder('activity')
        .where('activity.endDate < :today', { today })
        .orderBy('activity.endDate', 'DESC')
        .getMany();
    } catch (error) {
      console.error('Error fetching completed activities:', error);
      throw new Error('Failed to fetch completed activities');
    }
  }

  async getTotalBudgetByUser(userId: number): Promise<number> {
    try {
      const result = await this.activityRepository
        .createQueryBuilder('activity')
        .select('SUM(activity.budgetTotal)', 'total')
        .where('activity.userId = :userId', { userId })
        .getRawOne();
      
      return parseFloat(result.total) || 0;
    } catch (error) {
      console.error('Error calculating total budget:', error);
      throw new Error('Failed to calculate total budget');
    }
  }

  async getActivitiesByMonth(year: number, month: number): Promise<Activity[]> {
    try {
      const startDate = `${year}-${month.toString().padStart(2, '0')}-01`;
      const endDate = `${year}-${month.toString().padStart(2, '0')}-31`;
      
      return await this.findByDateRange(startDate, endDate);
    } catch (error) {
      console.error('Error fetching activities by month:', error);
      throw new Error('Failed to fetch activities by month');
    }
  }
}
