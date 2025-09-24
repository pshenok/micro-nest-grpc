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
