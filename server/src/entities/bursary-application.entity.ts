import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('BursaryApplication')
export class BursaryApplication {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  childName: string;

  @Column()
  school: string;

  @Column('decimal', { precision: 10, scale: 2 })
  parentIncome: number;

  @Column({ default: 'pending' })
  status: string;

  @Column()
  applicationDate: Date;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;

  @Column({ nullable: true })
  notes: string;

  @Column({ nullable: true })
  userId: number;
}
