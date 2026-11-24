import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Horas } from './entities/horas.entity';
import { MaquinasService } from '../maquinas/maquinas.service';
import { Notificacao } from '../notificacoes/entities/notificacao.entity';

@Injectable()
export class HorasService {
  constructor(
    @InjectRepository(Horas)
    private readonly horasRepo: Repository<Horas>,
    @InjectRepository(Notificacao)
    private readonly notifRepo: Repository<Notificacao>,
    private readonly maquinasService: MaquinasService,
  ) {}

  async listarTodas(): Promise<Horas[]> {
    return this.horasRepo.find({
      relations: { maquina: true, usuario: true },
      order: { data_operacao: 'DESC', id: 'DESC' },
    });
  }

  async listarPorMaquina(maquinaId: number): Promise<Horas[]> {
    return this.horasRepo.find({
      where: { maquina_id: maquinaId },
      relations: { usuario: true },
      order: { data_operacao: 'DESC' },
    });
  }

  async registrar(dados: {
    maquina_id: number;
    usuario_id: number;
    data_operacao?: string;
    horas_trabalhadas: number;
    horimetro_inicio: number;
    horimetro_fim: number;
    observacoes?: string;
  }): Promise<Horas> {
    const dataOp = dados.data_operacao || new Date().toISOString().slice(0, 10);
    const registro = this.horasRepo.create({
      ...dados,
      data_operacao: dataOp,
    });

    const salvo = await this.horasRepo.save(registro);

    // Atualiza o horímetro atual da máquina se horimetro_fim for maior
    if (dados.horimetro_fim) {
      const maquina = await this.maquinasService.atualizarHorimetro(
        dados.maquina_id,
        dados.horimetro_fim,
      );

      // Regra de Manutenção Preventiva: a cada 250h há revisão programada.
      // Quando faltam menos de 20h para atingir o ciclo (ex: 230h, 480h, 730h, 980h, etc.),
      // a máquina está "quase no final" do ciclo e gera notificação automática para o gestor!
      const restoCiclo = Number(dados.horimetro_fim) % 250;
      if (restoCiclo >= 230 || restoCiclo <= 10) {
        try {
          const proxCiclo = Math.ceil(Number(dados.horimetro_fim) / 250) * 250;
          await this.notifRepo.save(
            this.notifRepo.create({
              usuario_id: 1, // Gestor
              maquina_id: dados.maquina_id,
              tipo: 'MANUTENCAO',
              titulo: `Manutenção Preventiva Próxima: ${maquina.nome}`,
              mensagem: `A máquina ${maquina.nome} (${maquina.codigo}) atingiu ${dados.horimetro_fim.toFixed(1)}h e está quase no final do ciclo de ${proxCiclo}h de manutenção preventiva. Agende a revisão!`,
              lida: 0,
            }),
          );
        } catch (_) {}
      }
    }

    return salvo;
  }
}
