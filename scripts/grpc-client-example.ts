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
