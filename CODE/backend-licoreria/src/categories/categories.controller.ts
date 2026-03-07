import { Controller, Get, Param } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Category } from './entities/category.entity';

@Controller('categories')
export class CategoriesController {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  @Get()
  async findAll() {
    return await this.categoryRepository.find({
      where: { activo: true },
      order: { nombre: 'ASC' }
    });
  }

  // NUEVO: Obtener una categoría específica con todos sus productos
  @Get(':id')
  async findOne(@Param('id') id: number) {
    return await this.categoryRepository.findOne({
      where: { id_categoria: id },
      relations: ['productos'], // Trae la lista de licores asociados
    });
  }
}