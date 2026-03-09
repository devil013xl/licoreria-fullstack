import { IsNotEmpty, IsString } from 'class-validator';

export class LoginDto {
  @IsString()         // <-- Agrega esto
  @IsNotEmpty()       // <-- Agrega esto
  username: string;

  @IsString()         // <-- Agrega esto
  @IsNotEmpty()       // <-- Agrega esto
  password_hash: string; // En el futuro será solo 'password'
}