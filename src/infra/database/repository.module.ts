import { Module } from '@nestjs/common';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import { User } from '../../domain/user/user.entity';
import { Settings } from '../../domain/settings/settings.entity';
import { UserRepository } from '../repository/user.repository';
import { SettingsRepository } from '../repository/settings.repository';

@Module({
    imports: [MikroOrmModule.forFeature([User, Settings])],
    providers: [
        {
            provide: 'IUserRepository',
            useClass: UserRepository,
        },
        {
            provide: 'ISettingsRepository',
            useClass: SettingsRepository,
        },
    ],
    exports: ['IUserRepository', 'ISettingsRepository'],
})
export class RepositoryModule {}
