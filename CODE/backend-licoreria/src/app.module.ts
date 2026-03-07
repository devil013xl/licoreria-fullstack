import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm'; // Importación necesaria
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { Product } from './products/entities/product.entity'; // Importación de tu entidad

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mssql',
      host: 'localhost',
      port: 1433,
      username: 'sa',
      password: '1234', // Asegúrate de que sea tu clave real de SQL Server
      database: 'Licoreria',
      entities: [Product],
      synchronize: false, 
      options: {
        encrypt: false, 
        trustServerCertificate: true, // Agregué esto por si usas certificados locales
      },
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {} 