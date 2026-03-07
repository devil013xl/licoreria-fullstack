import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProductsModule } from './products/products.module'; // 1. Importa el módulo
import { Product } from './products/entities/product.entity';
import { Category } from './categories/entities/category.entity';
import { CategoriesModule } from './categories/categories.module';
import { User } from './users/entities/user.entity';
import { Role } from './users/entities/role.entity';
import { Employee } from './users/entities/employee.entity';
import { UsersModule } from './users/users.module';
import { AuthModule } from './auth/auth.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mssql',
      host: 'localhost',
      port: 1433,
      username: 'sa',
      password: '1234',
      database: 'Licoreria',
      entities: [Product, Category, User, Role, Employee],
      synchronize: false,
      options: {
        encrypt: false,
        trustServerCertificate: true,
      },
    }),
    ProductsModule, // 2. Agrégalo aquí a la lista de imports
    CategoriesModule, // <-- El módulo aquí
    UsersModule,
    AuthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}