import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Role } from './entities/role.entity';
import { UsersService } from './users.service';
import { UsersController } from './users.controller';
import { Employee } from './entities/employee.entity';

@Module({
  // Importamos las entidades para que TypeORM las reconozca en este módulo
  imports: [TypeOrmModule.forFeature([User, Role, Employee])],
  
  // Declaramos el controlador para que NestJS cree las rutas (/users)
  controllers: [UsersController],
  
  // Declaramos el servicio para que pueda ser inyectado
  providers: [UsersService],
  
  // Exportamos el servicio y el TypeOrmModule para que el AuthModule pueda usarlos
  exports: [UsersService, TypeOrmModule] 
})
export class UsersModule {}