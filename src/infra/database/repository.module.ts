import { Module } from '@nestjs/common';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import { User } from '../../domain/user/user.entity';
import { Admin } from '../../domain/admin/admin.entity';
import { UserRepository } from '../repository/user.repository';
import { AdminRepository } from '../repository/admin.repository';

@Module({
    imports: [MikroOrmModule.forFeature([User, Admin])],
    providers: [
        {
            provide: 'IUserRepository',
            useClass: UserRepository,
        },
        {
            provide: 'IAdminRepository',
            useClass: AdminRepository,
        },
    ],
    exports: ['IUserRepository', 'IAdminRepository'],
})
export class RepositoryModule {}
