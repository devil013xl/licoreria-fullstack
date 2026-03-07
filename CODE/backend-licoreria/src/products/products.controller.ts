import { Controller, Get } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/product.entity';

@Controller('products')
// ¡Asegúrate de que diga EXPORT aquí!
export class ProductsController { 
  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  @Get()
  async findAll() {
    return await this.productRepository.find({
      where: { activo: true },
      relations: ['categoria'], // <--- ESTA ES LA MAGIA
      order: { nombre: 'ASC' }
    });
  }
}