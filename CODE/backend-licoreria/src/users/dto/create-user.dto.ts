export class CreateUserDto {
  username: string;
  email: string;
  password_hash: string; // La recibimos como texto plano del cliente
  id_rol?: number; // Opcional, por si quieres asignar rol al crear
}