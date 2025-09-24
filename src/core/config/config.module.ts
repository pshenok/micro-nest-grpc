import { Module } from '@nestjs/common';
import { Config } from './config';
import { ConfigModule as NestConfigModule } from '@nestjs/config';

@Module({
    imports: [NestConfigModule.forRoot()],
    providers: [Config],
    exports: [Config],
})
export class ConfigModule {}
