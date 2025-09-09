import { Controller, Get, Post, Body, Put, Param, Delete, Query } from '@nestjs/common';
import { AmbulanceService } from './ambulance.service';
import { AmbulanceRequest } from '../entities/ambulance-request.entity';

@Controller('ambulance')
export class AmbulanceController {
  constructor(private readonly ambulanceService: AmbulanceService) {}

  @Get()
  findAll() {
    return this.ambulanceService.findAll();
  }

  @Get('user/:userId')
  findByUserId(@Param('userId') userId: string) {
    return this.ambulanceService.findByUserId(+userId);
  }

  @Get('status/:status')
  findByStatus(@Param('status') status: string) {
    return this.ambulanceService.findByStatus(status);
  }

  @Get('pending')
  getPendingRequests() {
    return this.ambulanceService.getPendingRequests();
  }

  @Get('assigned')
  getAssignedRequests() {
    return this.ambulanceService.getAssignedRequests();
  }

  @Get('emergency')
  getEmergencyRequests() {
    return this.ambulanceService.getEmergencyRequests();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.ambulanceService.findOne(+id);
  }

  @Post()
  create(@Body() ambulanceRequest: Partial<AmbulanceRequest>) {
    return this.ambulanceService.create(ambulanceRequest);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() updateData: Partial<AmbulanceRequest>) {
    return this.ambulanceService.update(+id, updateData);
  }

  @Put(':id/assign')
  assignAmbulance(
    @Param('id') id: string,
    @Body() body: { ambulanceId: number; assignedBy: number }
  ) {
    return this.ambulanceService.assignAmbulance(+id, body.ambulanceId, body.assignedBy);
  }

  @Put(':id/status')
  updateStatus(
    @Param('id') id: string,
    @Body() body: { status: string }
  ) {
    return this.ambulanceService.updateStatus(+id, body.status);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.ambulanceService.remove(+id);
  }
}
