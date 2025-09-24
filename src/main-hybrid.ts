import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { MicroserviceOptions } from '@nestjs/microservices';
import { AppModule } from './app.module';
import { setup as setupSwagger } from './core/swagger/swagger.setup';
import { Logger } from './core/logger/custom.logger.service';
import { HttpExceptionFilter } from './core/filters/http-exception.filter';
import { Config } from './core/config/config';
import { grpcOptions } from './grpc/grpc.options';
import { GrpcExceptionInterceptor } from './grpc/interceptors/grpc-exception.interceptor';
import { GrpcLoggingInterceptor } from './grpc/interceptors/grpc-logging.interceptor';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);
    
    // Global prefix for REST API
    app.setGlobalPrefix('api');
    
    // Global pipes
    app.useGlobalPipes(
        new ValidationPipe({
            whitelist: true,
            transform: true,
            forbidNonWhitelisted: true,
        }),
    );
    
    // Global filters for HTTP
    app.useGlobalFilters(new HttpExceptionFilter());
    
    // CORS
    app.enableCors();
    
    // Swagger
    await setupSwagger(app);
    
    // Get services from the container
    const logger = app.get(Logger);
    const config = app.get(Config);
    
    // Configure gRPC microservice
    const grpcHost = config.grpc.host;
    const grpcPort = config.grpc.port;
    
    const microserviceOptions = grpcOptions(grpcHost, grpcPort) as MicroserviceOptions;
    app.connectMicroservice(microserviceOptions);
    
    // Apply global interceptors for gRPC
    const grpcExceptionInterceptor = app.get(GrpcExceptionInterceptor);
    const grpcLoggingInterceptor = app.get(GrpcLoggingInterceptor);
    
    app.useGlobalInterceptors(
        grpcLoggingInterceptor,
        grpcExceptionInterceptor,
    );
    
    // Start all microservices (gRPC)
    await app.startAllMicroservices();
    
    // Start HTTP server
    const httpPort = config.web.port;
    await app.listen(httpPort);
    
    logger.info(`Health API is running on: http://localhost:${httpPort}`);
    logger.info(`Health check endpoint: http://localhost:${httpPort}/api/health`);
    logger.info(`Swagger documentation: http://localhost:${httpPort}/docs`);
    logger.info(`gRPC server (full API) is running on: ${grpcHost}:${grpcPort}`);
}

bootstrap();
