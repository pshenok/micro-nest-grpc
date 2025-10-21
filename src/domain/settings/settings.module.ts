import { Module } from '@nestjs/common';
import { SettingsService } from './settings.service';
import { RepositoryModule } from '../../infra/database/repository.module';

@Module({
    imports: [RepositoryModule],
    providers: [SettingsService],
    exports: [SettingsService],
})
export class SettingsModule {}
