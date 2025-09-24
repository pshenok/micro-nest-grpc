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
