import { Role } from './settings.entity';

export interface CreateSettingsDto {
  role: Role;
}

export interface UpdateSettingsDto {
  role?: Role;
}

export interface SettingsResponseDto {
  id: string;
  role: Role;
  createdAt: Date;
  updatedAt: Date;
}
