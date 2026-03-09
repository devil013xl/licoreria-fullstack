import { Injectable, NotFoundException, ConflictException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Category } from './entities/category.entity';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto'; // Este lo crearemos luego

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
  ) {}

  async create(createCategoryDto: CreateCategoryDto) {
    const existe = await this.categoryRepository.findOne({ where: { nombre: createCategoryDto.nombre } });
    if (existe) throw new ConflictException('La categoría ya existe');
    
    const nueva = this.categoryRepository.create(createCategoryDto);
    return await this.categoryRepository.save(nueva);
  }

  async findAll() {
    return await this.categoryRepository.find({ where: { activo: 1 } });
  }

  async findOne(id: number) {
    const categoria = await this.categoryRepository.findOne({ where: { id_categoria: id } });
    if (!categoria) throw new NotFoundException('Categoría no encontrada');
    return categoria;
  }

  async update(id: number, updateCategoryDto: UpdateCategoryDto) {
  const categoria = await this.categoryRepository.preload({
    id_categoria: id,
    ...updateCategoryDto,
  });

  if (!categoria) {
    throw new NotFoundException(`Categoría con ID ${id} no encontrada`);
  }

  return await this.categoryRepository.save(categoria);
}

  async remove(id: number) {
  // 1. Buscamos la categoría por su ID real
  const categoria = await this.categoryRepository.findOneBy({ id_categoria: id });
  // 2. Si no existe, lanzamos error
  if (!categoria) {
    throw new NotFoundException(`La categoría con ID ${id} no existe`);
  }
  // 3. Cambiamos el estado a 0 (Borrado Lógico)
  categoria.activo = 0;
  // 4. Guardamos el cambio
  return await this.categoryRepository.save(categoria);
}
}