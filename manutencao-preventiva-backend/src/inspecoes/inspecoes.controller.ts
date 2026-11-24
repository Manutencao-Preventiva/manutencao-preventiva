import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Put,
} from '@nestjs/common';
import { InspecoesService } from './inspecoes.service';

@Controller('inspecoes-nr12')
export class InspecoesController {
  constructor(private readonly inspecoesService: InspecoesService) {}

  @Post()
  async salvar(@Body() body: any) {
    // Normaliza os dados caso venham no padrão direto ou padrão Forms
    let respostas = body.respostas;
    if (!respostas && Array.isArray(body.answers)) {
      const respMap: Record<string, string> = {};
      for (const a of body.answers) {
        if (a.questionId && a.answer1 !== undefined) {
          respMap[a.questionId] = String(a.answer1);
        }
      }
      respostas = respMap;
    }

    return this.inspecoesService.salvar({
      titulo: body.titulo,
      equipamento: body.equipamento || body.ni || 'Torno ROMI - 01',
      operador: body.operador || 'Operador',
      emailOperador: body.emailOperador,
      turno: body.turno,
      curso: body.curso,
      data: body.data || body.dataEnvio,
      status: body.status,
      observacao: body.observacao,
      respostas,
      horimetroInicio: body.horimetroInicio,
      horimetroFim: body.horimetroFim,
      horasTrabalhadas: body.horasTrabalhadas,
    });
  }

  @Post('quase-no-final')
  async quaseNoFinal(@Body() body: any) {
    return this.inspecoesService.notificarQuaseNoFinal({
      equipamento: body.equipamento || 'Máquina Industrial',
      operador: body.operador || 'Operador',
      etapaAtual: Number(body.etapaAtual || 5),
      totalEtapas: Number(body.totalEtapas || 5),
      temAlertasAteAgora: body.temAlertasAteAgora === true,
    });
  }

  @Get()
  async listar() {
    return this.inspecoesService.listar();
  }

  @Get(':id')
  async obter(@Param('id') id: string) {
    return this.inspecoesService.obterPorId(Number(id));
  }

  @Put(':id/visto')
  async marcarComoVisto(@Param('id') id: string) {
    return this.inspecoesService.marcarComoVisto(Number(id));
  }
}
