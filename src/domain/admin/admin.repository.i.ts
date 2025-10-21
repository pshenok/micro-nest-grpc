import { Admin } from './admin.entity';
import { CreateAdminDto, UpdateAdminDto } from './admin.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

export interface IAdminRepository {
    findById(id: string): Promise<Admin | null>;
    findByEmail(email: string): Promise<Admin | null>;
    create(data: CreateAdminDto): Promise<Admin>;
    update(id: string, data: UpdateAdminDto): Promise<Admin>;
    delete(id: string): Promise<void>;
    findAll(params: PaginationParams): Promise<PaginatedResult<Admin>>;
    count(): Promise<number>;
}
