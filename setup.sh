#!/bin/bash

# Setup NestJS Clean Architecture with MikroORM and gRPC
# This script creates a complete project structure with MikroORM instead of Prisma

set -e

echo "🚀 Setting up NestJS Clean Architecture with MikroORM and gRPC..."

# Create project directory
PROJECT_NAME="mikro-nest-grpc"

# Create directory structure
mkdir -p src/api/public
mkdir -p src/core/config
mkdir -p src/core/filters
mkdir -p src/core/health
mkdir -p src/core/logger
mkdir -p src/core/swagger
mkdir -p src/domain/user
mkdir -p src/grpc/interceptors
mkdir -p src/grpc/services
mkdir -p src/grpc/generated
mkdir -p src/infra/database
mkdir -p src/infra/repository
mkdir -p src/common/interfaces
mkdir -p src/migrations
mkdir -p test
mkdir -p scripts
mkdir -p protos

# Create package.json
cat > package.json << 'EOF'
{
  "name": "mikro-nest-grpc",
  "version": "1.0.0",
  "description": "NestJS Clean Architecture API with MikroORM and gRPC",
  "author": "",
  "private": true,
  "main": "dist/main.js",
  "scripts": {
    "build": "nest build",
    "format": "prettier --write \"src/**/*.ts\" \"test/**/*.ts\"",
    "start": "nest start",
    "start:dev": "nest start --watch",
    "start:debug": "nest start --debug --watch",
    "start:prod": "node dist/main-hybrid",
    "start:rest": "node dist/main",
    "start:health": "node dist/main",
    "start:grpc": "node dist/main-grpc",
    "lint": "eslint \"{src,apps,libs,test}/**/*.ts\" --fix",
    "test": "jest",
    "test:watch": "jest --watch",
    "test:cov": "jest --coverage",
    "test:debug": "node --inspect-brk -r tsconfig-paths/register -r ts-node/register node_modules/.bin/jest --runInBand",
    "test:e2e": "jest --config ./test/jest-e2e.json",
    "migration:create": "mikro-orm migration:create",
    "migration:up": "mikro-orm migration:up",
    "migration:down": "mikro-orm migration:down",
    "schema:create": "mikro-orm schema:create",
    "schema:update": "mikro-orm schema:update",
    "proto:generate": "sh scripts/generate-protos.sh",
    "grpc:client": "ts-node scripts/grpc-client-example.ts",
    "docker:build": "docker-compose build",
    "docker:up": "docker-compose up",
    "docker:down": "docker-compose down"
  },
  "dependencies": {
    "@grpc/grpc-js": "^1.12.4",
    "@grpc/proto-loader": "^0.7.13",
    "@mikro-orm/core": "^6.4.0",
    "@mikro-orm/nestjs": "^6.0.2",
    "@mikro-orm/postgresql": "^6.4.0",
    "@mikro-orm/reflection": "^6.4.0",
    "@nestjs/common": "^11.1.5",
    "@nestjs/config": "^4.0.2",
    "@nestjs/core": "^11.1.5",
    "@nestjs/microservices": "^11.1.5",
    "@nestjs/platform-express": "^11.1.5",
    "@nestjs/swagger": "^11.2.0",
    "@nestjs/terminus": "^11.0.0",
    "class-transformer": "^0.5.1",
    "class-validator": "^0.14.2",
    "cls-hooked": "^4.2.2",
    "fast-safe-stringify": "^2.1.1",
    "log4js": "^6.9.1",
    "lodash": "^4.17.21",
    "reflect-metadata": "^0.2.2",
    "rxjs": "^7.8.2",
    "swagger-ui-express": "^5.0.1",
    "uuid": "^11.0.5"
  },
  "devDependencies": {
    "@mikro-orm/cli": "^6.4.0",
    "@mikro-orm/migrations": "^6.4.0",
    "@mikro-orm/seeder": "^6.4.0",
    "@nestjs/cli": "^11.0.7",
    "@nestjs/schematics": "^11.0.5",
    "@nestjs/testing": "^11.1.5",
    "@types/cls-hooked": "^4.3.9",
    "@types/express": "^5.0.3",
    "@types/jest": "^29.5.14",
    "@types/lodash": "^4.17.20",
    "@types/node": "^20.19.9",
    "@types/supertest": "^6.0.3",
    "@types/uuid": "^10.0.0",
    "@typescript-eslint/eslint-plugin": "^7.18.0",
    "@typescript-eslint/parser": "^7.18.0",
    "eslint": "^8.56.0",
    "eslint-config-prettier": "^9.1.0",
    "eslint-plugin-prettier": "^5.5.3",
    "grpc-tools": "^1.12.4",
    "jest": "^29.7.0",
    "prettier": "^3.6.2",
    "source-map-support": "^0.5.21",
    "supertest": "^7.1.3",
    "ts-jest": "^29.4.0",
    "ts-loader": "^9.5.2",
    "ts-node": "^10.9.2",
    "ts-proto": "^2.6.0",
    "tsconfig-paths": "^4.2.0",
    "typescript": "^5.8.3"
  },
  "jest": {
    "moduleFileExtensions": ["js", "json", "ts"],
    "rootDir": "src",
    "testRegex": ".*\\.spec\\.ts$",
    "transform": {
      "^.+\\.(t|j)s$": "ts-jest"
    },
    "collectCoverageFrom": ["**/*.(t|j)s"],
    "coverageDirectory": "../coverage",
    "testEnvironment": "node"
  },
  "mikro-orm": {
    "useTsNode": true,
    "configPaths": [
      "./src/mikro-orm.config.ts",
      "./dist/mikro-orm.config.js"
    ]
  }
}
EOF

# Create tsconfig.json
cat > tsconfig.json << 'EOF'
{
  "compilerOptions": {
    "module": "commonjs",
    "declaration": true,
    "removeComments": true,
    "emitDecoratorMetadata": true,
    "experimentalDecorators": true,
    "allowSyntheticDefaultImports": true,
    "target": "ES2021",
    "sourceMap": true,
    "outDir": "./dist",
    "baseUrl": "./",
    "incremental": true,
    "skipLibCheck": true,
    "strictNullChecks": false,
    "noImplicitAny": false,
    "strictBindCallApply": false,
    "forceConsistentCasingInFileNames": false,
    "noFallthroughCasesInSwitch": false,
    "paths": {
      "@domain/*": ["src/domain/*"],
      "@infra/*": ["src/infra/*"],
      "@core/*": ["src/core/*"],
      "@api/*": ["src/api/*"],
      "@grpc/*": ["src/grpc/*"],
      "@common/*": ["src/common/*"]
    }
  }
}
EOF

# Create tsconfig.build.json
cat > tsconfig.build.json << 'EOF'
{
  "extends": "./tsconfig.json",
  "exclude": ["node_modules", "test", "dist", "**/*spec.ts", "scripts", "**/*.e2e-spec.ts"]
}
EOF

# Create nest-cli.json
cat > nest-cli.json << 'EOF'
{
  "$schema": "https://json.schemastore.org/nest-cli",
  "collection": "@nestjs/schematics",
  "sourceRoot": "src",
  "compilerOptions": {
    "deleteOutDir": true,
    "assets": [
      {
        "include": "grpc/protos/*.proto",
        "watchAssets": true
      }
    ]
  }
}
EOF

# Create .env.example
cat > .env.example << 'EOF'
# Application
NODE_ENV=development
TZ=UTC

# Web Server
WEB_HOST=localhost
WEB_PORT=3000
BODY_LIMIT=10485760

# gRPC Server
GRPC_HOST=localhost
GRPC_PORT=5000

# Database
DB_HOST=localhost
DB_PORT=5432
DB_NAME=myapp
DB_USER=user
DB_PASSWORD=password
DATABASE_URL=postgresql://user:password@localhost:5432/myapp

# Logging
LOGGING_TYPE=json
IS_PM2=false
EOF

# Create .gitignore
cat > .gitignore << 'EOF'
# compiled output
/dist
/node_modules

# Logs
logs
*.log
npm-debug.log*
pnpm-debug.log*
yarn-debug.log*
yarn-error.log*
lerna-debug.log*

# OS
.DS_Store

# Tests
/coverage
/.nyc_output

# IDEs and editors
/.idea
.project
.classpath
.c9/
*.launch
.settings/
*.sublime-workspace

# IDE - VSCode
.vscode/*
!.vscode/settings.json
!.vscode/tasks.json
!.vscode/launch.json
!.vscode/extensions.json

# Environment
.env
.env.local
.env.development
.env.production

# MikroORM
temp/

# gRPC generated files
src/grpc/generated/

update.sh
EOF

# Create .dockerignore
cat > .dockerignore << 'EOF'
node_modules
dist
.git
.gitignore
README.md
.env
.env.*
!.env.example
coverage
.nyc_output
.DS_Store
*.log
.vscode
.idea
EOF

# Create .eslintrc.js
cat > .eslintrc.js << 'EOF'
module.exports = {
  parser: '@typescript-eslint/parser',
  parserOptions: {
    project: 'tsconfig.json',
    tsconfigRootDir: __dirname,
    sourceType: 'module',
  },
  plugins: ['@typescript-eslint/eslint-plugin'],
  extends: [
    'plugin:@typescript-eslint/recommended',
    'plugin:prettier/recommended',
  ],
  root: true,
  env: {
    node: true,
    jest: true,
  },
  ignorePatterns: ['.eslintrc.js', 'src/grpc/generated/**'],
  rules: {
    '@typescript-eslint/interface-name-prefix': 'off',
    '@typescript-eslint/explicit-function-return-type': 'off',
    '@typescript-eslint/explicit-module-boundary-types': 'off',
    '@typescript-eslint/no-explicit-any': 'off',
  },
};
EOF

# Create .prettierrc
cat > .prettierrc << 'EOF'
{
  "singleQuote": true,
  "trailingComma": "all",
  "printWidth": 100,
  "tabWidth": 2,
  "semi": true,
  "bracketSpacing": true,
  "arrowParens": "always",
  "endOfLine": "lf"
}
EOF

# Create Dockerfile
cat > Dockerfile << 'EOF'
# Build stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Generate proto files
RUN npm run proto:generate

# Build the application
RUN npm run build

# Production stage
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install production dependencies only
RUN npm ci --only=production

# Copy built application
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/protos ./protos

# Expose ports
EXPOSE 3000 5000

# Start the application
CMD ["node", "dist/main-hybrid.js"]
EOF

# Create docker-compose.yml
cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  postgres:
    image: postgres:17-alpine
    container_name: nest-mikroorm-postgres
    environment:
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
      POSTGRES_DB: myapp
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
    networks:
      - app-network
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user -d myapp"]
      interval: 10s
      timeout: 5s
      retries: 5

  app:
    build: .
    container_name: nest-mikroorm-app
    environment:
      NODE_ENV: production
      DB_HOST: postgres
      DB_PORT: 5432
      DB_NAME: myapp
      DB_USER: user
      DB_PASSWORD: password
      DATABASE_URL: "postgresql://user:password@postgres:5432/myapp"
      WEB_HOST: 0.0.0.0
      WEB_PORT: 3000
      GRPC_HOST: 0.0.0.0
      GRPC_PORT: 5000
    ports:
      - "3000:3000"  # REST API
      - "5000:5000"  # gRPC
    depends_on:
      postgres:
        condition: service_healthy
    networks:
      - app-network
    command: >
      sh -c "
        npm run schema:update &&
        node dist/main-hybrid.js
      "

volumes:
  postgres_data:

networks:
  app-network:
    driver: bridge
EOF

# Create proto files
cat > protos/health.proto << 'EOF'
syntax = "proto3";

package health;

service HealthService {
  rpc Check (HealthCheckRequest) returns (HealthCheckResponse);
}

message HealthCheckRequest {}

message HealthCheckResponse {
  string status = 1;
  map<string, string> services = 2;
}
EOF

cat > protos/user.proto << 'EOF'
syntax = "proto3";

package user;

service UserService {
  rpc CreateUser (CreateUserRequest) returns (UserResponse);
  rpc GetUser (GetUserRequest) returns (UserResponse);
  rpc GetUsers (GetUsersRequest) returns (GetUsersResponse);
  rpc UpdateUser (UpdateUserRequest) returns (UserResponse);
  rpc DeleteUser (DeleteUserRequest) returns (DeleteUserResponse);
  rpc GetUserStats (Empty) returns (UserStatsResponse);
}

message Empty {}

message User {
  string id = 1;
  string fullName = 2;
  string email = 3;
  string createdAt = 4;
  string updatedAt = 5;
}

message CreateUserRequest {
  string fullName = 1;
  string email = 2;
}

message GetUserRequest {
  string id = 1;
}

message GetUsersRequest {
  int32 skip = 1;
  int32 take = 2;
}

message GetUsersResponse {
  repeated User users = 1;
  int32 total = 2;
  int32 skip = 3;
  int32 take = 4;
}

message UpdateUserRequest {
  string id = 1;
  optional string fullName = 2;
  optional string email = 3;
}

message DeleteUserRequest {
  string id = 1;
}

message DeleteUserResponse {
  bool success = 1;
}

message UserResponse {
  User user = 1;
}

message UserStatsResponse {
  int32 totalUsers = 1;
}
EOF

# Create scripts/generate-protos.sh
cat > scripts/generate-protos.sh << 'EOF'
#!/bin/bash

PROTO_DIR=./protos
OUT_DIR=./src/grpc/generated

# Create output directory if it doesn't exist
mkdir -p $OUT_DIR

# Check if ts-proto is installed
if ! command -v npx ts-proto &> /dev/null; then
    echo "Installing ts-proto..."
    npm install -D ts-proto
fi

# Generate TypeScript code from proto files
echo "Generating TypeScript from proto files..."
npx ts-proto \
  --proto_path=$PROTO_DIR \
  --ts_proto_out=$OUT_DIR \
  --ts_proto_opt=nestJs=true \
  --ts_proto_opt=addGrpcMetadata=true \
  --ts_proto_opt=addNestjsRestParameter=true \
  $PROTO_DIR/*.proto

echo "Proto files generated successfully!"
EOF

chmod +x scripts/generate-protos.sh

# Create MikroORM configuration
cat > src/mikro-orm.config.ts << 'EOF'
import { Options } from '@mikro-orm/core';
import { PostgreSqlDriver } from '@mikro-orm/postgresql';
import { TsMorphMetadataProvider } from '@mikro-orm/reflection';
import { User } from './domain/user/user.entity';

const config: Options = {
  driver: PostgreSqlDriver,
  host: process.env.DB_HOST || 'localhost',
  port: parseInt(process.env.DB_PORT || '5432'),
  user: process.env.DB_USER || 'user',
  password: process.env.DB_PASSWORD || 'password',
  dbName: process.env.DB_NAME || 'myapp',
  entities: [User],
  entitiesTs: ['./src/domain/**/*.entity.ts'],
  metadataProvider: TsMorphMetadataProvider,
  debug: process.env.NODE_ENV !== 'production',
  migrations: {
    path: './dist/migrations',
    pathTs: './src/migrations',
    glob: '!(*.d).{js,ts}',
  },
  schemaGenerator: {
    disableForeignKeys: false,
    createForeignKeyConstraints: true,
  },
};

export default config;
EOF

# Create User Entity with MikroORM
cat > src/domain/user/user.entity.ts << 'EOF'
import { Entity, PrimaryKey, Property, Unique } from '@mikro-orm/core';
import { v4 as uuid } from 'uuid';
import { BaseEntity } from '../domain.types';

@Entity({ tableName: 'users' })
export class User implements BaseEntity {
  @PrimaryKey()
  id: string = uuid();

  @Property({ columnType: 'varchar(255)' })
  fullName!: string;

  @Property({ columnType: 'varchar(255)' })
  @Unique()
  email!: string;

  @Property({ onCreate: () => new Date() })
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  updatedAt: Date = new Date();
}
EOF

# Create domain types
cat > src/domain/domain.types.ts << 'EOF'
export interface PaginationParams {
    skip?: number;
    take?: number;
    orderBy?: Record<string, 'asc' | 'desc'>;
}

export interface PaginatedResult<T> {
    data: T[];
    total: number;
    skip: number;
    take: number;
}

export interface BaseEntity {
    id: string;
    createdAt: Date;
    updatedAt: Date;
}
EOF

# Create user types
cat > src/domain/user/user.types.ts << 'EOF'
export interface CreateUserDto {
    fullName: string;
    email: string;
}

export interface UpdateUserDto {
    fullName?: string;
    email?: string;
}
EOF

# Create user repository interface
cat > src/domain/user/user.repository.i.ts << 'EOF'
import { User } from './user.entity';
import { CreateUserDto, UpdateUserDto } from './user.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

export interface IUserRepository {
    findById(id: string): Promise<User | null>;
    findByEmail(email: string): Promise<User | null>;
    create(data: CreateUserDto): Promise<User>;
    update(id: string, data: UpdateUserDto): Promise<User>;
    delete(id: string): Promise<void>;
    findAll(params: PaginationParams): Promise<PaginatedResult<User>>;
    count(): Promise<number>;
}
EOF

# Create user service
cat > src/domain/user/user.service.ts << 'EOF'
import { Injectable, Inject, ConflictException, NotFoundException } from '@nestjs/common';
import { IUserRepository } from './user.repository.i';
import { User } from './user.entity';
import { CreateUserDto, UpdateUserDto } from './user.types';
import { PaginationParams, PaginatedResult } from '../domain.types';

@Injectable()
export class UserService {
    constructor(
        @Inject('IUserRepository')
        private readonly userRepository: IUserRepository,
    ) {}

    async findById(id: string): Promise<User> {
        const user = await this.userRepository.findById(id);
        if (!user) {
            throw new NotFoundException('User not found');
        }
        return user;
    }

    async findByEmail(email: string): Promise<User | null> {
        return this.userRepository.findByEmail(email);
    }

    async create(data: CreateUserDto): Promise<User> {
        const existingUser = await this.userRepository.findByEmail(data.email);
        if (existingUser) {
            throw new ConflictException('Email already exists');
        }
        return this.userRepository.create(data);
    }

    async update(id: string, data: UpdateUserDto): Promise<User> {
        const user = await this.findById(id);
        
        if (data.email && data.email !== user.email) {
            const existingUser = await this.userRepository.findByEmail(data.email);
            if (existingUser && existingUser.id !== id) {
                throw new ConflictException('Email already exists');
            }
        }
        
        return this.userRepository.update(id, data);
    }

    async delete(id: string): Promise<void> {
        await this.findById(id);
        await this.userRepository.delete(id);
    }

    async findAll(params?: PaginationParams): Promise<PaginatedResult<User>> {
        return this.userRepository.findAll(params || {});
    }

    async getStats(): Promise<{ totalUsers: number }> {
        const totalUsers = await this.userRepository.count();
        return { totalUsers };
    }
}
EOF

# Create user module
cat > src/domain/user/user.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { UserService } from './user.service';
import { RepositoryModule } from '../../infra/database/repository.module';

@Module({
    imports: [RepositoryModule],
    providers: [UserService],
    exports: [UserService],
})
export class UserModule {}
EOF

# Create domain module
cat > src/domain/domain.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { UserModule } from './user/user.module';

@Module({
    imports: [UserModule],
    exports: [UserModule],
})
export class DomainModule {}
EOF

# Create MikroORM user repository implementation
cat > src/infra/repository/user.repository.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { EntityRepository } from '@mikro-orm/postgresql';
import { InjectRepository } from '@mikro-orm/nestjs';
import { IUserRepository } from '../../domain/user/user.repository.i';
import { User } from '../../domain/user/user.entity';
import { CreateUserDto, UpdateUserDto } from '../../domain/user/user.types';
import { PaginationParams, PaginatedResult } from '../../domain/domain.types';

@Injectable()
export class UserRepository implements IUserRepository {
    constructor(
        @InjectRepository(User)
        private readonly userRepository: EntityRepository<User>,
    ) {}

    async findById(id: string): Promise<User | null> {
        return this.userRepository.findOne({ id });
    }

    async findByEmail(email: string): Promise<User | null> {
        return this.userRepository.findOne({ email });
    }

    async create(data: CreateUserDto): Promise<User> {
        const user = this.userRepository.create(data);
        await this.userRepository.getEntityManager().persistAndFlush(user);
        return user;
    }

    async update(id: string, data: UpdateUserDto): Promise<User> {
        const user = await this.findById(id);
        if (!user) {
            throw new Error('User not found');
        }
        
        this.userRepository.assign(user, data);
        await this.userRepository.getEntityManager().flush();
        return user;
    }

    async delete(id: string): Promise<void> {
        const user = await this.findById(id);
        if (!user) {
            throw new Error('User not found');
        }
        
        await this.userRepository.getEntityManager().removeAndFlush(user);
    }

    async findAll(params: PaginationParams): Promise<PaginatedResult<User>> {
        const { skip = 0, take = 10, orderBy = { createdAt: 'desc' } } = params;

        const [data, total] = await this.userRepository.findAndCount(
            {},
            {
                limit: take,
                offset: skip,
                orderBy: orderBy as any,
            },
        );

        return {
            data,
            total,
            skip,
            take,
        };
    }

    async count(): Promise<number> {
        return this.userRepository.count();
    }
}
EOF

# Create database module with MikroORM
cat > src/infra/database/database.module.ts << 'EOF'
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
EOF

# Create repository module
cat > src/infra/database/repository.module.ts << 'EOF'
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
EOF

# Create infra module
cat > src/infra/infra.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { DatabaseModule } from './database/database.module';
import { RepositoryModule } from './database/repository.module';

@Module({
    imports: [DatabaseModule, RepositoryModule],
    exports: [DatabaseModule, RepositoryModule],
})
export class InfraModule {}
EOF

# Create core configuration files
cat > src/core/config/config.abstract.ts << 'EOF'
export abstract class AbstractConfig {
    protected getNumber(key: string, defaultValue?: number): number {
        const value = process.env[key];
        if (value === undefined) {
            if (defaultValue !== undefined) {
                return defaultValue;
            }
            throw new TypeError(`Config key "${key}" MUST contain valid number. Got undefined`);
        }
        const num = Number(value);
        if (Number.isFinite(num)) {
            return num;
        }
        throw new TypeError(`Config key "${key}" MUST contain valid number. Got "${value}"`);
    }

    protected getString(key: string, defaultValue?: string): string {
        const value = process.env[key];
        if (value === undefined) {
            if (defaultValue !== undefined) {
                return defaultValue;
            }
            throw new TypeError(`Config key "${key}" MUST contain string. Got undefined`);
        }
        return value;
    }

    protected getBoolean(key: string, defaultValue?: boolean): boolean {
        const value = process.env[key];
        if (value === undefined) {
            if (defaultValue !== undefined) {
                return defaultValue;
            }
            throw new TypeError(`Config key "${key}" MUST contain valid boolean. Got undefined`);
        }
        if (value === 'true') return true;
        if (value === 'false') return false;
        throw new TypeError(`Config key "${key}" MUST contain valid boolean. Got "${value}"`);
    }
}
EOF

cat > src/core/config/config.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { AbstractConfig } from './config.abstract';

@Injectable()
export class Config extends AbstractConfig {
    public env = this.getString('NODE_ENV', 'development');
    public tz = this.getString('TZ', 'UTC');

    public web = {
        host: this.getString('WEB_HOST', 'localhost'),
        port: this.getNumber('WEB_PORT', 3000),
        bodyLimit: this.getNumber('BODY_LIMIT', 10485760),
    };

    public grpc = {
        host: this.getString('GRPC_HOST', 'localhost'),
        port: this.getNumber('GRPC_PORT', 5000),
    };

    public db = {
        host: this.getString('DB_HOST', 'localhost'),
        port: this.getNumber('DB_PORT', 5432),
        name: this.getString('DB_NAME', 'myapp'),
        user: this.getString('DB_USER', 'user'),
        password: this.getString('DB_PASSWORD', 'password'),
    };

    public logger = {
        loggingType: this.getString('LOGGING_TYPE', 'json'),
        pm2: this.getBoolean('IS_PM2', false),
    };
}
EOF

cat > src/core/config/config.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { Config } from './config';
import { ConfigModule as NestConfigModule } from '@nestjs/config';

@Module({
    imports: [NestConfigModule.forRoot()],
    providers: [Config],
    exports: [Config],
})
export class ConfigModule {}
EOF

# Create logger service
cat > src/core/logger/custom.logger.service.ts << 'EOF'
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
EOF

cat > src/core/logger/logger.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { Logger } from './custom.logger.service';
import { ConfigModule } from '../config/config.module';

@Module({
    imports: [ConfigModule],
    providers: [Logger],
    exports: [Logger],
})
export class LoggerModule {}
EOF

# Create health module with MikroORM health check
cat > src/core/health/health.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { TerminusModule } from '@nestjs/terminus';
import { MikroOrmHealthIndicator } from './mikro-orm.health';
import { DatabaseModule } from '../../infra/database/database.module';

@Module({
    imports: [
        TerminusModule,
        DatabaseModule,
    ],
    providers: [MikroOrmHealthIndicator],
    exports: [TerminusModule, MikroOrmHealthIndicator],
})
export class HealthModule {}
EOF

# Create MikroORM health indicator
cat > src/core/health/mikro-orm.health.ts << 'EOF'
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
EOF

# Create filters
cat > src/core/filters/http-exception.filter.ts << 'EOF'
import {
    ExceptionFilter,
    Catch,
    ArgumentsHost,
    HttpException,
    HttpStatus,
} from '@nestjs/common';
import { Response } from 'express';

@Catch()
export class HttpExceptionFilter implements ExceptionFilter {
    catch(exception: unknown, host: ArgumentsHost) {
        const ctx = host.switchToHttp();
        const response = ctx.getResponse<Response>();

        let status = HttpStatus.INTERNAL_SERVER_ERROR;
        let message = 'Internal server error';

        if (exception instanceof HttpException) {
            status = exception.getStatus();
            const exceptionResponse = exception.getResponse();
            
            if (typeof exceptionResponse === 'string') {
                message = exceptionResponse;
            } else if (typeof exceptionResponse === 'object' && exceptionResponse !== null) {
                message = (exceptionResponse as any).message || message;
            }
        }

        response.status(status).json({
            statusCode: status,
            message,
            timestamp: new Date().toISOString(),
        });
    }
}
EOF

# Create Swagger setup
cat > src/core/swagger/swagger.setup.ts << 'EOF'
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { INestApplication } from '@nestjs/common';

export const setup = async (app: INestApplication): Promise<void> => {
    const options = new DocumentBuilder()
        .setTitle('Health API Documentation')
        .setDescription('Health monitoring API (Business logic available via gRPC)')
        .setVersion('1.0')
        .addTag('Health', 'System health monitoring')
        .build();

    const document = SwaggerModule.createDocument(app, options);
    SwaggerModule.setup('docs', app, document, {
        customSiteTitle: 'Health API Docs',
    });
};
EOF

# Create core module
cat > src/core/core.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from './config/config.module';
import { LoggerModule } from './logger/logger.module';
import { HealthModule } from './health/health.module';

@Module({
    imports: [
        ConfigModule,
        LoggerModule,
        HealthModule,
    ],
    exports: [
        ConfigModule,
        LoggerModule,
        HealthModule,
    ],
})
export class CoreModule {}
EOF

# Create API health controller
cat > src/api/public/health.controller.ts << 'EOF'
import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import {
    HealthCheck,
    HealthCheckService,
} from '@nestjs/terminus';
import { MikroOrmHealthIndicator } from '../../core/health/mikro-orm.health';

@ApiTags('Health')
@Controller('health')
export class HealthController {
    constructor(
        private health: HealthCheckService,
        private db: MikroOrmHealthIndicator,
    ) {}

    @Get()
    @HealthCheck()
    @ApiOperation({ summary: 'Health check endpoint' })
    @ApiResponse({
        status: 200,
        description: 'Health check passed',
        schema: {
            type: 'object',
            properties: {
                status: { type: 'string', example: 'ok' },
                info: {
                    type: 'object',
                    properties: {
                        database: {
                            type: 'object',
                            properties: {
                                status: { type: 'string', example: 'up' }
                            }
                        }
                    }
                },
                error: { type: 'object' },
                details: { type: 'object' }
            }
        }
    })
    check() {
        return this.health.check([
            () => this.db.pingCheck('database'),
        ]);
    }
}
EOF

# Create public module
cat > src/api/public/public.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { HealthController } from './health.controller';
import { HealthModule } from '../../core/health/health.module';
import { DatabaseModule } from '../../infra/database/database.module';

@Module({
    imports: [
        HealthModule,
        DatabaseModule,
    ],
    controllers: [HealthController],
})
export class PublicModule {}
EOF

# Create API module
cat > src/api/api.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { PublicModule } from './public/public.module';

@Module({
    imports: [PublicModule],
})
export class ApiModule {}
EOF

# Create gRPC options
cat > src/grpc/grpc.options.ts << 'EOF'
import { GrpcOptions, Transport } from '@nestjs/microservices';
import { join } from 'path';

export const grpcOptions = (host: string, port: number): GrpcOptions => ({
    transport: Transport.GRPC,
    options: {
        url: `${host}:${port}`,
        package: ['user', 'health'],
        protoPath: [
            join(__dirname, '../../protos/user.proto'),
            join(__dirname, '../../protos/health.proto'),
        ],
        loader: {
            keepCase: true,
            longs: String,
            enums: String,
            defaults: true,
            oneofs: true,
        },
        maxReceiveMessageLength: 1024 * 1024 * 100, // 100MB
        maxSendMessageLength: 1024 * 1024 * 100, // 100MB
    },
});
EOF

# Create gRPC interceptors
cat > src/grpc/interceptors/grpc-exception.interceptor.ts << 'EOF'
import {
    Injectable,
    NestInterceptor,
    ExecutionContext,
    CallHandler,
    HttpException,
    HttpStatus,
} from '@nestjs/common';
import { Observable, throwError } from 'rxjs';
import { catchError } from 'rxjs/operators';
import { status } from '@grpc/grpc-js';

@Injectable()
export class GrpcExceptionInterceptor implements NestInterceptor {
    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        return next.handle().pipe(
            catchError(error => {
                const grpcStatus = this.httpStatusToGrpcStatus(error);
                const grpcError = {
                    code: grpcStatus,
                    message: error.message || 'Unknown error',
                    details: error.stack,
                };
                
                return throwError(() => grpcError);
            }),
        );
    }

    private httpStatusToGrpcStatus(error: any): status {
        if (error instanceof HttpException) {
            const httpStatus = error.getStatus();
            
            switch (httpStatus) {
                case HttpStatus.BAD_REQUEST:
                    return status.INVALID_ARGUMENT;
                case HttpStatus.UNAUTHORIZED:
                    return status.UNAUTHENTICATED;
                case HttpStatus.FORBIDDEN:
                    return status.PERMISSION_DENIED;
                case HttpStatus.NOT_FOUND:
                    return status.NOT_FOUND;
                case HttpStatus.CONFLICT:
                    return status.ALREADY_EXISTS;
                case HttpStatus.GONE:
                    return status.ABORTED;
                case HttpStatus.TOO_MANY_REQUESTS:
                    return status.RESOURCE_EXHAUSTED;
                case HttpStatus.INTERNAL_SERVER_ERROR:
                    return status.INTERNAL;
                case HttpStatus.NOT_IMPLEMENTED:
                    return status.UNIMPLEMENTED;
                case HttpStatus.SERVICE_UNAVAILABLE:
                    return status.UNAVAILABLE;
                case HttpStatus.GATEWAY_TIMEOUT:
                    return status.DEADLINE_EXCEEDED;
                default:
                    return status.UNKNOWN;
            }
        }
        
        return status.INTERNAL;
    }
}
EOF

cat > src/grpc/interceptors/grpc-logging.interceptor.ts << 'EOF'
import {
    Injectable,
    NestInterceptor,
    ExecutionContext,
    CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { tap } from 'rxjs/operators';
import { Logger } from '../../core/logger/custom.logger.service';

@Injectable()
export class GrpcLoggingInterceptor implements NestInterceptor {
    constructor(private readonly logger: Logger) {}

    intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
        const type = context.getType();
        
        if (type !== 'rpc') {
            return next.handle();
        }

        const rpcContext = context.switchToRpc();
        const metadata = rpcContext.getContext();
        const data = rpcContext.getData();
        const methodName = context.getHandler().name;
        const className = context.getClass().name;

        const now = Date.now();

        this.logger.info(`gRPC Request: ${className}.${methodName}`, {
            data,
            metadata: metadata?.getMap(),
        });

        return next.handle().pipe(
            tap({
                next: (response) => {
                    this.logger.info(`gRPC Response: ${className}.${methodName}`, {
                        duration: `${Date.now() - now}ms`,
                        response,
                    });
                },
                error: (error) => {
                    this.logger.error(`gRPC Error: ${className}.${methodName}`, {
                        duration: `${Date.now() - now}ms`,
                        error: error.message,
                        stack: error.stack,
                    });
                },
            }),
        );
    }
}
EOF

# Create gRPC services
cat > src/grpc/services/health.grpc.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { GrpcMethod } from '@nestjs/microservices';
import { Metadata } from '@grpc/grpc-js';
import {
    HealthCheckService,
} from '@nestjs/terminus';
import { MikroOrmHealthIndicator } from '../../core/health/mikro-orm.health';

@Injectable()
export class HealthGrpcService {
    constructor(
        private health: HealthCheckService,
        private db: MikroOrmHealthIndicator,
    ) {}

    @GrpcMethod('HealthService', 'Check')
    async check(data: any, metadata: Metadata): Promise<any> {
        const healthResult = await this.health.check([
            () => this.db.pingCheck('database'),
        ]);

        const services: { [key: string]: string } = {};
        
        if (healthResult.details) {
            for (const [key, value] of Object.entries(healthResult.details)) {
                services[key] = (value as any).status || 'unknown';
            }
        }

        return {
            status: healthResult.status,
            services,
        };
    }
}
EOF

cat > src/grpc/services/user.grpc.service.ts << 'EOF'
import { Injectable } from '@nestjs/common';
import { GrpcMethod } from '@nestjs/microservices';
import { Metadata } from '@grpc/grpc-js';
import { UserService } from '../../domain/user/user.service';

@Injectable()
export class UserGrpcService {
    constructor(private readonly userService: UserService) {}

    @GrpcMethod('UserService', 'CreateUser')
    async createUser(data: any, metadata: Metadata): Promise<any> {
        const user = await this.userService.create({
            fullName: data.fullName,
            email: data.email,
        });

        return {
            user: this.toGrpcUser(user),
        };
    }

    @GrpcMethod('UserService', 'GetUser')
    async getUser(data: any, metadata: Metadata): Promise<any> {
        const user = await this.userService.findById(data.id);

        return {
            user: this.toGrpcUser(user),
        };
    }

    @GrpcMethod('UserService', 'GetUsers')
    async getUsers(data: any, metadata: Metadata): Promise<any> {
        const result = await this.userService.findAll({
            skip: data.skip || 0,
            take: data.take || 10,
        });

        return {
            users: result.data.map(user => this.toGrpcUser(user)),
            total: result.total,
            skip: result.skip,
            take: result.take,
        };
    }

    @GrpcMethod('UserService', 'UpdateUser')
    async updateUser(data: any, metadata: Metadata): Promise<any> {
        const updateData: any = {};
        if (data.fullName !== undefined) updateData.fullName = data.fullName;
        if (data.email !== undefined) updateData.email = data.email;

        const user = await this.userService.update(data.id, updateData);

        return {
            user: this.toGrpcUser(user),
        };
    }

    @GrpcMethod('UserService', 'DeleteUser')
    async deleteUser(data: any, metadata: Metadata): Promise<any> {
        await this.userService.delete(data.id);

        return {
            success: true,
        };
    }

    @GrpcMethod('UserService', 'GetUserStats')
    async getUserStats(data: any, metadata: Metadata): Promise<any> {
        const stats = await this.userService.getStats();

        return {
            totalUsers: stats.totalUsers,
        };
    }

    private toGrpcUser(user: any): any {
        return {
            id: user.id,
            fullName: user.fullName,
            email: user.email,
            createdAt: user.createdAt.toISOString(),
            updatedAt: user.updatedAt.toISOString(),
        };
    }
}
EOF

# Create gRPC module
cat > src/grpc/grpc.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { UserGrpcService } from './services/user.grpc.service';
import { HealthGrpcService } from './services/health.grpc.service';
import { DomainModule } from '../domain/domain.module';
import { HealthModule } from '../core/health/health.module';
import { LoggerModule } from '../core/logger/logger.module';
import { DatabaseModule } from '../infra/database/database.module';
import { GrpcExceptionInterceptor } from './interceptors/grpc-exception.interceptor';
import { GrpcLoggingInterceptor } from './interceptors/grpc-logging.interceptor';

@Module({
    imports: [
        DomainModule,
        HealthModule,
        LoggerModule,
        DatabaseModule,
    ],
    providers: [
        UserGrpcService,
        HealthGrpcService,
        GrpcExceptionInterceptor,
        GrpcLoggingInterceptor,
    ],
})
export class GrpcModule {}
EOF

# Create app module
cat > src/app.module.ts << 'EOF'
import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ClientsModule } from '@nestjs/microservices';
import { ApiModule } from './api/api.module';
import { DomainModule } from './domain/domain.module';
import { CoreModule } from './core/core.module';
import { InfraModule } from './infra/infra.module';
import { GrpcModule } from './grpc/grpc.module';
import { grpcOptions } from './grpc/grpc.options';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: process.env.NODE_ENV === 'test' ? '.env.test' : '.env',
    }),
    CoreModule,
    InfraModule,
    DomainModule,
    ApiModule,
    GrpcModule,
    // gRPC clients for testing
    ClientsModule.register([
      {
        name: 'USER_PACKAGE',
        ...grpcOptions('localhost', 5000),
      },
      {
        name: 'HEALTH_PACKAGE',
        ...grpcOptions('localhost', 5000),
      },
    ]),
  ],
})
export class AppModule {}
EOF

# Create main files
cat > src/main.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { AppModule } from './app.module';
import { setup as setupSwagger } from './core/swagger/swagger.setup';
import { Logger } from './core/logger/custom.logger.service';
import { HttpExceptionFilter } from './core/filters/http-exception.filter';
import { Config } from './core/config/config';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  // Global prefix
  app.setGlobalPrefix('api');
  
  // Global pipes
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
    }),
  );
  
  // Global filters
  app.useGlobalFilters(new HttpExceptionFilter());
  
  // CORS
  app.enableCors();
  
  // Swagger
  await setupSwagger(app);
  
  // Get services from the container
  const logger = app.get(Logger);
  const config = app.get(Config);
  
  const port = config.web.port;
  
  await app.listen(port);
  
  logger.info(`Health API is running on: http://localhost:${port}`);
  logger.info(`Health check endpoint: http://localhost:${port}/api/health`);
  logger.info(`Swagger documentation: http://localhost:${port}/docs`);
  logger.info(`Note: Full business API available via gRPC on port ${config.grpc.port}`);
}

bootstrap();
EOF

cat > src/main-grpc.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { MicroserviceOptions } from '@nestjs/microservices';
import { AppModule } from './app.module';
import { grpcOptions } from './grpc/grpc.options';
import { Logger } from './core/logger/custom.logger.service';
import { Config } from './core/config/config';
import { GrpcExceptionInterceptor } from './grpc/interceptors/grpc-exception.interceptor';
import { GrpcLoggingInterceptor } from './grpc/interceptors/grpc-logging.interceptor';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);
    
    const config = app.get(Config);
    const logger = app.get(Logger);
    
    // Configure gRPC microservice
    const grpcHost = config.grpc.host;
    const grpcPort = config.grpc.port;
    
    const microserviceOptions = grpcOptions(grpcHost, grpcPort) as MicroserviceOptions;
    app.connectMicroservice(microserviceOptions);
    
    // Apply global interceptors
    const grpcExceptionInterceptor = app.get(GrpcExceptionInterceptor);
    const grpcLoggingInterceptor = app.get(GrpcLoggingInterceptor);
    
    app.useGlobalInterceptors(
        grpcLoggingInterceptor,
        grpcExceptionInterceptor,
    );
    
    await app.startAllMicroservices();
    
    logger.info(`gRPC server is running on: ${grpcHost}:${grpcPort}`);
}

bootstrap();
EOF

cat > src/main-hybrid.ts << 'EOF'
import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { MicroserviceOptions } from '@nestjs/microservices';
import { AppModule } from './app.module';
import { setup as setupSwagger } from './core/swagger/swagger.setup';
import { Logger } from './core/logger/custom.logger.service';
import { HttpExceptionFilter } from './core/filters/http-exception.filter';
import { Config } from './core/config/config';
import { grpcOptions } from './grpc/grpc.options';
import { GrpcExceptionInterceptor } from './grpc/interceptors/grpc-exception.interceptor';
import { GrpcLoggingInterceptor } from './grpc/interceptors/grpc-logging.interceptor';

async function bootstrap() {
    const app = await NestFactory.create(AppModule);
    
    // Global prefix for REST API
    app.setGlobalPrefix('api');
    
    // Global pipes
    app.useGlobalPipes(
        new ValidationPipe({
            whitelist: true,
            transform: true,
            forbidNonWhitelisted: true,
        }),
    );
    
    // Global filters for HTTP
    app.useGlobalFilters(new HttpExceptionFilter());
    
    // CORS
    app.enableCors();
    
    // Swagger
    await setupSwagger(app);
    
    // Get services from the container
    const logger = app.get(Logger);
    const config = app.get(Config);
    
    // Configure gRPC microservice
    const grpcHost = config.grpc.host;
    const grpcPort = config.grpc.port;
    
    const microserviceOptions = grpcOptions(grpcHost, grpcPort) as MicroserviceOptions;
    app.connectMicroservice(microserviceOptions);
    
    // Apply global interceptors for gRPC
    const grpcExceptionInterceptor = app.get(GrpcExceptionInterceptor);
    const grpcLoggingInterceptor = app.get(GrpcLoggingInterceptor);
    
    app.useGlobalInterceptors(
        grpcLoggingInterceptor,
        grpcExceptionInterceptor,
    );
    
    // Start all microservices (gRPC)
    await app.startAllMicroservices();
    
    // Start HTTP server
    const httpPort = config.web.port;
    await app.listen(httpPort);
    
    logger.info(`Health API is running on: http://localhost:${httpPort}`);
    logger.info(`Health check endpoint: http://localhost:${httpPort}/api/health`);
    logger.info(`Swagger documentation: http://localhost:${httpPort}/docs`);
    logger.info(`gRPC server (full API) is running on: ${grpcHost}:${grpcPort}`);
}

bootstrap();
EOF

# Create test files
cat > test/app.e2e-spec.ts << 'EOF'
import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import * as request from 'supertest';
import { AppModule } from '../src/app.module';

describe('Health API (e2e)', () => {
  let app: INestApplication;

  beforeEach(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    app.setGlobalPrefix('api');
    await app.init();
  });

  afterEach(async () => {
    await app.close();
  });

  describe('Health Check', () => {
    it('/api/health (GET) should return 200', () => {
      return request(app.getHttpServer())
        .get('/api/health')
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('status');
          expect(res.body.status).toBe('ok');
        });
    });

    it('/api/non-existent (GET) should return 404', () => {
      return request(app.getHttpServer())
        .get('/api/non-existent')
        .expect(404);
    });
  });
});
EOF

cat > test/jest-e2e.json << 'EOF'
{
  "moduleFileExtensions": ["js", "json", "ts"],
  "rootDir": ".",
  "testEnvironment": "node",
  "testRegex": ".e2e-spec.ts$",
  "transform": {
    "^.+\\.(t|j)s$": "ts-jest"
  }
}
EOF

# Create gRPC client example
cat > scripts/grpc-client-example.ts << 'EOF'
// This is a simple example script for testing gRPC services
// Run with: npx ts-node scripts/grpc-client-example.ts

import { NestFactory } from '@nestjs/core';
import { Module } from '@nestjs/common';
import { ClientsModule, ClientGrpc } from '@nestjs/microservices';
import { grpcOptions } from '../src/grpc/grpc.options';
import { firstValueFrom } from 'rxjs';

@Module({
    imports: [
        ClientsModule.register([
            {
                name: 'USER_PACKAGE',
                ...grpcOptions('localhost', 5000),
            },
            {
                name: 'HEALTH_PACKAGE',
                ...grpcOptions('localhost', 5000),
            },
        ]),
    ],
})
class TestClientModule {}

async function runClient() {
    const app = await NestFactory.createApplicationContext(TestClientModule);
    
    // Get gRPC clients
    const userClient = app.get<ClientGrpc>('USER_PACKAGE');
    const healthClient = app.get<ClientGrpc>('HEALTH_PACKAGE');
    
    // Get services
    const userService = userClient.getService<any>('UserService');
    const healthService = healthClient.getService<any>('HealthService');

    try {
        // Check health
        console.log('Checking health...');
        const healthResponse: any = await firstValueFrom(healthService.check({}));
        console.log('Health status:', healthResponse);

        // Create a user
        console.log('\nCreating user...');
        const createResponse: any = await firstValueFrom(
            userService.createUser({
                fullName: 'John Doe',
                email: 'john.doe@example.com',
            }),
        );
        console.log('Created user:', createResponse?.user);

        // Get the user
        if (createResponse?.user?.id) {
            console.log('\nGetting user...');
            const getResponse: any = await firstValueFrom(
                userService.getUser({ id: createResponse.user.id }),
            );
            console.log('Retrieved user:', getResponse?.user);

            // Update the user
            console.log('\nUpdating user...');
            const updateResponse: any = await firstValueFrom(
                userService.updateUser({
                    id: createResponse.user.id,
                    fullName: 'John Updated Doe',
                }),
            );
            console.log('Updated user:', updateResponse?.user);

            // Delete the user
            console.log('\nDeleting user...');
            const deleteResponse: any = await firstValueFrom(
                userService.deleteUser({ id: createResponse.user.id }),
            );
            console.log('Delete success:', deleteResponse?.success);
        }

        // Get all users
        console.log('\nGetting all users...');
        const getUsersResponse: any = await firstValueFrom(
            userService.getUsers({ skip: 0, take: 10 }),
        );
        console.log(`Found ${getUsersResponse?.total || 0} users:`, getUsersResponse?.users);

        // Get user stats
        console.log('\nGetting user stats...');
        const statsResponse: any = await firstValueFrom(userService.getUserStats({}));
        console.log('User stats:', statsResponse);

    } catch (error) {
        console.error('Error:', error);
    } finally {
        await app.close();
    }
}

// Run the client
runClient().catch(console.error);
EOF

# Create README.md
cat > README.md << 'EOF'
# Clean Architecture NestJS API with MikroORM and gRPC

## 📋 Prerequisites

- Node.js (v18+)
- PostgreSQL
- pnpm or npm

## 🛠️ Installation

1. Install dependencies
```bash
npm install
```

2. Set up environment variables
```bash
cp .env.example .env
# Edit .env with your database credentials
```

3. Create/Update database schema
```bash
npm run schema:create
# or
npm run schema:update
```

4. Generate proto files
```bash
npm run proto:generate
```

## 🚀 Running the Application

### Development (Hybrid Mode - REST + gRPC)
```bash
npm run start:dev
```

### Production
```bash
npm run build
npm run start:prod
```

### Separate Servers
```bash
# REST API only (Health endpoint only)
node dist/main.js

# gRPC only
node dist/main-grpc.js

# Both (Hybrid)
node dist/main-hybrid.js
```

## 📚 API Documentation

### REST API
Once the application is running, you can access the Swagger documentation at:
```
http://localhost:3000/docs
```

**Note: REST API now only provides health check endpoint. All business functionality is available via gRPC.**

### gRPC API
The gRPC server runs on port 5000 by default. Use any gRPC client to connect.

## 🏗️ Architecture

The project follows clean architecture principles with the following layers:

### API Layer (`src/api/`)
REST health check endpoint only

### gRPC Layer (`src/grpc/`)
gRPC services and proto definitions (full user management functionality)

### Domain Layer (`src/domain/`)
Business logic and domain models with MikroORM entities

### Infrastructure Layer (`src/infra/`)
External dependencies and data access using MikroORM

### Core Layer (`src/core/`)
Cross-cutting concerns (config, logging, filters)

## 🔗 API Endpoints

### REST Endpoints

#### Health
- **GET** `/api/health` - Health check

### gRPC Services

#### UserService
- `CreateUser` - Create a new user
- `GetUser` - Get user by ID
- `GetUsers` - Get all users with pagination
- `UpdateUser` - Update user
- `DeleteUser` - Delete user
- `GetUserStats` - Get user statistics

#### HealthService
- `Check` - Health check

## 📄 User Model

```typescript
{
  id: string (UUID)
  fullName: string
  email: string (unique)
  createdAt: Date
  updatedAt: Date
}
```

## 🧪 Testing

### Unit Tests
```bash
npm run test
```

### E2E Tests
```bash
npm run test:e2e
```

### Test Coverage
```bash
npm run test:cov
```

### gRPC Client Example
```bash
npx ts-node scripts/grpc-client-example.ts
```

## 📦 Database Management with MikroORM

### Create a new migration
```bash
npm run migration:create
```

### Run migrations
```bash
npm run migration:up
```

### Rollback migrations
```bash
npm run migration:down
```

### Create database schema
```bash
npm run schema:create
```

### Update database schema
```bash
npm run schema:update
```

## 🎯 Example API Calls

### REST API

#### Health Check
```bash
curl http://localhost:3000/api/health
```

### gRPC API

Use the provided client example or any gRPC client tool like `grpcurl`:

```bash
# List services
grpcurl -plaintext localhost:5000 list

# Create user
grpcurl -plaintext -d '{"fullName": "John Doe", "email": "john@example.com"}' \
  localhost:5000 user.UserService/CreateUser

# Get all users
grpcurl -plaintext -d '{"skip": 0, "take": 10}' \
  localhost:5000 user.UserService/GetUsers
```

## 🐳 Docker

Build and run with Docker Compose:
```bash
docker-compose up
```

## 🔄 MikroORM vs Prisma

This project uses MikroORM instead of Prisma for the following advantages:

- **Better TypeScript support**: MikroORM is written in TypeScript from the ground up
- **Data Mapper pattern**: Clean separation between domain entities and database
- **Unit of Work pattern**: Better transaction handling
- **Identity Map**: Prevents duplicate entity instances
- **Better performance**: No additional abstraction layer like Prisma Client
- **More flexible**: Supports multiple inheritance strategies and advanced ORM features

## 📝 Notes

This application uses a hybrid architecture where:
- REST API provides only health monitoring
- All business logic is exposed via gRPC for better performance and type safety
- MikroORM is used for database operations with clean architecture patterns
- This design is optimized for microservice communication
EOF

echo "✅ Project setup complete!"
echo ""
echo "📂 Project created in: $PROJECT_NAME"
echo ""
echo "🚀 Next steps:"
echo "1. cd $PROJECT_NAME"
echo "2. npm install"
echo "3. cp .env.example .env"
echo "4. Edit .env with your database credentials"
echo "5. npm run schema:create"
echo "6. npm run proto:generate"
echo "7. npm run start:dev"
echo ""
echo "📚 Documentation available at: http://localhost:3000/docs"
echo "🔌 gRPC server will run on: localhost:5000"