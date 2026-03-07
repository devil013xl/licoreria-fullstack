import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';
import { User } from './user.entity';

@Entity('roles')
export class Role {
  @PrimaryGeneratedColumn()
  id_rol: number;

  @Column({ length: 50, unique: true })
  nombre: string;

  @Column({ length: 200, nullable: true })
  descripcion: string;

  @Column({ nullable: true })
  nivel_acceso: number;

  @Column({ default: true })
  activo: boolean;

  @OneToMany(() => User, (user) => user.rol)
  usuarios: User[];
}