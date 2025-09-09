import { Entity, PrimaryGeneratedColumn, Column } from 'typeorm';

@Entity('activity')
export class Activity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ name: 'my_actitvity_id' })
  myActivityId: number;

  @Column({ length: 255 })
  name: string;

  @Column({ type: 'tinyint', width: 3 })
  status: number;

  @Column({ length: 200 })
  title: string;

  @Column({ type: 'text' })
  description: string;

  @Column({ length: 250 })
  location: string;

  @Column({ name: 'start_date', length: 100 })
  startDate: string;

  @Column({ name: 'end_date', length: 100 })
  endDate: string;

  @Column({ name: 'image_url', length: 200 })
  imageUrl: string;

  @Column({ name: 'user_id' })
  userId: number;

  @Column({ name: 'client_id' })
  clientId: number;

  @Column({ name: 'activity_type', length: 200 })
  activityType: string;

  @Column({ name: 'budget_total', type: 'decimal', precision: 11, scale: 2 })
  budgetTotal: number;
}
