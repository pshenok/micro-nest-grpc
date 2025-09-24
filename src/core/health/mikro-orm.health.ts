import { Injectable } from '@nestjs/common';
import { HealthIndicator, HealthIndicatorResult, HealthCheckError } from '@nestjs/terminus';
import { MikroORM } from '@mikro-orm/core';

@Injectable()
export class MikroOrmHealthIndicator extends HealthIndicator {
    constructor(private readonly orm: MikroORM) {
        super();
    }

    async pingCheck(key: string): Promise<HealthIndicatorResult> {
        try {
            const connection = this.orm.em.getConnection();
            await connection.execute('SELECT 1');
            return this.getStatus(key, true);
        } catch (error) {
            throw new HealthCheckError(
                'MikroORM health check failed',
                this.getStatus(key, false, { message: error.message }),
            );
        }
    }
}
