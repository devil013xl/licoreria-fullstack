import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ProductsController } from './products.controller';
import { Product } from './entities/product.entity'; // Tu entidad mapeada

@Module({
  imports: [
    // Esto registra la entidad para que el Repositorio pueda ser inyectado
    TypeOrmModule.forFeature([Product]) 
  ],
  controllers: [ProductsController],
  providers: [], // Aquí irían los servicios más adelante
})
export class ProductsModule {}