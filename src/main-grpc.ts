import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions } from '@nestjs/microservices';
import { AppModule } from './app.module';
import { grpcOptions } from './grpc/grpc.options';
import { Logger } from './core/logger/custom.logger.service';
import { Config } from './core/config/config';
import { GrpcExceptionInterceptor } from './grpc/interceptors/grpc-exception.interceptor';
import { GrpcLoggingInterceptor } from './grpc/interceptors/grpc-logging.interceptor';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);
    
    const config = app.get(Config);
    const logger = app.get(Logger);
    
    // Configure gRPC microservice
    const grpcHost = config.grpc.host;
    const grpcPort = config.grpc.port;
    
    const microserviceOptions = grpcOptions(grpcHost, grpcPort) as MicroserviceOptions;
    app.connectMicroservice(microserviceOptions);
    
    // Apply global interceptors
    const grpcExceptionInterceptor = app.get(GrpcExceptionInterceptor);
    const grpcLoggingInterceptor = app.get(GrpcLoggingInterceptor);
    
    app.useGlobalInterceptors(
        grpcLoggingInterceptor,
        grpcExceptionInterceptor,
    );
    
    await app.startAllMicroservices();
    
    logger.info(`gRPC server is running on: ${grpcHost}:${grpcPort}`);
}

bootstrap();
