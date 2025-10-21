import { Settings } from './settings.entity';
import { CreateSettingsDto, UpdateSettingsDto } from './settings.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

export interface ISettingsRepository {
    findById(id: string): Promise<Settings | null>;
    create(data: CreateSettingsDto): Promise<Settings>;
    update(id: string, data: UpdateSettingsDto): Promise<Settings>;
    delete(id: string): Promise<void>;
    findAll(params: PaginationParams): Promise<PaginatedResult<Settings>>;
    count(): Promise<number>;
}
