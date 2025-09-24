import { Module } from '@nestjs/common';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import { User } from '../../domain/user/user.entity';
import { UserRepository } from '../repository/user.repository';

@Module({
    imports: [MikroOrmModule.forFeature([User])],
    providers: [
        {
            provide: 'IUserRepository',
            useClass: UserRepository,
        },
    ],
    exports: ['IUserRepository'],
})
export class RepositoryModule {}
