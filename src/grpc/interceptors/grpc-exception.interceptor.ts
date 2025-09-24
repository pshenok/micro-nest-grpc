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
