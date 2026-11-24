import { Body, Controller, Get, Param, Patch, Post, Put } from '@nestjs/common';
import { NotificacoesService } from './notificacoes.service';

@Controller('notificacoes')
export class NotificacoesController {
  constructor(private readonly notifService: NotificacoesService) {}

  @Get()
  async listar() {
    return this.notifService.listarTodas();
  }

  @Get('nao-lidas/total')
  async totalNaoLidas() {
    const total = await this.notifService.contarNaoLidas();
    return { total };
  }

  @Post()
  async criar(
    @Body()
    body: {
      usuario_id: number;
      maquina_id?: number;
      tipo?: 'MANUTENCAO' | 'HORAS' | 'SISTEMA' | 'AVISO';
      titulo: string;
      mensagem: string;
    },
  ) {
    return this.notifService.criar(body);
  }

  @Put(':id/lida')
  async marcarLida(@Param('id') id: string) {
    return this.notifService.marcarComoLida(Number(id));
  }

  @Patch(':id/lida')
  async marcarLidaPatch(@Param('id') id: string) {
    return this.notifService.marcarComoLida(Number(id));
  }
}
