import { Module } from '@nestjs/common';
import { UserModule } from './user/user.module';
import { SettingsModule } from './settings/settings.module';

@Module({
    imports: [UserModule, SettingsModule],
    exports: [UserModule, SettingsModule],
})
export class DomainModule {}
