import { Controller, Get, Post, Body, Put, Param, Delete } from '@nestjs/common';
import { NoticeService } from './notice.service';
import { NoticeBoard } from '../entities/notice-board.entity';

@Controller('notices')
export class NoticeController {
  constructor(private readonly noticeService: NoticeService) {}

  @Get()
  findAll() {
    return this.noticeService.findAll();
  }

  @Get(':id')
  findOne(@Param('id') id: string) {
    return this.noticeService.findOne(+id);
  }

  @Post()
  create(@Body() notice: Partial<NoticeBoard>) {
    return this.noticeService.create(notice);
  }

  @Put(':id')
  update(@Param('id') id: string, @Body() notice: Partial<NoticeBoard>) {
    return this.noticeService.update(+id, notice);
  }

  @Delete(':id')
  remove(@Param('id') id: string) {
    return this.noticeService.remove(+id);
  }
}
