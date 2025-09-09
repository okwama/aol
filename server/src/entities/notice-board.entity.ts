import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('NoticeBoard')
export class NoticeBoard {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ length: 191 })
  title: string;

  @Column({ length: 191 })
  content: string;

  @CreateDateColumn()
  createdAt: Date;

  @UpdateDateColumn()
  updatedAt: Date;
}
