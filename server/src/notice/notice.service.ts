import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { NoticeBoard } from '../entities/notice-board.entity';

@Injectable()
export class NoticeService {
  constructor(
    @InjectRepository(NoticeBoard)
    private noticeRepository: Repository<NoticeBoard>,
  ) {}

  async findAll(): Promise<NoticeBoard[]> {
    return this.noticeRepository.find();
  }

  async findOne(id: number): Promise<NoticeBoard> {
    return this.noticeRepository.findOne({ where: { id } });
  }

  async create(notice: Partial<NoticeBoard>): Promise<NoticeBoard> {
    const newNotice = this.noticeRepository.create(notice);
    return this.noticeRepository.save(newNotice);
  }

  async update(id: number, notice: Partial<NoticeBoard>): Promise<NoticeBoard> {
    await this.noticeRepository.update(id, notice);
    return this.findOne(id);
  }

  async remove(id: number): Promise<void> {
    await this.noticeRepository.delete(id);
  }
}
