import { Module } from '@nestjs/common';
import { JwtModule } from '@nestjs/jwt'; // <-- Asegura este import
import { PassportModule } from '@nestjs/passport';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { User } from '../users/entities/user.entity';
import { JwtStrategy } from './jwt.strategy';

@Module({
  imports: [
    TypeOrmModule.forFeature([User]),
    PassportModule,
    JwtModule.register({
      global: true, // <-- AÑADE ESTO para que el servicio esté disponible en todo el módulo
      secret: 'CLAVE_SECRETA_SUPER_SEGURA', 
      signOptions: { expiresIn: '8h' },
    }),
  ],
  providers: [AuthService, JwtStrategy],
  controllers: [AuthController],
  exports: [AuthService], // Añade esto por si acaso
})
export class AuthModule {}