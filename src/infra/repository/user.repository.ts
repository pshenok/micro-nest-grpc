import { Injectable } from '@nestjs/common';
import { EntityRepository } from '@mikro-orm/postgresql';
import { InjectRepository } from '@mikro-orm/nestjs';
import { IUserRepository } from '../../domain/user/user.repository.i';
import { User } from '../../domain/user/user.entity';
import { CreateUserDto, UpdateUserDto } from '../../domain/user/user.types';
import { PaginationParams, PaginatedResult } from '../../domain/domain.types';

@Injectable()
export class UserRepository implements IUserRepository {
    constructor(
        @InjectRepository(User)
        private readonly userRepository: EntityRepository<User>,
    ) {}

    async findById(id: string): Promise<User | null> {
        return this.userRepository.findOne({ id });
    }

    async findByEmail(email: string): Promise<User | null> {
        return this.userRepository.findOne({ email });
    }

    async create(data: CreateUserDto): Promise<User> {
        const user = this.userRepository.create(data);
        await this.userRepository.getEntityManager().persistAndFlush(user);
        return user;
    }

    async update(id: string, data: UpdateUserDto): Promise<User> {
        const user = await this.findById(id);
        if (!user) {
            throw new Error('User not found');
        }
        
        this.userRepository.assign(user, data);
        await this.userRepository.getEntityManager().flush();
        return user;
    }

    async delete(id: string): Promise<void> {
        const user = await this.findById(id);
        if (!user) {
            throw new Error('User not found');
        }
        
        await this.userRepository.getEntityManager().removeAndFlush(user);
    }

    async findAll(params: PaginationParams): Promise<PaginatedResult<User>> {
        const { skip = 0, take = 10, orderBy = { createdAt: 'desc' } } = params;

        const [data, total] = await this.userRepository.findAndCount(
            {},
            {
                limit: take,
                offset: skip,
                orderBy: orderBy as any,
            },
        );

        return {
            data,
            total,
            skip,
            take,
        };
    }

    async count(): Promise<number> {
        return this.userRepository.count();
    }
}
