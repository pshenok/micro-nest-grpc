import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';
import { HealthModule } from '../../core/health/health.module';
import { DatabaseModule } from '../../infra/database/database.module';

@Module({
    imports: [
        HealthModule,
        DatabaseModule,
    ],
    controllers: [HealthController],
})
export class PublicModule {}
