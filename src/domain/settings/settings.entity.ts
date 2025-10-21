import { Entity, PrimaryKey, Property, Enum } from '@mikro-orm/core';
import { v4 as uuid } from 'uuid';
import { BaseEntity } from '../domain.types';

export enum Role {
  ADMIN = 'ADMIN',
  USER = 'USER',
}

@Entity({ tableName: 'settings' })
export class Settings implements BaseEntity {
  @PrimaryKey()
  id: string = uuid();

  @Enum(() => Role)
  role!: Role;

  @Property({ onCreate: () => new Date() })
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  updatedAt: Date = new Date();
}
