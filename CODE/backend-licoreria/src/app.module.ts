import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { ProductsModule } from './products/products.module'; // 1. Importa el módulo
import { Product } from './products/entities/product.entity';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mssql',
      host: 'localhost',
      port: 1433,
      username: 'sa',
      password: '1234',
      database: 'Licoreria',
      entities: [Product],
      synchronize: false,
      options: {
        encrypt: false,
        trustServerCertificate: true,
      },
    }),
    ProductsModule, // 2. Agrégalo aquí a la lista de imports
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}