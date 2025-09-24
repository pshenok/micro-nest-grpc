import { User } from './user.entity';
import { CreateUserDto, UpdateUserDto } from './user.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

export interface IUserRepository {
    findById(id: string): Promise<User | null>;
    findByEmail(email: string): Promise<User | null>;
    create(data: CreateUserDto): Promise<User>;
    update(id: string, data: UpdateUserDto): Promise<User>;
    delete(id: string): Promise<void>;
    findAll(params: PaginationParams): Promise<PaginatedResult<User>>;
    count(): Promise<number>;
}
