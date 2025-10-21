import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { ISettingsRepository } from './settings.repository.i';
import { Settings } from './settings.entity';
import { CreateSettingsDto, UpdateSettingsDto } from './settings.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

@Injectable()
export class SettingsService {
    constructor(
        @Inject('ISettingsRepository')
        private readonly settingsRepository: ISettingsRepository,
    ) {}

    async findById(id: string): Promise<Settings> {
        const settings = await this.settingsRepository.findById(id);
        if (!settings) {
            throw new NotFoundException('Settings not found');
        }
        return settings;
    }

    async create(data: CreateSettingsDto): Promise<Settings> {
        return this.settingsRepository.create(data);
    }

    async update(id: string, data: UpdateSettingsDto): Promise<Settings> {
        await this.findById(id);
        return this.settingsRepository.update(id, data);
    }

    async delete(id: string): Promise<void> {
        await this.findById(id);
        await this.settingsRepository.delete(id);
    }

    async findAll(params?: PaginationParams): Promise<PaginatedResult<Settings>> {
        return this.settingsRepository.findAll(params || {});
    }

    async getStats(): Promise<{ totalSettings: number }> {
        const totalSettings = await this.settingsRepository.count();
        return { totalSettings };
    }
}
