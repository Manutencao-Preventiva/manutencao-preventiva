import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { InspecoesModule } from './inspecoes/inspecoes.module';
import { MaquinasModule } from './maquinas/maquinas.module';
import { HorasModule } from './horas/horas.module';
import { NotificacoesModule } from './notificacoes/notificacoes.module';
import { DashboardModule } from './dashboard/dashboard.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'mysql',
      host: 'localhost',
      port: 3306,
      username: 'root',
      password: '',
      database: 'manutencao_db',
      autoLoadEntities: true,
      synchronize: true,
    }),
    AuthModule,
    InspecoesModule,
    MaquinasModule,
    HorasModule,
    NotificacoesModule,
    DashboardModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
