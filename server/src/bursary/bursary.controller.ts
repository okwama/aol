import { Controller, Get, Post, Body, Put, Param, Delete, Query } from '@nestjs/common';
import { BursaryService } from './bursary.service';
import { BursaryApplication } from '../entities/bursary-application.entity';

@Controller('bursary')
export class BursaryController {
  constructor(private readonly bursaryService: BursaryService) {}

  @Get()
  findAll() {
    return this.bursaryService.findAll();
  }

  @Get('user/:userId')
  findByUserId(@Param('userId') userId: string) {
    return this.bursaryService.findByUserId(+userId);
  }

  @Get('status/:status')
  findByStatus(@Param('status') status: string) {
    return this.bursaryService.findByStatus(status);
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.bursaryService.findOne(+id);
  }

  @Post()
  create(@Body() bursaryData: Partial<BursaryApplication>) {
    return this.bursaryService.create(bursaryData);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() bursaryData: Partial<BursaryApplication>) {
    return this.bursaryService.update(+id, bursaryData);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.bursaryService.remove(+id);
  }
}
