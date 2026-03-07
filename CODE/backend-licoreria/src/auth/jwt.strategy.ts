import { Injectable } from '@nestjs/common';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor() {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(), // Busca el token en el Header
      ignoreExpiration: false,
      secretOrKey: 'CLAVE_SECRETA_SUPER_SEGURA', // DEBE ser la misma del AuthModule
    });
  }

  async validate(payload: any) {
    // Lo que devuelvas aquí se inyectará en el objeto 'request.user'
    return { userId: payload.sub, username: payload.username, id_rol: payload.id_rol };
  }
}