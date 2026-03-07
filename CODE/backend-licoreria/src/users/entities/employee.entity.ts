import { Entity, Column, PrimaryGeneratedColumn, CreateDateColumn } from 'typeorm';

@Entity('empleados')
export class Employee {
  @PrimaryGeneratedColumn()
  id_empleado: number;

  @Column({ length: 100 })
  nombre: string;

  @Column({ length: 100, nullable: true })
  apellido: string;

  @Column({ unique: true, length: 20 })
  cedula: string;

  @Column({ type: 'date', nullable: true })
  fecha_nacimiento: Date;

  @Column({ type: 'char', length: 1, nullable: true })
  genero: string;

  @Column({ unique: true, length: 100, nullable: true })
  email: string;

  @Column({ length: 20, nullable: true })
  telefono: string;

  @Column({ length: 500, nullable: true })
  direccion: string;

  @Column({ type: 'date', default: () => 'GETDATE()' })
  fecha_contratacion: Date;

  @Column({ length: 100, nullable: true })
  cargo: string;

  @Column({ nullable: true })
  id_sucursal: number;

  @Column('decimal', { precision: 10, scale: 2, nullable: true })
  salario: number;

  @Column({ default: true })
  activo: boolean;

  @CreateDateColumn()
  fecha_registro: Date;
}