import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Maquina } from './entities/maquina.entity';

@Injectable()
export class MaquinasService {
  constructor(
    @InjectRepository(Maquina)
    private readonly maquinaRepo: Repository<Maquina>,
  ) {}

  async listarTodas(): Promise<Maquina[]> {
    return this.maquinaRepo.find({
      order: { id: 'ASC' },
    });
  }

  async buscarPorId(id: number): Promise<Maquina> {
    const maquina = await this.maquinaRepo.findOne({ where: { id } });
    if (!maquina) throw new NotFoundException('Máquina não encontrada.');
    return maquina;
  }

  async criar(dados: Partial<Maquina>): Promise<Maquina> {
    const nova = this.maquinaRepo.create(dados);
    return this.maquinaRepo.save(nova);
  }

  async atualizar(id: number, dados: Partial<Maquina>): Promise<Maquina> {
    await this.buscarPorId(id);
    await this.maquinaRepo.update(id, dados);
    return this.buscarPorId(id);
  }

  async atualizarStatus(id: number, status: 'ATIVA' | 'EM_MANUTENCAO' | 'INATIVA'): Promise<Maquina> {
    return this.atualizar(id, { status });
  }

  async atualizarHorimetro(id: number, novoHorimetro: number): Promise<Maquina> {
    return this.atualizar(id, { horimetro_atual: novoHorimetro });
  }
}
