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
        gestor: usuarioSalvo.gestor,
        telefone: usuarioSalvo.telefone,
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
        gestor: usuario.gestor,
        telefone: usuario.telefone,
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
      gestor: usuario.gestor,
      usuario: {
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
        gestor: usuario.gestor,
        telefone: usuario.telefone,
      },
    };
  }

  async atualizarPerfil(data: {
    id?: number;
    email?: string;
    nome?: string;
    telefone?: string;
  }) {
    let usuario: Usuario | null = null;

    if (data.id) {
      usuario = await this.usuarioRepository.findOne({ where: { id: data.id } });
    }
    if (!usuario && data.email) {
      usuario = await this.usuarioRepository.findOne({ where: { email: data.email } });
    }

    if (!usuario) {
      return {
        sucesso: false,
        mensagem: 'Usuário não encontrado',
      };
    }

    if (data.nome !== undefined && data.nome.trim().length > 0) {
      usuario.nome = data.nome.trim();
    }
    if (data.telefone !== undefined) {
      usuario.telefone = data.telefone;
    }

    const usuarioSalvo = await this.usuarioRepository.save(usuario);

    return {
      sucesso: true,
      mensagem: 'Perfil atualizado com sucesso',
      usuario: {
        id: usuarioSalvo.id,
        nome: usuarioSalvo.nome,
        email: usuarioSalvo.email,
        gestor: usuarioSalvo.gestor,
        telefone: usuarioSalvo.telefone,
      },
    };
  }

  async obterPerfil(email: string) {
    const usuario = await this.usuarioRepository.findOne({ where: { email } });
    if (!usuario) {
      return { sucesso: false, mensagem: 'Usuário não encontrado' };
    }
    return {
      sucesso: true,
      usuario: {
        id: usuario.id,
        nome: usuario.nome,
        email: usuario.email,
        gestor: usuario.gestor,
        telefone: usuario.telefone,
      },
    };
  }
}