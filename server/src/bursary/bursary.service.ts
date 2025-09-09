import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { BursaryApplication } from '../entities/bursary-application.entity';

@Injectable()
export class BursaryService {
  constructor(
    @InjectRepository(BursaryApplication)
    private bursaryApplicationRepository: Repository<BursaryApplication>,
  ) {}

  async findAll(): Promise<BursaryApplication[]> {
    try {
      return await this.bursaryApplicationRepository.find({
        order: { createdAt: 'DESC' },
      });
    } catch (error) {
      console.error('Error fetching all bursary applications:', error);
      throw new Error('Failed to fetch bursary applications');
    }
  }

  async findOne(id: number): Promise<BursaryApplication> {
    return this.bursaryApplicationRepository.findOne({ where: { id } });
  }

  async findByUserId(userId: number): Promise<BursaryApplication[]> {
    return this.bursaryApplicationRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  async findByStatus(status: string): Promise<BursaryApplication[]> {
    return this.bursaryApplicationRepository.find({
      where: { status },
      order: { createdAt: 'DESC' },
    });
  }

  async create(bursaryData: Partial<BursaryApplication>): Promise<BursaryApplication> {
    try {
      const bursaryApplication = this.bursaryApplicationRepository.create({
        ...bursaryData,
        applicationDate: new Date(),
      });
      return await this.bursaryApplicationRepository.save(bursaryApplication);
    } catch (error) {
      console.error('Error creating bursary application:', error);
      throw new Error('Failed to create bursary application');
    }
  }

  async update(id: number, bursaryData: Partial<BursaryApplication>): Promise<BursaryApplication> {
    await this.bursaryApplicationRepository.update(id, bursaryData);
    return this.findOne(id);
  }

  async remove(id: number): Promise<void> {
    await this.bursaryApplicationRepository.delete(id);
  }
}
