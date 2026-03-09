import { CreateCategoryDto } from './create-category.dto';
import { IsString, IsOptional, MaxLength } from 'class-validator';


//export class UpdateCategoryDto extends PartialType(CreateCategoryDto) {}
export class UpdateCategoryDto {
  @IsString()
  @IsOptional()
  @MaxLength(100)
  nombre?: string;

  @IsString()
  @IsOptional()
  @MaxLength(500)
  descripcion?: string;

  @IsOptional()
  activo?: number;
}