import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Maquina } from '../../maquinas/entities/maquina.entity';
import { Usuario } from '../../auth/entities/usuario.entity';

@Entity('notificacoes')
export class Notificacao {
  @PrimaryGeneratedColumn({ type: 'bigint', unsigned: true })
  id: number;

  @Column({ type: 'bigint', unsigned: true })
  usuario_id: number;

  @Column({ type: 'bigint', unsigned: true, nullable: true })
  maquina_id?: number;

  @Column({
    type: 'enum',
    enum: ['MANUTENCAO', 'HORAS', 'SISTEMA', 'AVISO'],
    default: 'AVISO',
  })
  tipo: 'MANUTENCAO' | 'HORAS' | 'SISTEMA' | 'AVISO';

  @Column({ length: 200 })
  titulo: string;

  @Column({ type: 'text' })
  mensagem: string;

  @Column({ type: 'int', default: 0 })
  lida: number;

  @CreateDateColumn({ type: 'datetime' })
  criada_em: Date;

  @ManyToOne(() => Usuario, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'usuario_id' })
  usuario?: Usuario;

  @ManyToOne(() => Maquina, { onDelete: 'SET NULL', nullable: true })
  @JoinColumn({ name: 'maquina_id' })
  maquina?: Maquina;
}
