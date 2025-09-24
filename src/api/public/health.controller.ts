import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import {
    HealthCheck,
    HealthCheckService,
} from '@nestjs/terminus';
import { MikroOrmHealthIndicator } from '../../core/health/mikro-orm.health';

@ApiTags('Health')
@Controller('health')
export class HealthController {
    constructor(
        private health: HealthCheckService,
        private db: MikroOrmHealthIndicator,
    ) {}

    @Get()
    @HealthCheck()
    @ApiOperation({ summary: 'Health check endpoint' })
    @ApiResponse({
        status: 200,
        description: 'Health check passed',
        schema: {
            type: 'object',
            properties: {
                status: { type: 'string', example: 'ok' },
                info: {
                    type: 'object',
                    properties: {
                        database: {
                            type: 'object',
                            properties: {
                                status: { type: 'string', example: 'up' }
                            }
                        }
                    }
                },
                error: { type: 'object' },
                details: { type: 'object' }
            }
        }
    })
    check() {
        return this.health.check([
            () => this.db.pingCheck('database'),
        ]);
    }
}
