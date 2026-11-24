import { Body, Controller, Get, Param, Post } from '@nestjs/common';
import { HorasService } from './horas.service';

@Controller('horas')
export class HorasController {
  constructor(private readonly horasService: HorasService) {}

  @Get()
  async listar() {
    return this.horasService.listarTodas();
  }

  @Get('maquina/:id')
  async listarPorMaquina(@Param('id') id: string) {
    return this.horasService.listarPorMaquina(Number(id));
  }

  @Post()
  async registrar(
    @Body()
    body: {
      maquina_id: number;
      usuario_id: number;
      data_operacao?: string;
      horas_trabalhadas: number;
      horimetro_inicio: number;
      horimetro_fim: number;
      observacoes?: string;
    },
  ) {
    return this.horasService.registrar(body);
  }
}
