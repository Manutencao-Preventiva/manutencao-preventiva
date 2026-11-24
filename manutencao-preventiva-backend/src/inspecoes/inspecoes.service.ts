import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Inspecao } from './entities/inspecao.entity';
import { Notificacao } from '../notificacoes/entities/notificacao.entity';
import { Maquina } from '../maquinas/entities/maquina.entity';
import { Usuario } from '../auth/entities/usuario.entity';
import { HorasService } from '../horas/horas.service';

@Injectable()
export class InspecoesService {
  constructor(
    @InjectRepository(Inspecao)
    private readonly inspecaoRepository: Repository<Inspecao>,
    @InjectRepository(Notificacao)
    private readonly notificacaoRepository: Repository<Notificacao>,
    @InjectRepository(Maquina)
    private readonly maquinaRepository: Repository<Maquina>,
    @InjectRepository(Usuario)
    private readonly usuarioRepository: Repository<Usuario>,
    private readonly horasService: HorasService,
  ) { }

  private async obterIdGestor(): Promise<number> {
    const gestor = await this.usuarioRepository.findOne({
      where: [{ gestor: true }, { perfil: 'GESTOR' }],
      order: { id: 'ASC' },
    });
    return gestor ? gestor.id : 11;
  }

  async salvar(dados: {
    titulo?: string;
    equipamento: string;
    operador: string;
    emailOperador?: string;
    turno?: string;
    curso?: string;
    data?: string | Date;
    status?: string;
    observacao?: string;
    respostas?: any;
    answers?: any;
    horimetroInicio?: number;
    horimetroFim?: number;
    horasTrabalhadas?: number;
  }) {
    const respostasParaArmazenar = dados.respostas || dados.answers || {};
    const respostasJson =
      typeof respostasParaArmazenar === 'string'
        ? respostasParaArmazenar
        : JSON.stringify(respostasParaArmazenar);

    const dataObj = dados.data ? new Date(dados.data) : new Date();

    const inspecao = this.inspecaoRepository.create({
      titulo: dados.titulo || 'Checklist NR-12 Torno Mecânico',
      equipamento: dados.equipamento || 'Torno ROMI - 01',
      operador: dados.operador || 'Operador',
      emailOperador: dados.emailOperador || '',
      turno: dados.turno || 'Manhã (7h30-11h30)',
      curso: dados.curso || '',
      data: isNaN(dataObj.getTime()) ? new Date() : dataObj,
      status: dados.status || 'Concluído',
      observacao: dados.observacao || '',
      respostasJson,
      vistoPeloGestor: false,
    });

    const salva = await this.inspecaoRepository.save(inspecao);

    // 1. Tenta associar com a máquina correspondente na tabela 'maquinas'
    let maquinaAssociada: Maquina | null = null;
    try {
      const termo = dados.equipamento.trim().toLowerCase();
      const todasMaquinas = await this.maquinaRepository.find();
      maquinaAssociada =
        todasMaquinas.find(
          (m) =>
            m.nome.toLowerCase().includes(termo) ||
            termo.includes(m.nome.toLowerCase()) ||
            m.codigo.toLowerCase().includes(termo),
        ) || null;

      // Se a inspeção teve alerta / não conformidade grave, coloca a máquina em manutenção preventiva
      if (maquinaAssociada && dados.status === 'Com Ressalva') {
        maquinaAssociada.status = 'EM_MANUTENCAO';
        await this.maquinaRepository.save(maquinaAssociada);
      }
    } catch (_) { }

    // 2. Dispara automaticamente Notificação para o Gestor na tabela 'notificacoes'
    try {
      const gestorId = await this.obterIdGestor();
      const temAlerta = dados.status === 'Com Ressalva';
      const novaNotificacao = this.notificacaoRepository.create({
        usuario_id: gestorId,
        maquina_id: maquinaAssociada ? maquinaAssociada.id : undefined,
        tipo: temAlerta ? 'MANUTENCAO' : 'AVISO',
        titulo: temAlerta
          ? `Alerta NR-12: ${salva.equipamento}`
          : `Inspeção NR-12 Enviada: ${salva.equipamento}`,
        mensagem: temAlerta
          ? `O operador ${salva.operador} enviou o checklist com não-conformidades na máquina ${salva.equipamento}. Turno: ${salva.turno}. Requer auditoria!`
          : `O operador ${salva.operador} concluiu a inspeção da máquina ${salva.equipamento} com 100% de conformidade.`,
        lida: 0,
      });

      await this.notificacaoRepository.save(novaNotificacao);
    } catch (e) {
      console.error('Erro ao salvar notificacao:', e);
    }

    // 3. Grava as horas no banco de dados se informado horimetro/horas
    try {
      const hInicio = Number(dados.horimetroInicio);
      const hFim = Number(dados.horimetroFim);
      let horasTrab = Number(dados.horasTrabalhadas);

      if (!isNaN(hInicio) && !isNaN(hFim) && hFim >= hInicio) {
        if (isNaN(horasTrab) || horasTrab <= 0) {
          horasTrab = hFim - hInicio;
        }

        // Encontra usuario operador
        let opUser: Usuario | null = null;
        if (dados.emailOperador) {
          opUser = await this.usuarioRepository.findOne({ where: { email: dados.emailOperador } });
        }
        if (!opUser) {
          opUser = await this.usuarioRepository.findOne({ where: { nome: dados.operador } });
        }
        const opId = opUser ? opUser.id : 12;

        if (maquinaAssociada) {
          await this.horasService.registrar({
            maquina_id: Number(maquinaAssociada.id),
            usuario_id: opId,
            data_operacao: new Date().toISOString().slice(0, 10),
            horas_trabalhadas: horasTrab,
            horimetro_inicio: hInicio,
            horimetro_fim: hFim,
            observacoes: `Apontamento via Checklist NR-12 - Turno ${salva.turno}`,
          });
        }
      }
    } catch (errHoras) {
      console.error('Erro ao registrar horas via inspecao:', errHoras);
    }

    return {
      sucesso: true,
      mensagem: 'Inspeção cadastrada e notificação enviada ao gestor com sucesso',
      inspecao: this.formatarInspecao(salva),
    };
  }

  /// Notificação enviada quando o operador está quase no final do formulário (Etapa 5 de 5)
  async notificarQuaseNoFinal(dados: {
    equipamento: string;
    operador: string;
    etapaAtual: number;
    totalEtapas: number;
    temAlertasAteAgora: boolean;
  }) {
    try {
      let maquinaAssociada: Maquina | null = null;
      try {
        const termo = dados.equipamento.trim().toLowerCase();
        const todasMaquinas = await this.maquinaRepository.find();
        maquinaAssociada =
          todasMaquinas.find(
            (m) =>
              m.nome.toLowerCase().includes(termo) ||
              termo.includes(m.nome.toLowerCase()) ||
              m.codigo.toLowerCase().includes(termo),
          ) || null;
      } catch (_) { }

      const gestorId = await this.obterIdGestor();
      const nova = this.notificacaoRepository.create({
        usuario_id: gestorId,
        maquina_id: maquinaAssociada ? maquinaAssociada.id : undefined,
        tipo: dados.temAlertasAteAgora ? 'MANUTENCAO' : 'AVISO',
        titulo: `Inspeção em Andamento: ${dados.equipamento}`,
        mensagem: dados.temAlertasAteAgora
          ? `Atenção: O operador ${dados.operador} está finalizando a inspeção na ${dados.equipamento} e detectou ressalvas operacionais.`
          : `O operador ${dados.operador} está concluindo a última etapa do checklist na máquina ${dados.equipamento}.`,
        lida: 0,
      });

      await this.notificacaoRepository.save(nova);

      return { sucesso: true, mensagem: 'Notificação prévia enviada ao gestor' };
    } catch (_) {
      return { sucesso: false };
    }
  }

  async listar() {
    const inspecoes = await this.inspecaoRepository.find({
      order: { id: 'DESC' },
    });

    return {
      sucesso: true,
      inspecoes: inspecoes.map((i) => this.formatarInspecao(i)),
    };
  }

  async obterPorId(id: number) {
    const inspecao = await this.inspecaoRepository.findOne({
      where: { id },
    });

    if (!inspecao) {
      return { sucesso: false, mensagem: 'Inspeção não encontrada' };
    }

    return {
      sucesso: true,
      inspecao: this.formatarInspecao(inspecao),
    };
  }

  async marcarComoVisto(id: number) {
    const inspecao = await this.inspecaoRepository.findOne({
      where: { id },
    });

    if (!inspecao) {
      return { sucesso: false, mensagem: 'Inspeção não encontrada' };
    }

    inspecao.vistoPeloGestor = true;
    await this.inspecaoRepository.save(inspecao);

    return {
      sucesso: true,
      mensagem: 'Inspeção marcada como vista',
    };
  }

  private formatarInspecao(i: Inspecao) {
    let respostasObj: any = {};
    if (i.respostasJson) {
      try {
        respostasObj = JSON.parse(i.respostasJson);
      } catch (_) {
        respostasObj = {};
      }
    }

    return {
      id: i.id.toString(),
      titulo: i.titulo,
      equipamento: i.equipamento,
      operador: i.operador,
      emailOperador: i.emailOperador,
      turno: i.turno,
      curso: i.curso,
      data: i.data ? i.data.toISOString() : new Date().toISOString(),
      status: i.status,
      observacao: i.observacao,
      respostas: respostasObj,
      vistoPeloGestor: i.vistoPeloGestor,
      criado_em: i.criado_em,
    };
  }
}
