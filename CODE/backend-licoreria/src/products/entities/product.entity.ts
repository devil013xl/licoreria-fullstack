import { 
  Entity, 
  Column, 
  PrimaryGeneratedColumn, 
  CreateDateColumn, 
  UpdateDateColumn, 
  ManyToOne,
  JoinColumn
} from 'typeorm';

import { Category } from 'src/categories/entities/category.entity';

@Entity('productos') //Nombre de la Tabla en SQL
export class Product {
  @PrimaryGeneratedColumn()
  id_producto: number;

  @Column({ unique: true, length: 50, nullable: true })
  codigo_barras: string;

  @Column({ length: 200 })
  nombre: string;

  @Column({ length: 500, nullable: true })
  descripcion: string;

  //@Column({ nullable: true })
  //id_categoria: number;
  // REEMPLAZAMOS el Column de id_categoria por esto:
  @ManyToOne(() => Category, (category) => category.productos)
  @JoinColumn({ name: 'id_categoria' }) // Indica que esta es la columna FK en SQL
  categoria: Category;

  @Column({ nullable: true })
  id_proveedor: number;

  @Column({ length: 100, nullable: true })
  marca: string;

  @Column({ length: 50, nullable: true })
  tipo_bebida: string;

  @Column('decimal', { precision: 5, scale: 2, nullable: true })
  graduacion_alcoholica: number;

  @Column({ nullable: true })
  volumen_ml: number;

  @Column({ length: 100, nullable: true })
  pais_origen: string;

  @Column('decimal', { precision: 10, scale: 2 })
  precio_compra: number;

  @Column('decimal', { precision: 10, scale: 2 })
  precio_venta: number;

  @Column({ default: 0 })
  stock_actual: number;

  @Column({ default: 5 })
  stock_minimo: number;

  @Column({ default: 500 })
  stock_maximo: number;

  @Column({ length: 20, nullable: true })
  unidad_medida: string;

  @Column({ default: true })
  activo: boolean;

  @CreateDateColumn()
  fecha_creacion: Date;

  @UpdateDateColumn({ nullable: true })
  fecha_actualizacion: Date;
}