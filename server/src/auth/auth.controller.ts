import {
  Controller,
  Post,
  Get,
  Put,
  Body,
  Param,
  HttpException,
  HttpStatus,
} from '@nestjs/common';
import { AuthService } from './auth.service';
import { User } from '../entities/user.entity';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(@Body() userData: {
    name: string;
    email: string;
    phoneNumber: string;
    password: string;
    nationalId: string;
    city?: string;
    state?: string;
    country?: string;
  }) {
    try {
      const user = await this.authService.register(userData);
      return {
        success: true,
        message: 'User registered successfully',
        user: user,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Post('login')
  async login(@Body() loginData: {
    emailOrPhone: string;
    password: string;
  }) {
    try {
      const user = await this.authService.login(
        loginData.emailOrPhone,
        loginData.password,
      );
      return {
        success: true,
        message: 'Login successful',
        user: user,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message,
        },
        HttpStatus.UNAUTHORIZED,
      );
    }
  }

  @Get('profile/:id')
  async getProfile(@Param('id') id: string) {
    try {
      const user = await this.authService.findById(parseInt(id));
      if (!user) {
        throw new HttpException(
          {
            success: false,
            message: 'User not found',
          },
          HttpStatus.NOT_FOUND,
        );
      }
      return {
        success: true,
        user: user,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message,
        },
        HttpStatus.INTERNAL_SERVER_ERROR,
      );
    }
  }

  @Put('profile/:id')
  async updateProfile(
    @Param('id') id: string,
    @Body() updateData: Partial<User>,
  ) {
    try {
      const user = await this.authService.updateProfile(parseInt(id), updateData);
      return {
        success: true,
        message: 'Profile updated successfully',
        user: user,
      };
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }

  @Put('change-password/:id')
  async changePassword(
    @Param('id') id: string,
    @Body() passwordData: { newPassword: string },
  ) {
    try {
      const success = await this.authService.changePassword(
        parseInt(id),
        passwordData.newPassword,
      );
      if (success) {
        return {
          success: true,
          message: 'Password changed successfully',
        };
      } else {
        throw new Error('Failed to change password');
      }
    } catch (error) {
      throw new HttpException(
        {
          success: false,
          message: error.message,
        },
        HttpStatus.BAD_REQUEST,
      );
    }
  }
}
