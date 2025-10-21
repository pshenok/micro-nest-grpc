export interface CreateAdminDto {
    fullName: string;
    email: string;
    password: string;
}

export interface UpdateAdminDto {
    fullName?: string;
    email?: string;
    password?: string;
}
