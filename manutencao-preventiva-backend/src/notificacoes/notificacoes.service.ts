import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Notificacao } from './entities/notificacao.entity';

@Injectable()
export class NotificacoesService {
  constructor(
    @InjectRepository(Notificacao)
    private readonly notifRepo: Repository<Notificacao>,
  ) {}

  async listarTodas(): Promise<Notificacao[]> {
    return this.notifRepo.find({
      relations: { maquina: true, usuario: true },
      order: { criada_em: 'DESC' },
    });
  }

  async contarNaoLidas(): Promise<number> {
    return this.notifRepo.count({
      where: { lida: 0 },
    });
  }

  async criar(dados: {
    usuario_id: number;
    maquina_id?: number;
    tipo?: 'MANUTENCAO' | 'HORAS' | 'SISTEMA' | 'AVISO';
    titulo: string;
    mensagem: string;
  }): Promise<Notificacao> {
    const nova = this.notifRepo.create({
      ...dados,
      tipo: dados.tipo || 'AVISO',
      lida: 0,
    });
    return this.notifRepo.save(nova);
  }

  async marcarComoLida(id: number): Promise<Notificacao> {
    const notif = await this.notifRepo.findOne({ where: { id } });
    if (!notif) throw new NotFoundException('Notificação não encontrada.');
    notif.lida = 1;
    return this.notifRepo.save(notif);
  }
}
