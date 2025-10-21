import { Module } from '@nestjs/common';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import { User } from '../../domain/user/user.entity';
import { Admin } from '../../domain/admin/admin.entity';
import mikroOrmConfig from '../../mikro-orm.config';

@Module({
    imports: [
        MikroOrmModule.forRoot(mikroOrmConfig),
        MikroOrmModule.forFeature([User, Admin]),
    ],
    exports: [MikroOrmModule],
})
export class DatabaseModule {}
