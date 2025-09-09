import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('AmbulanceRequest')
export class AmbulanceRequest {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  userId: number;

  @Column({ nullable: true })
  ambulanceId: number;

  @Column({ length: 500 })
  purpose: string;

  @Column({ length: 500 })
  destination: string;

  @Column({ type: 'datetime', precision: 3 })
  startDate: Date;

  @Column({ type: 'datetime', precision: 3 })
  endDate: Date;

  @Column({ type: 'text', nullable: true })
  notes: string;

  @Column({ type: 'double', nullable: true })
  latitude: number;

  @Column({ type: 'double', nullable: true })
  longitude: number;

  @Column({ length: 500, nullable: true })
  address: string;

  @Column({
    type: 'enum',
    enum: ['pending', 'approved', 'rejected', 'assigned', 'completed', 'cancelled'],
    default: 'pending'
  })
  status: string;

  @Column({ nullable: true })
  assignedBy: number;

  @Column({ type: 'datetime', precision: 3, nullable: true })
  assignedAt: Date;

  @Column({ type: 'datetime', precision: 3, nullable: true })
  completedAt: Date;

  @CreateDateColumn({ type: 'datetime', precision: 3 })
  createdAt: Date;

  @UpdateDateColumn({ type: 'datetime', precision: 3 })
  updatedAt: Date;
}
