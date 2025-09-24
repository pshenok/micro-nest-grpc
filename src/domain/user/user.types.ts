export interface CreateUserDto {
    fullName: string;
    email: string;
}

export interface UpdateUserDto {
    fullName?: string;
    email?: string;
}
