import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/product.entity';
import { Controller, Get, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Controller('products')
// ¡Asegúrate de que diga EXPORT aquí!
export class ProductsController { 
  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  @UseGuards(AuthGuard('jwt')) // <-- ¡ESTE ES EL CANDADO!
  @Get()
  async findAll() {
    return await this.productRepository.find({
      where: { activo: true },
      relations: ['categoria'], // <--- ESTA ES LA MAGIA
      order: { nombre: 'ASC' }
    });
  }
}