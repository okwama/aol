import { Controller, Get, Post, Body, Put, Param, Delete, Query } from '@nestjs/common';
import { ActivityService } from './activity.service';
import { Activity } from '../entities/activity.entity';

@Controller('activity')
export class ActivityController {
  constructor(private readonly activityService: ActivityService) {}

  @Get()
  findAll() {
    return this.activityService.findAll();
  }

  @Get('user/:userId')
  findByUserId(@Param('userId') userId: string) {
    return this.activityService.findByUserId(+userId);
  }

  @Get('status/:status')
  findByStatus(@Param('status') status: string) {
    return this.activityService.findByStatus(+status);
  }

  @Get('type/:activityType')
  findByActivityType(@Param('activityType') activityType: string) {
    return this.activityService.findByActivityType(activityType);
  }

  @Get('location')
  findByLocation(@Query('location') location: string) {
    return this.activityService.findByLocation(location);
  }

  @Get('date-range')
  findByDateRange(
    @Query('startDate') startDate: string,
    @Query('endDate') endDate: string,
  ) {
    return this.activityService.findByDateRange(startDate, endDate);
  }

  @Get('upcoming')
  getUpcomingActivities() {
    return this.activityService.getUpcomingActivities();
  }

  @Get('completed')
  getCompletedActivities() {
    return this.activityService.getCompletedActivities();
  }

  @Get('month/:year/:month')
  getActivitiesByMonth(
    @Param('year') year: string,
    @Param('month') month: string,
  ) {
    return this.activityService.getActivitiesByMonth(+year, +month);
  }

  @Get('budget/user/:userId')
  getTotalBudgetByUser(@Param('userId') userId: string) {
    return this.activityService.getTotalBudgetByUser(+userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.activityService.findOne(+id);
  }

  @Post()
  create(@Body() activity: Partial<Activity>) {
    return this.activityService.create(activity);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updateData: Partial<Activity>) {
    return this.activityService.update(+id, updateData);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.activityService.remove(+id);
  }
}
