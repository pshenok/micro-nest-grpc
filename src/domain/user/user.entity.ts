import { Entity, PrimaryKey, Property, Unique } from '@mikro-orm/core';
import { v4 as uuid } from 'uuid';
import { BaseEntity } from '../domain.types';

@Entity({ tableName: 'users' })
export class User implements BaseEntity {
  @PrimaryKey()
  id: string = uuid();

  @Property({ columnType: 'varchar(255)' })
  fullName!: string;

  @Property({ columnType: 'varchar(255)' })
  @Unique()
  email!: string;

  @Property({ onCreate: () => new Date() })
  createdAt: Date = new Date();

  @Property({ onUpdate: () => new Date() })
  updatedAt: Date = new Date();
}
