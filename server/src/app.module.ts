import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { NoticeController } from './notice/notice.controller';
import { NoticeService } from './notice/notice.service';
import { UserController } from './user/user.controller';
import { UserService } from './user/user.service';
import { BursaryController } from './bursary/bursary.controller';
import { BursaryService } from './bursary/bursary.service';
import { AmbulanceController } from './ambulance/ambulance.controller';
import { AmbulanceService } from './ambulance/ambulance.service';
import { ActivityController } from './activity/activity.controller';
import { ActivityService } from './activity/activity.service';
import { DashboardController } from './dashboard/dashboard.controller';
import { DashboardService } from './dashboard/dashboard.service';
import { AuthController } from './auth/auth.controller';
import { AuthService } from './auth/auth.service';
import { User } from './entities/user.entity';
import { NoticeBoard } from './entities/notice-board.entity';
import { BursaryApplication } from './entities/bursary-application.entity';
import { AmbulanceRequest } from './entities/ambulance-request.entity';
import { Activity } from './entities/activity.entity';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: process.env.DB_HOST,
      port: parseInt(process.env.DB_PORT) || 3306,
      username: process.env.DB_USERNAME,
      password: process.env.DB_PASSWORD ,
      database: process.env.DB_DATABASE ,
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: false,
      logging: process.env.NODE_ENV === 'development',
      connectTimeout: 10000,
      acquireTimeout: 10000,
      retryAttempts: 3,
      retryDelay: 3000,
    }),
    TypeOrmModule.forFeature([User, NoticeBoard, BursaryApplication, AmbulanceRequest, Activity]),
  ],
  controllers: [
    NoticeController,
    UserController,
    BursaryController,
    AmbulanceController,
    ActivityController,
    DashboardController,
    AuthController,
  ],
  providers: [
    NoticeService,
    UserService,
    BursaryService,
    AmbulanceService,
    ActivityService,
    DashboardService,
    AuthService,
  ],
})
export class AppModule {}
