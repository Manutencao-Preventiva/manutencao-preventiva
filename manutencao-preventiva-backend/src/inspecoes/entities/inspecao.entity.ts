import {
  Entity,
  PrimaryGeneratedColumn,
  Column,
  CreateDateColumn,
} from 'typeorm';

@Entity('inspecoes_nr12')
export class Inspecao {
  @PrimaryGeneratedColumn()
  id: number;

  @Column({ type: 'varchar', length: 200, default: 'Checklist NR-12 Torno Mecânico' })
  titulo: string;

  @Column({ type: 'varchar', length: 150 })
  equipamento: string;

  @Column({ type: 'varchar', length: 150 })
  operador: string;

  @Column({ type: 'varchar', length: 180, default: '' })
  emailOperador: string;

  @Column({ type: 'varchar', length: 100, default: 'Manhã (7h30-11h30)' })
  turno: string;

  @Column({ type: 'varchar', length: 150, default: '' })
  curso: string;

  @Column({ type: 'datetime' })
  data: Date;

  @Column({ type: 'varchar', length: 50, default: 'Concluído' })
  status: string;

  @Column({ type: 'text', nullable: true })
  observacao: string;

  @Column({ type: 'longtext', nullable: true })
  respostasJson: string;

  @Column({ type: 'boolean', default: false })
  vistoPeloGestor: boolean;

  @CreateDateColumn()
  criado_em: Date;
}
