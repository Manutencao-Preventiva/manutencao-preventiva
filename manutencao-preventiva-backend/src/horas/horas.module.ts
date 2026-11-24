import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Horas } from './entities/horas.entity';
import { HorasService } from './horas.service';
import { HorasController } from './horas.controller';
import { MaquinasModule } from '../maquinas/maquinas.module';
import { Notificacao } from '../notificacoes/entities/notificacao.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Horas, Notificacao]), MaquinasModule],
  controllers: [HorasController],
  providers: [HorasService],
  exports: [HorasService, TypeOrmModule],
})
export class HorasModule {}
