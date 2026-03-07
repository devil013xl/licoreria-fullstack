import { Entity, Column, PrimaryGeneratedColumn, OneToMany } from 'typeorm';
import { Product } from '../../products/entities/product.entity';

@Entity('categorias')
export class Category {
  @PrimaryGeneratedColumn()
  id_categoria: number;

  @Column({ unique: true, length: 100 })
  nombre: string;

  @Column({ length: 500, nullable: true })
  descripcion: string;

  @Column({ default: true })
  activo: boolean;

  // Relación: Una categoría tiene muchos productos
  @OneToMany(() => Product, (product) => product.categoria)
  productos: Product[];
}