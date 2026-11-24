import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('maquinas')
export class Maquina {
  @PrimaryGeneratedColumn({ type: 'bigint', unsigned: true })
  id: number;

  @Column({ length: 150 })
  nome: string;

  @Column({ length: 80, unique: true })
  codigo: string;

  @Column({ length: 100 })
  tipo: string;

  @Column({ length: 120 })
  fabricante: string;

  @Column({ length: 120 })
  modelo: string;

  @Column({ type: 'decimal', precision: 10, scale: 2, default: 0.0 })
  horimetro_atual: number;

  @Column({
    type: 'enum',
    enum: ['ATIVA', 'EM_MANUTENCAO', 'INATIVA'],
    default: 'ATIVA',
  })
  status: 'ATIVA' | 'EM_MANUTENCAO' | 'INATIVA';

  @CreateDateColumn({ type: 'datetime' })
  criada_em: Date;
}
