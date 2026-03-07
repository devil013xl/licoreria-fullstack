import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from '../decorators/roles.decorator';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<number[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest();

    // Debug para ver qué está pasando realmente
    //console.log('Usuario del Token:', user); 
    //console.log('Roles que pedimos:', requiredRoles);

    // Verificamos que el usuario exista y tenga un rol
    if (!user || !user.id_rol) {
      return false; 
    }

    // Comparamos asegurando que no haya espacios y todo esté en Mayúsculas
    //const hasRole = requiredRoles.some((role) => user.rol.trim().toUpperCase() === role.toUpperCase());
    // user.rol debe ser el ID (número) que viene del JWT
    const hasRole = requiredRoles.includes(user.id_rol);

    if (!hasRole) {
       throw new ForbiddenException(`Tu rol [${user.id_rol}] no tiene permiso para esta acción. Se requiere: ${requiredRoles}`);
    }

    return hasRole;
  }
}