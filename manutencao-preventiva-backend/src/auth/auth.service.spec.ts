import { Test, TestingModule } from '@nestjs/testing';
import { getRepositoryToken } from '@nestjs/typeorm';
import * as bcrypt from 'bcrypt';
import { AuthService } from './auth.service';
import { Usuario } from './entities/usuario.entity';

describe('AuthService', () => {
  let service: AuthService;
  let usuarioRepository: {
    findOne: jest.Mock;
    find: jest.Mock;
    create: jest.Mock;
    save: jest.Mock;
  };

  beforeEach(async () => {
    usuarioRepository = {
      findOne: jest.fn(),
      find: jest.fn(),
      create: jest.fn(),
      save: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: getRepositoryToken(Usuario),
          useValue: usuarioRepository,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  it('should create a user with hashed password', async () => {
    usuarioRepository.findOne.mockResolvedValue(null);
    jest.spyOn(bcrypt, 'hash').mockResolvedValue('$2b$10$hashMock' as never);
    usuarioRepository.create.mockReturnValue({
      nome: 'Maria',
      email: 'maria@teste.com',
      senha: '$2b$10$hashMock',
    });
    usuarioRepository.save.mockResolvedValue({
      id: 1,
      nome: 'Maria',
      email: 'maria@teste.com',
      senha: '$2b$10$hashMock',
    });

    const result = await service.cadastrar({
      nome: 'Maria',
      email: 'maria@teste.com',
      senha: '123456',
    });

    expect(bcrypt.hash).toHaveBeenCalledWith('123456', 10);
    expect(result.sucesso).toBe(true);
    expect(result.usuario.nome).toBe('Maria');
  });

  it('should login and return the user name', async () => {
    usuarioRepository.findOne.mockResolvedValue({
      id: 1,
      nome: 'Maria',
      email: 'maria@teste.com',
      senha: '$2b$10$hashMock',
    });
    jest.spyOn(bcrypt, 'compare').mockResolvedValue(true as never);

    const result = await service.login('maria@teste.com', '123456');

    expect(result.sucesso).toBe(true);
    expect(result.usuario.nome).toBe('Maria');
    expect(result.usuario.email).toBe('maria@teste.com');
  });
});
