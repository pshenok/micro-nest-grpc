import { Injectable, Inject, ConflictException, NotFoundException } from '@nestjs/common';
import { IAdminRepository } from './admin.repository.i';
import { Admin } from './admin.entity';
import { CreateAdminDto, UpdateAdminDto } from './admin.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

@Injectable()
export class AdminService {
    constructor(
        @Inject('IAdminRepository')
        private readonly adminRepository: IAdminRepository,
    ) {}

    async findById(id: string): Promise<Admin> {
        const admin = await this.adminRepository.findById(id);
        if (!admin) {
            throw new NotFoundException('Admin not found');
        }
        return admin;
    }

    async findByEmail(email: string): Promise<Admin | null> {
        return this.adminRepository.findByEmail(email);
    }

    async create(data: CreateAdminDto): Promise<Admin> {
        const existingAdmin = await this.adminRepository.findByEmail(data.email);
        if (existingAdmin) {
            throw new ConflictException('Email already exists');
        }
        return this.adminRepository.create(data);
    }

    async update(id: string, data: UpdateAdminDto): Promise<Admin> {
        const admin = await this.findById(id);

        if (data.email && data.email !== admin.email) {
            const existingAdmin = await this.adminRepository.findByEmail(data.email);
            if (existingAdmin && existingAdmin.id !== id) {
                throw new ConflictException('Email already exists');
            }
        }

        return this.adminRepository.update(id, data);
    }

    async delete(id: string): Promise<void> {
        await this.findById(id);
        await this.adminRepository.delete(id);
    }

    async findAll(params?: PaginationParams): Promise<PaginatedResult<Admin>> {
        return this.adminRepository.findAll(params || {});
    }

    async getStats(): Promise<{ totalAdmins: number }> {
        const totalAdmins = await this.adminRepository.count();
        return { totalAdmins };
    }
}
