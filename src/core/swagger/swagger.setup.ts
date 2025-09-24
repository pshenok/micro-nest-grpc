import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { INestApplication } from '@nestjs/common';

export const setup = async (app: INestApplication): Promise<void> => {
    const options = new DocumentBuilder()
        .setTitle('Health API Documentation')
        .setDescription('Health monitoring API (Business logic available via gRPC)')
        .setVersion('1.0')
        .addTag('Health', 'System health monitoring')
        .build();

    const document = SwaggerModule.createDocument(app, options);
    SwaggerModule.setup('docs', app, document, {
        customSiteTitle: 'Health API Docs',
    });
};
