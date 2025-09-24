import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ClientsModule } from '@nestjs/microservices';
import { ApiModule } from './api/api.module';
import { DomainModule } from './domain/domain.module';
import { CoreModule } from './core/core.module';
import { InfraModule } from './infra/infra.module';
import { GrpcModule } from './grpc/grpc.module';
import { grpcOptions } from './grpc/grpc.options';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: process.env.NODE_ENV === 'test' ? '.env.test' : '.env',
    }),
    CoreModule,
    InfraModule,
    DomainModule,
    ApiModule,
    GrpcModule,
    // gRPC clients for testing
    ClientsModule.register([
      {
        name: 'USER_PACKAGE',
        ...grpcOptions('localhost', 5000),
      },
      {
        name: 'HEALTH_PACKAGE',
        ...grpcOptions('localhost', 5000),
      },
    ]),
  ],
})
export class AppModule {}
