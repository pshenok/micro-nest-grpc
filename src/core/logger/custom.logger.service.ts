import * as log4js from 'log4js';
import stringify from 'fast-safe-stringify';
import * as cls from 'cls-hooked';
import * as _ from 'lodash';
import { Injectable, LoggerService } from '@nestjs/common';
import { Config } from '../config/config';

@Injectable()
export class Logger implements LoggerService {
    private logger: log4js.Logger;
    private context: cls.Namespace;

    constructor(private readonly config: Config) {
        this.context = cls.createNamespace('app');
        const [appender, level = 'info'] = this.config.logger.loggingType.split(':');

        log4js.addLayout('json', () => (logEvent): string => stringify({
            ts: logEvent.startTime.getTime(),
            level: logEvent.level.levelStr,
            dataObj: typeof logEvent.data[0] === 'string' ? {data: logEvent.data[0]} : logEvent.data[0],
        }));

        log4js.configure({
            appenders: {
                default: { type: 'stdout', layout: { type: 'colored' } },
                json: { type: 'stdout', layout: { type: 'json' } },
            },
            categories: {
                default: { appenders: ['default'], level },
                json: { appenders: ['json'], level },
            },
            pm2: this.config.logger.pm2,
        });

        this.logger = log4js.getLogger(appender);
    }

    public log(message: string, data?: any): void {
        this.logger.info({ message, ...data });
    }

    public info(message: string, data?: any): void {
        this.logger.info({ message, ...data });
    }

    public warn(message: string, data?: any): void {
        this.logger.warn({ message, ...data });
    }

    public error(message: string, data?: any): void {
        this.logger.error({ message, ...data });
    }

    public debug(message: string, data?: any): void {
        this.logger.debug({ message, ...data });
    }
}
