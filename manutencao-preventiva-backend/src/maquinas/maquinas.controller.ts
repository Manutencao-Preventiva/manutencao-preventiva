import { Body, Controller, Get, Param, Patch, Post, Put } from '@nestjs/common';
import { MaquinasService } from './maquinas.service';
import { Maquina } from './entities/maquina.entity';

@Controller('maquinas')
export class MaquinasController {
  constructor(private readonly maquinasService: MaquinasService) {}

  @Get()
  async listar() {
    return this.maquinasService.listarTodas();
  }

  @Get(':id')
  async buscar(@Param('id') id: string) {
    return this.maquinasService.buscarPorId(Number(id));
  }

  @Post()
  async criar(@Body() dados: Partial<Maquina>) {
    return this.maquinasService.criar(dados);
  }

  @Put(':id')
  async atualizar(@Param('id') id: string, @Body() dados: Partial<Maquina>) {
    return this.maquinasService.atualizar(Number(id), dados);
  }

  @Patch(':id/status')
  async atualizarStatus(
    @Param('id') id: string,
    @Body('status') status: 'ATIVA' | 'EM_MANUTENCAO' | 'INATIVA',
  ) {
    return this.maquinasService.atualizarStatus(Number(id), status);
  }
}
