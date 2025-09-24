import { Injectable } from '@nestjs/common';
import { GrpcMethod } from '@nestjs/microservices';
import { Metadata } from '@grpc/grpc-js';
import {
    HealthCheckService,
} from '@nestjs/terminus';
import { MikroOrmHealthIndicator } from '../../core/health/mikro-orm.health';

@Injectable()
export class HealthGrpcService {
    constructor(
        private health: HealthCheckService,
        private db: MikroOrmHealthIndicator,
    ) {}

    @GrpcMethod('HealthService', 'Check')
    async check(data: any, metadata: Metadata): Promise<any> {
        const healthResult = await this.health.check([
            () => this.db.pingCheck('database'),
        ]);

        const services: { [key: string]: string } = {};
        
        if (healthResult.details) {
            for (const [key, value] of Object.entries(healthResult.details)) {
                services[key] = (value as any).status || 'unknown';
            }
        }

        return {
            status: healthResult.status,
            services,
        };
    }
}
