import { Injectable } from '@nestjs/common';
import { EntityRepository } from '@mikro-orm/postgresql';
import { InjectRepository } from '@mikro-orm/nestjs';
import { ISettingsRepository } from '../../domain/settings/settings.repository.i';
import { Settings } from '../../domain/settings/settings.entity';
import { CreateSettingsDto, UpdateSettingsDto } from '../../domain/settings/settings.types';
import { PaginationParams, PaginatedResult } from '../../domain/domain.types';

@Injectable()
export class SettingsRepository implements ISettingsRepository {
    constructor(
        @InjectRepository(Settings)
        private readonly settingsRepository: EntityRepository<Settings>,
    ) {}

    async findById(id: string): Promise<Settings | null> {
        return this.settingsRepository.findOne({ id });
    }

    async create(data: CreateSettingsDto): Promise<Settings> {
        const settings = this.settingsRepository.create(data);
        await this.settingsRepository.getEntityManager().persistAndFlush(settings);
        return settings;
    }

    async update(id: string, data: UpdateSettingsDto): Promise<Settings> {
        const settings = await this.findById(id);
        if (!settings) {
            throw new Error('Settings not found');
        }

        this.settingsRepository.assign(settings, data);
        await this.settingsRepository.getEntityManager().flush();
        return settings;
    }

    async delete(id: string): Promise<void> {
        const settings = await this.findById(id);
        if (!settings) {
            throw new Error('Settings not found');
        }

        await this.settingsRepository.getEntityManager().removeAndFlush(settings);
    }

    async findAll(params: PaginationParams): Promise<PaginatedResult<Settings>> {
        const { skip = 0, take = 10, orderBy = { createdAt: 'desc' } } = params;

        const [data, total] = await this.settingsRepository.findAndCount(
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
        return this.settingsRepository.count();
    }
}
