import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn } from 'typeorm';

@Entity('usuarios')
export class Usuario {
  @PrimaryGeneratedColumn({ type: 'bigint', unsigned: true })
  id: number;

  @Column({ length: 150 })
  nome: string;

  @Column({ length: 180, unique: true })
  email: string;

  @Column({ length: 255 })
  senha: string;

  @Column({
    type: 'enum',
    enum: ['ADMIN', 'GESTOR', 'OPERADOR', 'MANUTENCAO'],
    default: 'OPERADOR',
  })
  perfil: 'ADMIN' | 'GESTOR' | 'OPERADOR' | 'MANUTENCAO';

  @Column({ type: 'int', default: 1 })
  ativo: number;

  @Column({ type: 'boolean', default: false })
  gestor: boolean;

  @Column({ nullable: true })
  telefone?: string;

  @CreateDateColumn({ type: 'datetime' })
  criado_em: Date;
}
