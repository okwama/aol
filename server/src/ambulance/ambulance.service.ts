import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { AmbulanceRequest } from '../entities/ambulance-request.entity';

@Injectable()
export class AmbulanceService {
  constructor(
    @InjectRepository(AmbulanceRequest)
    private readonly ambulanceRequestRepository: Repository<AmbulanceRequest>,
  ) {}

  async findAll(): Promise<AmbulanceRequest[]> {
    try {
      return await this.ambulanceRequestRepository.find({
        order: { createdAt: 'DESC' },
      });
    } catch (error) {
      console.error('Error fetching ambulance requests:', error);
      throw new Error('Failed to fetch ambulance requests');
    }
  }

  async findOne(id: number): Promise<AmbulanceRequest | null> {
    try {
      return await this.ambulanceRequestRepository.findOne({ where: { id } });
    } catch (error) {
      console.error('Error fetching ambulance request:', error);
      throw new Error('Failed to fetch ambulance request');
    }
  }

  async create(ambulanceRequestData: Partial<AmbulanceRequest>): Promise<AmbulanceRequest> {
    try {
      const ambulanceRequest = this.ambulanceRequestRepository.create(ambulanceRequestData);
      return await this.ambulanceRequestRepository.save(ambulanceRequest);
    } catch (error) {
      console.error('Error creating ambulance request:', error);
      throw new Error('Failed to create ambulance request');
    }
  }

  async update(id: number, updateData: Partial<AmbulanceRequest>): Promise<AmbulanceRequest | null> {
    try {
      await this.ambulanceRequestRepository.update(id, updateData);
      return await this.findOne(id);
    } catch (error) {
      console.error('Error updating ambulance request:', error);
      throw new Error('Failed to update ambulance request');
    }
  }

  async remove(id: number): Promise<void> {
    try {
      await this.ambulanceRequestRepository.delete(id);
    } catch (error) {
      console.error('Error deleting ambulance request:', error);
      throw new Error('Failed to delete ambulance request');
    }
  }

  async findByUserId(userId: number): Promise<AmbulanceRequest[]> {
    try {
      return await this.ambulanceRequestRepository.find({
        where: { userId },
        order: { createdAt: 'DESC' },
      });
    } catch (error) {
      console.error('Error fetching user ambulance requests:', error);
      throw new Error('Failed to fetch user ambulance requests');
    }
  }

  async findByStatus(status: string): Promise<AmbulanceRequest[]> {
    try {
      return await this.ambulanceRequestRepository.find({
        where: { status },
        order: { createdAt: 'DESC' },
      });
    } catch (error) {
      console.error('Error fetching ambulance requests by status:', error);
      throw new Error('Failed to fetch ambulance requests by status');
    }
  }

  async assignAmbulance(id: number, ambulanceId: number, assignedBy: number): Promise<AmbulanceRequest | null> {
    try {
      const updateData = {
        ambulanceId,
        assignedBy,
        assignedAt: new Date(),
        status: 'assigned' as const,
      };
      return await this.update(id, updateData);
    } catch (error) {
      console.error('Error assigning ambulance:', error);
      throw new Error('Failed to assign ambulance');
    }
  }

  async updateStatus(id: number, status: string): Promise<AmbulanceRequest | null> {
    try {
      const updateData = { status };
      if (status === 'completed') {
        updateData['completedAt'] = new Date();
      }
      return await this.update(id, updateData);
    } catch (error) {
      console.error('Error updating ambulance request status:', error);
      throw new Error('Failed to update ambulance request status');
    }
  }

  async getPendingRequests(): Promise<AmbulanceRequest[]> {
    return this.findByStatus('pending');
  }

  async getAssignedRequests(): Promise<AmbulanceRequest[]> {
    return this.findByStatus('assigned');
  }

  async getEmergencyRequests(): Promise<AmbulanceRequest[]> {
    try {
      return await this.ambulanceRequestRepository
        .createQueryBuilder('request')
        .where('request.status IN (:...statuses)', { statuses: ['pending', 'assigned'] })
        .orderBy('request.createdAt', 'DESC')
        .getMany();
    } catch (error) {
      console.error('Error fetching emergency requests:', error);
      throw new Error('Failed to fetch emergency requests');
    }
  }
}
