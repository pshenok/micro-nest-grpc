import { Module } from '@nestjs/common';
import { AdminService } from './admin.service';
import { RepositoryModule } from '../../infra/database/repository.module';

@Module({
    imports: [RepositoryModule],
    providers: [AdminService],
    exports: [AdminService],
})
export class AdminModule {}
