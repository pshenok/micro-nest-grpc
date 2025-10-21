import { Injectable } from '@nestjs/common';
import { EntityRepository } from '@mikro-orm/postgresql';
import { InjectRepository } from '@mikro-orm/nestjs';
import { IAdminRepository } from '../../domain/admin/admin.repository.i';
import { Admin } from '../../domain/admin/admin.entity';
import { CreateAdminDto, UpdateAdminDto } from '../../domain/admin/admin.types';
import { PaginationParams, PaginatedResult } from '../../domain/domain.types';

@Injectable()
export class AdminRepository implements IAdminRepository {
    constructor(
        @InjectRepository(Admin)
        private readonly adminRepository: EntityRepository<Admin>,
    ) {}

    async findById(id: string): Promise<Admin | null> {
        return this.adminRepository.findOne({ id });
    }

    async findByEmail(email: string): Promise<Admin | null> {
        return this.adminRepository.findOne({ email });
    }

    async create(data: CreateAdminDto): Promise<Admin> {
        const admin = this.adminRepository.create(data);
        await this.adminRepository.getEntityManager().persistAndFlush(admin);
        return admin;
    }

    async update(id: string, data: UpdateAdminDto): Promise<Admin> {
        const admin = await this.findById(id);
        if (!admin) {
            throw new Error('Admin not found');
        }

        this.adminRepository.assign(admin, data);
        await this.adminRepository.getEntityManager().flush();
        return admin;
    }

    async delete(id: string): Promise<void> {
        const admin = await this.findById(id);
        if (!admin) {
            throw new Error('Admin not found');
        }

        await this.adminRepository.getEntityManager().removeAndFlush(admin);
    }

    async findAll(params: PaginationParams): Promise<PaginatedResult<Admin>> {
        const { skip = 0, take = 10, orderBy = { createdAt: 'desc' } } = params;

        const [data, total] = await this.adminRepository.findAndCount(
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
        return this.adminRepository.count();
    }
}
