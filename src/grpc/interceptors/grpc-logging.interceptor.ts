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
