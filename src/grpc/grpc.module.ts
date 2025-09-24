import { Module } from '@nestjs/common';
import { UserGrpcService } from './services/user.grpc.service';
import { HealthGrpcService } from './services/health.grpc.service';
import { DomainModule } from '../domain/domain.module';
import { HealthModule } from '../core/health/health.module';
import { LoggerModule } from '../core/logger/logger.module';
import { DatabaseModule } from '../infra/database/database.module';
import { GrpcExceptionInterceptor } from './interceptors/grpc-exception.interceptor';
import { GrpcLoggingInterceptor } from './interceptors/grpc-logging.interceptor';

@Module({
    imports: [
        DomainModule,
        HealthModule,
        LoggerModule,
        DatabaseModule,
    ],
    providers: [
        UserGrpcService,
        HealthGrpcService,
        GrpcExceptionInterceptor,
        GrpcLoggingInterceptor,
    ],
})
export class GrpcModule {}
