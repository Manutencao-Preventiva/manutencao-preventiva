import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Maquina } from '../maquinas/entities/maquina.entity';
import { Horas } from '../horas/entities/horas.entity';
import { Notificacao } from '../notificacoes/entities/notificacao.entity';
import { DashboardService } from './dashboard.service';
import { DashboardController } from './dashboard.controller';

@Module({
  imports: [TypeOrmModule.forFeature([Maquina, Horas, Notificacao])],
  controllers: [DashboardController],
  providers: [DashboardService],
  exports: [DashboardService],
})
export class DashboardModule {}
