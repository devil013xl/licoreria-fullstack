import { Controller, Get, Post, Body, Patch, Param, Delete, UseGuards } from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RolesGuard } from '../auth/guards/roles.guard';
import { Roles } from '../auth/decorators/roles.decorator';
import { Rol } from '../auth/roles/rol.enum';

@Controller('categories')
@UseGuards(JwtAuthGuard, RolesGuard) // Protegemos todo el controlador
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Post()
  @Roles(Rol.ADMIN, Rol.GERENTE) // Solo el Admin crea categorías
  create(@Body() createCategoryDto: CreateCategoryDto) {
    return this.categoriesService.create(createCategoryDto);
  }

  @Get()
  @Roles(Rol.ADMIN, Rol.VENDEDOR, Rol.GERENTE) // Todos pueden verlas
  findAll() {
    return this.categoriesService.findAll();
  }

  @Get(':id')
  @Roles(Rol.ADMIN, Rol.GERENTE)
  findOne(@Param('id') id: string) {
    return this.categoriesService.findOne(+id);
  }

  @Patch(':id')
  @Roles(Rol.ADMIN, Rol.GERENTE)
  update(@Param('id') id: string, @Body() updateCategoryDto: UpdateCategoryDto) {
    return this.categoriesService.update(+id, updateCategoryDto);
  }

  @Delete(':id')
  @Roles(Rol.ADMIN, Rol.GERENTE)
  remove(@Param('id') id: string) {
    return this.categoriesService.remove(+id);
  }
}