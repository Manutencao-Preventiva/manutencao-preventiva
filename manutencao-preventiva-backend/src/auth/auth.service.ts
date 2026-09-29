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

  async cadastrar(data: { nome: string; email: string; senha: string }) {
    const usuarioExistente = await this.usuarioRepository.findOne({
      where: { email: data.email },
    });

    if (usuarioExistente) {
      return {
        sucesso: false,
        mensagem: 'E-mail já cadastrado',
      };
    }

    const senhaHash = await bcrypt.hash(data.senha, 10);

    const usuario = this.usuarioRepository.create({
      nome: data.nome,
      email: data.email,
      senha: senhaHash,
    });

    const usuarioSalvo = await this.usuarioRepository.save(usuario);

    return {
      sucesso: true,
      mensagem: 'Usuário cadastrado com sucesso',
      usuario: {
        id: usuarioSalvo.id,
        nome: usuarioSalvo.nome,
        email: usuarioSalvo.email,
      },
    };
  }

  async listarUsuarios() {
    const usuarios = await this.usuarioRepository.find();

    return {
      sucesso: true,
      usuarios: usuarios.map((usuario) => ({
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
      })),
    };
  }

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
        nome: usuario.nome,
        email: usuario.email,
      },
    };
  }
}