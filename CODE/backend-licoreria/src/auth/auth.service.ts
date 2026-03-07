import { Injectable, UnauthorizedException, InternalServerErrorException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { JwtService } from '@nestjs/jwt';
import * as bcrypt from 'bcrypt';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly jwtService: JwtService, // Inyecta el servicio de JWT
  ) {}

  async login(username: string, pass: string) {
  // 1. Buscamos al usuario
  const user = await this.userRepository.createQueryBuilder('user')
    .addSelect('user.password_hash') // <--- Esto recupera la columna aunque tenga 'select: false'
    .leftJoinAndSelect('user.rol', 'rol') // Esto reemplaza el relations: ['rol']
    .where('user.username = :username', { username })
    .andWhere('user.activo = 1') // Suponiendo que 'activo' es un BIT o booleano
    .getOne();

  // 2. PROTECCIÓN: Si 'user' es null, lanzamos el error AQUÍ y no seguimos
  if (!user) {
    throw new UnauthorizedException('Usuario no encontrado o inactivo');
  }

  // 3. Verificamos que la propiedad password_hash exista en el objeto
  // Usamos una validación extra por si el nombre en la entidad es distinto
  if (!user.password_hash) {
    console.error('ERROR: La entidad User no tiene la propiedad password_hash');
    throw new InternalServerErrorException('Error de configuración en el servidor');
  }

  /*
  // 4. Ahora sí es seguro usar .trim()
  if (user.password_hash.trim() !== pass.trim()) {
    throw new UnauthorizedException('Contraseña incorrecta');
  }*/

  // 4. Comparamos la contraseña usando bcrypt
  //const isMatch = await bcrypt.compare(pass.trim(), user.password_hash.trim());
  const passwordEnviada = pass ? pass.trim() : '';
  const passwordBD = user.password_hash ? user.password_hash.trim() : '';

  const isMatch = await bcrypt.compare(passwordEnviada, passwordBD);

  console.log('¿Coinciden?:', isMatch);

  if (!isMatch) {
    throw new UnauthorizedException('Contraseña incorrecta');
  }

  // 5. Generación del Token
  //const payload = { sub: user.id_usuario, username: user.username, rol: user.rol?.nombre };
  const payload = { 
    sub: user.id_usuario, 
    username: user.username, 
    id_rol: user.rol?.id_rol, // <--- ¡Añade el ID numérico para el RolesGuard!
    rol_nombre: user.rol?.nombre 
  };

  return {
    access_token: await this.jwtService.signAsync(payload),
    user: {
      username: user.username,
      rol: user.rol?.nombre
    }
  };
}
}