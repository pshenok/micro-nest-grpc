import { Module } from '@nestjs/common';
import { Logger } from './custom.logger.service';
import { ConfigModule } from '../config/config.module';

@Module({
    imports: [ConfigModule],
    providers: [Logger],
    exports: [Logger],
})
export class LoggerModule {}
