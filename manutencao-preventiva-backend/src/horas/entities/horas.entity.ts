import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, ManyToOne, JoinColumn } from 'typeorm';
import { Maquina } from '../../maquinas/entities/maquina.entity';
import { Usuario } from '../../auth/entities/usuario.entity';

@Entity('horas')
export class Horas {
  @PrimaryGeneratedColumn({ type: 'bigint', unsigned: true })
  id: number;

  @Column({ type: 'bigint', unsigned: true })
  maquina_id: number;

  @Column({ type: 'bigint', unsigned: true })
  usuario_id: number;

  @Column({ type: 'date' })
  data_operacao: string;

  @Column({ type: 'decimal', precision: 8, scale: 2 })
  horas_trabalhadas: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  horimetro_inicio: number;

  @Column({ type: 'decimal', precision: 10, scale: 2 })
  horimetro_fim: number;

  @Column({ type: 'text', nullable: true })
  observacoes?: string;

  @CreateDateColumn({ type: 'datetime' })
  criado_em: Date;

  @ManyToOne(() => Maquina, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'maquina_id' })
  maquina?: Maquina;

  @ManyToOne(() => Usuario, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'usuario_id' })
  usuario?: Usuario;
}
