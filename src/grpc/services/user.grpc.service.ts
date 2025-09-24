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
