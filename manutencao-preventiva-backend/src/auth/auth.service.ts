import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import * as bcrypt from 'bcrypt';
import { Usuario } from './entities/usuario.entity';

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Usuario)
    private readonly usuarioRepository: Repository<Usuario>,
  ) {}

  async login(email: string, senha: string) {
    const usuario = await this.usuarioRepository.findOne({
      where: { email },
    });

    if (!usuario) {
      return {
        sucesso: false,
        mensagem: 'E-mail ou senha incorretos',
      };
    }

    const senhaCorreta = await bcrypt.compare(senha, usuario.senha);

    if (!senhaCorreta) {
      return {
        sucesso: false,
        mensagem: 'E-mail ou senha incorretos',
      };
    }

    return {
      sucesso: true,
      mensagem: 'Login realizado com sucesso',
      usuario: {
        id: usuario.id,
        email: usuario.email,
      },
    };
  }
}