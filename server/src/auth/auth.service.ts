import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities/user.entity';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async register(userData: {
    name: string;
    email: string;
    phoneNumber: string;
    password: string;
    nationalId: string;
    city?: string;
    state?: string;
    country?: string;
  }): Promise<User> {
    try {
      // Check if user already exists
      const existingUser = await this.findByEmailOrPhone(userData.email, userData.phoneNumber);
      if (existingUser) {
        throw new Error('User already exists with this email or phone number');
      }

      // Hash password
      const hashedPassword = await bcrypt.hash(userData.password, 10);

      // Create new user
      const user = this.userRepository.create({
        ...userData,
        password: hashedPassword,
        role: 'USER',
        status: 1,
        createdAt: new Date(),
        country: userData.country || 'Kenya',
      });

      const savedUser = await this.userRepository.save(user);
      
      // Remove password from response
      const { password, ...userWithoutPassword } = savedUser;
      return userWithoutPassword as User;
    } catch (error) {
      throw new Error(`Registration failed: ${error.message}`);
    }
  }

  async login(emailOrPhone: string, password: string): Promise<User> {
    try {
      const user = await this.findByEmailOrPhone(emailOrPhone, emailOrPhone);
      if (!user) {
        throw new Error('User not found');
      }

      // Verify password
      const isPasswordValid = await bcrypt.compare(password, user.password);
      if (!isPasswordValid) {
        throw new Error('Invalid password');
      }

      // Remove password from response
      const { password: _, ...userWithoutPassword } = user;
      return userWithoutPassword as User;
    } catch (error) {
      throw new Error(`Login failed: ${error.message}`);
    }
  }

  async findByEmailOrPhone(email: string, phone: string): Promise<User | null> {
    try {
      const user = await this.userRepository.findOne({
        where: [
          { email: email },
          { phoneNumber: phone }
        ]
      });
      return user;
    } catch (error) {
      return null;
    }
  }

  async findByEmail(email: string): Promise<User | null> {
    try {
      return await this.userRepository.findOne({ where: { email } });
    } catch (error) {
      return null;
    }
  }

  async findByPhone(phone: string): Promise<User | null> {
    try {
      return await this.userRepository.findOne({ where: { phoneNumber: phone } });
    } catch (error) {
      return null;
    }
  }

  async findById(id: number): Promise<User | null> {
    try {
      const user = await this.userRepository.findOne({ where: { id } });
      if (user) {
        const { password, ...userWithoutPassword } = user;
        return userWithoutPassword as User;
      }
      return null;
    } catch (error) {
      return null;
    }
  }

  async updateProfile(id: number, updateData: Partial<User>): Promise<User> {
    try {
      if (updateData.password) {
        updateData.password = await bcrypt.hash(updateData.password, 10);
      }

      await this.userRepository.update(id, updateData);
      return await this.findById(id);
    } catch (error) {
      throw new Error(`Profile update failed: ${error.message}`);
    }
  }

  async changePassword(id: number, newPassword: string): Promise<boolean> {
    try {
      const hashedPassword = await bcrypt.hash(newPassword, 10);
      await this.userRepository.update(id, { password: hashedPassword });
      return true;
    } catch (error) {
      return false;
    }
  }
}
