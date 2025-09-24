import { Module } from '@nestjs/common';
import { DatabaseModule } from './database/database.module';
import { RepositoryModule } from './database/repository.module';

@Module({
    imports: [DatabaseModule, RepositoryModule],
    exports: [DatabaseModule, RepositoryModule],
})
export class InfraModule {}
