import { Entity, Column, PrimaryGeneratedColumn } from 'typeorm';

@Entity('productos') // Debe coincidir exactamente con el nombre en tu SQL
export class Product {
  @PrimaryGeneratedColumn()
  id_producto: number;

  @Column()
  nombre: string;

  @Column()
  marca: string;

  @Column('decimal', { precision: 10, scale: 2 })
  precio_venta: number;

  @Column()
  stock_actual: number;

  @Column()
  volumen_ml: number;
}