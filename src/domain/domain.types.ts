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
