import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Inspecao } from './entities/inspecao.entity';
import { InspecoesService } from './inspecoes.service';
import { InspecoesController } from './inspecoes.controller';
import { Notificacao } from '../notificacoes/entities/notificacao.entity';
import { Maquina } from '../maquinas/entities/maquina.entity';
import { Usuario } from '../auth/entities/usuario.entity';
import { Horas } from '../horas/entities/horas.entity';
import { HorasModule } from '../horas/horas.module';

@Module({
  imports: [TypeOrmModule.forFeature([Inspecao, Notificacao, Maquina, Usuario, Horas]), HorasModule],
  controllers: [InspecoesController],
  providers: [InspecoesService],
  exports: [InspecoesService],
})
export class InspecoesModule { }
