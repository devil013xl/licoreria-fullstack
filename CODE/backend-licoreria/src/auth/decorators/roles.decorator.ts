import { SetMetadata } from '@nestjs/common';
import { Rol } from '../roles/rol.enum';

// Este decorador guardará los roles permitidos en los metadatos de la ruta
export const ROLES_KEY = 'roles';
export const Roles = (...roles: Rol[]) => SetMetadata(ROLES_KEY, roles);