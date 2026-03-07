import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Product } from './entities/product.entity';
import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { RolesGuard } from '../auth/guards/roles.guard'; 
import { Roles } from '../auth/decorators/roles.decorator';
import { Rol } from '../auth/roles/rol.enum';

@Controller('products')
// ¡Asegúrate de que diga EXPORT aquí!
@UseGuards(AuthGuard('jwt'), RolesGuard)
export class ProductsController { 
  constructor(
    @InjectRepository(Product)
    private readonly productRepository: Repository<Product>,
  ) {}

  @Get()
  @Roles(Rol.ADMIN, Rol.VENDEDOR, Rol.ALMACENERO, Rol.CAJERO, Rol.CLIENTE, Rol.GERENTE, Rol.SUPERVISOR) //  pueden ver
  async findAll() {
    return await this.productRepository.find({
      where: { activo: true },
      relations: ['categoria'], // <--- ESTA ES LA MAGIA
      order: { nombre: 'ASC' }
    });
    //return "Lista de licores disponible para todo el personal";
  }

  @Post()
  @Roles(Rol.ADMIN) // ¡SOLO el admin puede crear!
  create() {
    return "Solo el admin debería ver esto";
  }
}