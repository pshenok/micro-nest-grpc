import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import { setup as setupSwagger } from './core/swagger/swagger.setup';
import { Logger } from './core/logger/custom.logger.service';
import { HttpExceptionFilter } from './core/filters/http-exception.filter';
import { Config } from './core/config/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Global prefix
  app.setGlobalPrefix('api');
  
  // Global pipes
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );
  
  // Global filters
  app.useGlobalFilters(new HttpExceptionFilter());
  
  // CORS
  app.enableCors();
  
  // Swagger
  await setupSwagger(app);
  
  // Get services from the container
  const logger = app.get(Logger);
  const config = app.get(Config);
  
  const port = config.web.port;
  
  await app.listen(port);
  
  logger.info(`Health API is running on: http://localhost:${port}`);
  logger.info(`Health check endpoint: http://localhost:${port}/api/health`);
  logger.info(`Swagger documentation: http://localhost:${port}/docs`);
  logger.info(`Note: Full business API available via gRPC on port ${config.grpc.port}`);
}

bootstrap();
