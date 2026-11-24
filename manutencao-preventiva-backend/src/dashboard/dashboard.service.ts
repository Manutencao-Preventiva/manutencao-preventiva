import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Maquina } from '../maquinas/entities/maquina.entity';
import { Horas } from '../horas/entities/horas.entity';
import { Notificacao } from '../notificacoes/entities/notificacao.entity';

@Injectable()
export class DashboardService {
  constructor(
    @InjectRepository(Maquina)
    private readonly maquinaRepo: Repository<Maquina>,
    @InjectRepository(Horas)
    private readonly horasRepo: Repository<Horas>,
    @InjectRepository(Notificacao)
    private readonly notifRepo: Repository<Notificacao>,
  ) {}

  async obterResumoGestor() {
    // 1. Máquinas
    const maquinas = await this.maquinaRepo.find({ order: { id: 'ASC' } });
    const totalMaquinas = maquinas.length;
    const maquinasAtivas = maquinas.filter((m) => m.status === 'ATIVA').length;
    const maquinasEmManutencao = maquinas.filter((m) => m.status === 'EM_MANUTENCAO').length;
    const maquinasInativas = maquinas.filter((m) => m.status === 'INATIVA').length;

    // 2. Horas
    const horas = await this.horasRepo.find({
      relations: { maquina: true, usuario: true },
      order: { data_operacao: 'DESC', id: 'DESC' },
    });
    const totalHorasTrabalhadas = horas.reduce(
      (sum, h) => sum + Number(h.horas_trabalhadas || 0),
      0,
    );

    // 3. Notificações
    const notificacoes = await this.notifRepo.find({
      relations: { maquina: true, usuario: true },
      order: { criada_em: 'DESC' },
    });
    const totalNotificacoes = notificacoes.length;
    const notificacoesNaoLidas = notificacoes.filter((n) => Number(n.lida) === 0).length;

    // Agrupamento de alertas por tipo
    const alertasPorTipo = {
      MANUTENCAO: notificacoes.filter((n) => n.tipo === 'MANUTENCAO').length,
      HORAS: notificacoes.filter((n) => n.tipo === 'HORAS').length,
      SISTEMA: notificacoes.filter((n) => n.tipo === 'SISTEMA').length,
      AVISO: notificacoes.filter((n) => n.tipo === 'AVISO').length,
    };

    // Horas agrupadas por máquina
    const horasPorMaquinaMap = new Map<number, { nome: string; codigo: string; horas: number; horimetro: number }>();
    for (const m of maquinas) {
      horasPorMaquinaMap.set(Number(m.id), {
        nome: m.nome,
        codigo: m.codigo,
        horas: 0,
        horimetro: Number(m.horimetro_atual || 0),
      });
    }
    for (const h of horas) {
      const entry = horasPorMaquinaMap.get(Number(h.maquina_id));
      if (entry) {
        entry.horas += Number(h.horas_trabalhadas || 0);
      }
    }

    return {
      totalMaquinas,
      maquinasAtivas,
      maquinasEmManutencao,
      maquinasInativas,
      totalHorasTrabalhadas: Number(totalHorasTrabalhadas.toFixed(2)),
      totalNotificacoes,
      notificacoesNaoLidas,
      alertasPorTipo,
      horasPorMaquina: Array.from(horasPorMaquinaMap.values()),
      maquinas,
      ultimasHoras: horas.slice(0, 10),
      ultimasNotificacoes: notificacoes.slice(0, 10),
    };
  }
}
