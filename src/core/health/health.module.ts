import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { MikroOrmHealthIndicator } from './mikro-orm.health';
import { DatabaseModule } from '../../infra/database/database.module';

@Module({
    imports: [
        TerminusModule,
        DatabaseModule,
    ],
    providers: [MikroOrmHealthIndicator],
    exports: [TerminusModule, MikroOrmHealthIndicator],
})
export class HealthModule {}
