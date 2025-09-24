import { Module } from '@nestjs/common';
import { MikroOrmModule } from '@mikro-orm/nestjs';
import { User } from '../../domain/user/user.entity';
import mikroOrmConfig from '../../mikro-orm.config';

@Module({
    imports: [
        MikroOrmModule.forRoot(mikroOrmConfig),
        MikroOrmModule.forFeature([User]),
    ],
    exports: [MikroOrmModule],
})
export class DatabaseModule {}
