import { Injectable, Inject, ConflictException, NotFoundException } from '@nestjs/common';
import { IUserRepository } from './user.repository.i';
import { User } from './user.entity';
import { CreateUserDto, UpdateUserDto } from './user.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

@Injectable()
export class UserService {
    constructor(
        @Inject('IUserRepository')
        private readonly userRepository: IUserRepository,
    ) {}

    async findById(id: string): Promise<User> {
        const user = await this.userRepository.findById(id);
        if (!user) {
            throw new NotFoundException('User not found');
        }
        return user;
    }

    async findByEmail(email: string): Promise<User | null> {
        return this.userRepository.findByEmail(email);
    }

    async create(data: CreateUserDto): Promise<User> {
        const existingUser = await this.userRepository.findByEmail(data.email);
        if (existingUser) {
            throw new ConflictException('Email already exists');
        }
        return this.userRepository.create(data);
    }

    async update(id: string, data: UpdateUserDto): Promise<User> {
        const user = await this.findById(id);
        
        if (data.email && data.email !== user.email) {
            const existingUser = await this.userRepository.findByEmail(data.email);
            if (existingUser && existingUser.id !== id) {
                throw new ConflictException('Email already exists');
            }
        }
        
        return this.userRepository.update(id, data);
    }

    async delete(id: string): Promise<void> {
        await this.findById(id);
        await this.userRepository.delete(id);
    }

    async findAll(params?: PaginationParams): Promise<PaginatedResult<User>> {
        return this.userRepository.findAll(params || {});
    }

    async getStats(): Promise<{ totalUsers: number }> {
        const totalUsers = await this.userRepository.count();
        return { totalUsers };
    }
}
