import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, DataSource } from 'typeorm';
import { User } from './entities/user.entity';
import { CreateUserDto } from './dto/create-user.dto';
import * as bcrypt from 'bcrypt';
import { Employee } from './entities/employee.entity';
import { Rol } from '../auth/roles/rol.enum';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly dataSource: DataSource, // <-- INYECTA ESTO
  ) {}

  /*async create(createUserDto: CreateUserDto) {
    const { password_hash, ...userData } = createUserDto;

    // Ciframos la contraseña
    const salt = await bcrypt.genSalt(10);
    const hashed = await bcrypt.hash(password_hash, salt);

    // Creamos el nuevo usuario con la clave cifrada
    const newUser = this.userRepository.create({  
      ...userData,
      password_hash: hashed,
      activo: true
    });

    return await this.userRepository.save(newUser);
  }*/
 async create(createUserDto: any) {
  const queryRunner = this.dataSource.createQueryRunner();
  await queryRunner.connect();
  await queryRunner.startTransaction();

  if (createUserDto.id_rol === Rol.ADMIN) {
  console.log('¡Cuidado! Estás creando un administrador.');
}

  try {
    // 1. Crear el objeto Empleado con los campos obligatorios de tu entidad
    const nuevoEmpleado = queryRunner.manager.create(Employee, {
      nombre: createUserDto.nombre,
    apellido: createUserDto.apellido,
    cedula: createUserDto.cedula,
    email: createUserDto.email,
    // USAMOS VALORES DINÁMICOS AQUÍ:
    cargo: createUserDto.cargo,      // Ahora lo tomas del JSON
    salario: createUserDto.salario,  // Ahora lo tomas del JSON
    genero: createUserDto.genero,
    activo: true
      // fecha_contratacion y fecha_registro se llenan solos por los decoradores
    });

    const empleadoGuardado = await queryRunner.manager.save(nuevoEmpleado);

    // 2. Cifrar contraseña
    const salt = await bcrypt.genSalt(10);
    const hashed = await bcrypt.hash(createUserDto.password_hash, salt);

    // 3. Crear el Usuario vinculado al id_empleado recién generado
    const nuevoUsuario = queryRunner.manager.create(User, {
      username: createUserDto.username,
      email: createUserDto.email,
      password_hash: hashed,
      id_rol: createUserDto.id_rol,
      id_empleado: empleadoGuardado.id_empleado, // Aquí usamos el ID generado por SQL
      activo: true
    });
    
    const usuarioGuardado = await queryRunner.manager.save(nuevoUsuario);

    // Si todo salió bien, guardamos cambios en ambas tablas
    await queryRunner.commitTransaction();
    return usuarioGuardado;

  } catch (err) {
    // Si algo falló (ej: cédula duplicada), deshacemos todo
    await queryRunner.rollbackTransaction();
    throw err;
  } finally {
    // Liberamos la conexión
    await queryRunner.release();
  }
}
}