import { Injectable } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';

@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {} 
// El string 'jwt' debe coincidir con el nombre que le diste a tu PassportStrategy