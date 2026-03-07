import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn, UpdateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Role } from './role.entity';

@Entity('usuarios')
export class User {
  @PrimaryGeneratedColumn()
  id_usuario: number;

  @Column({ unique: true, length: 50 })
  username: string;

  @Column({ unique: true, length: 100 })
  email: string;

  @Column({ length: 255, select: false }) // 'select: false' por seguridad para no traer el hash por defecto
  password_hash: string;

  @ManyToOne(() => Role, (role) => role.usuarios)
  @JoinColumn({ name: 'id_rol' })
  rol: Role;

  @Column({ nullable: true })
  id_rol: number;

  @Column({ nullable: true })
  id_empleado: number;

  @Column({ nullable: true })
  id_cliente: number;

  @Column({ type: 'datetime', nullable: true })
  ultimo_acceso: Date;

  @Column({ default: 0 })
  intentos_fallidos: number;

  @Column({ default: false })
  bloqueado: boolean;

  @Column({ type: 'datetime', nullable: true })
  fecha_bloqueo: Date;

  @Column({ default: true })
  activo: boolean;

  @CreateDateColumn()
  fecha_creacion: Date;

  @UpdateDateColumn({ nullable: true })
  fecha_actualizacion: Date;
}