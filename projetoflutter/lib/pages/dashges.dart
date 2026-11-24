import 'package:flutter/material.dart';
import 'package:projetoflutter/pages/pagesdashgest/graficos.dart';
import 'package:projetoflutter/pages/pagesdashgest/respostaforms.dart';
import 'package:projetoflutter/pages/perfil.dart';
import 'package:projetoflutter/session.dart';

const _fundo = Color(0xFF101012);
const _cartao = Color(0xFF1A1A1E);
const _vermelho = Color(0xFFB00404);

class Dashges extends StatefulWidget {
  const Dashges({super.key});

  @override
  State<Dashges> createState() => _DashgesState();
}

class _DashgesState extends State<Dashges> {
  bool _carregando = false;

  @override
  void initState() {
    super.initState();
    _atualizarDados();
  }

  Future<void> _atualizarDados() async {
    setState(() => _carregando = true);
    await Future.wait([
      AppSession.carregarDadosCompletosDoBanco(),
      AppSession.carregarRegistrosDoBanco(),
    ]);
    if (mounted) {
      setState(() => _carregando = false);
    }
  }

  String _obterIconeEquipamento(String equipamento) {
    final lower = equipamento.toLowerCase();
    if (lower.contains('torno')) {
      return 'assets/icone-torno-mecanico.png';
    } else if (lower.contains('fresadora') || lower.contains('fresa')) {
      return 'assets/icone-fresadora-vertical.png';
    }
    return 'assets/icone-escudo-check.png';
  }

  Color _corStatusMaquina(String status) {
    switch (status) {
      case 'ATIVA':
        return Colors.greenAccent;
      case 'EM_MANUTENCAO':
        return Colors.orangeAccent;
      case 'INATIVA':
        return Colors.redAccent;
      default:
        return Colors.white54;
    }
  }

  String _textoStatusMaquina(String status) {
    switch (status) {
      case 'ATIVA':
        return 'Operando';
      case 'EM_MANUTENCAO':
        return 'Manutenção';
      case 'INATIVA':
        return 'Inativa';
      default:
        return status;
    }
  }

  Color _corTipoNotificacao(String tipo) {
    switch (tipo) {
      case 'MANUTENCAO':
        return Colors.redAccent;
      case 'HORAS':
        return Colors.cyanAccent;
      case 'AVISO':
        return Colors.orangeAccent;
      case 'SISTEMA':
        return Colors.blueAccent;
      default:
        return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                _cabecalho(context),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _atualizarDados,
                    color: _vermelho,
                    child: ValueListenableBuilder<DashboardResumoModel>(
                      valueListenable: AppSession.dashboardNotifier,
                      builder: (context, dashboard, _) {
                        return ListView(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Olá, ${AppSession.nome.split(' ').first}',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.75,
                                        ),
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Painel do Gestor',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    if (_carregando)
                                      const Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: SizedBox(
                                          width: 16,
                                          height: 16,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                    IconButton(
                                      tooltip: 'Atualizar dados do banco',
                                      icon: const Icon(
                                        Icons.refresh_rounded,
                                        color: Colors.white,
                                      ),
                                      onPressed: _carregando
                                          ? null
                                          : _atualizarDados,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _vermelho.withValues(
                                          alpha: 0.25,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: _vermelho.withValues(
                                            alpha: 0.6,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              childAspectRatio: 1.6,
                              children: [
                                _cardKpi(
                                  titulo: 'Máquinas Ativas',
                                  valor:
                                      '${dashboard.maquinasAtivas} / ${dashboard.totalMaquinas}',
                                  icone: Icons.precision_manufacturing_rounded,
                                  cor: Colors.greenAccent,
                                  subtexto: 'Parque fabril operacional',
                                ),
                                _cardKpi(
                                  titulo: 'Horas Operadas',
                                  valor:
                                      '${dashboard.totalHorasTrabalhadas.toStringAsFixed(1)}h',
                                  icone: Icons.access_time_filled_rounded,
                                  cor: Colors.cyanAccent,
                                  subtexto: 'Apontamentos registrados',
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Respostaforms(),
                                    ),
                                  ),
                                ),
                                _cardKpi(
                                  titulo: 'Em Manutenção',
                                  valor: '${dashboard.maquinasEmManutencao}',
                                  icone: Icons.build_circle_outlined,
                                  cor: Colors.orangeAccent,
                                  subtexto: 'Revisão ou reparo',
                                ),
                                _cardKpi(
                                  titulo: 'Alertas Pendentes',
                                  valor: '${dashboard.notificacoesNaoLidas}',
                                  icone: Icons.notifications_active_outlined,
                                  cor: Colors.redAccent,
                                  subtexto:
                                      '${dashboard.totalNotificacoes} emitidos no total',
                                  onTap: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Respostaforms(),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            const Text(
                              'Módulos de Gestão',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),

                            _moduloCard(
                              titulo: 'Gráficos e Indicadores',
                              subtitulo:
                                  'Horímetro, horas trabalhadas por máquina e métricas de manutenção',
                              assetIcone: 'assets/grafico-preditivo.png',
                              textoBotao: 'Abrir Gráficos',
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Graficos(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            _moduloCard(
                              titulo: 'Apontamentos, Horas e Alertas',
                              subtitulo:
                                  'Auditoria de horas trabalhadas, notificações e checklists NR-12',
                              assetIcone: 'assets/formularios-do-google.png',
                              textoBotao: 'Ver Apontamentos e Formulários',
                              onTap: () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const Respostaforms(),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Parque de Máquinas (Banco de Dados)',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${dashboard.maquinas.length} máquinas',
                                  style: const TextStyle(
                                    color: Colors.white54,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            _gridMaquinasReais(dashboard.maquinas),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Alertas e Notificações Recentes',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Respostaforms(),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Ver todos',
                                    style: TextStyle(
                                      color: _vermelho,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            if (dashboard.ultimasNotificacoes.isEmpty)
                              _painelVazio('Nenhuma notificação registrada.')
                            else
                              ...dashboard.ultimasNotificacoes
                                  .take(3)
                                  .map((n) => _cardNotificacao(n)),

                            const SizedBox(height: 24),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Apontamento de Horas Recente',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Respostaforms(),
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: const Text(
                                    'Histórico',
                                    style: TextStyle(
                                      color: _vermelho,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            if (dashboard.ultimasHoras.isEmpty)
                              _painelVazio(
                                'Nenhum apontamento de horas registrado.',
                              )
                            else
                              ...dashboard.ultimasHoras
                                  .take(3)
                                  .map((h) => _cardHoras(h)),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                _navegacao(context, 0),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardKpi({
    required String titulo,
    required String valor,
    required IconData icone,
    required Color cor,
    String? subtexto,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(icone, color: cor, size: 22),
                    if (onTap != null)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withValues(alpha: 0.3),
                        size: 12,
                      ),
                  ],
                ),
                Text(
                  valor,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                  ),
                ),
                Text(
                  titulo,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _moduloCard({
    required String titulo,
    required String subtitulo,
    required String assetIcone,
    required String textoBotao,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  child: Image.asset(assetIcone, fit: BoxFit.contain),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        titulo,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitulo,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            textoBotao,
                            style: const TextStyle(
                              color: _vermelho,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 11,
                            color: _vermelho,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _gridMaquinasReais(List<MaquinaModel> maquinas) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: maquinas.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 1.45,
      ),
      itemBuilder: (context, index) {
        final maq = maquinas[index];
        final corStatus = _corStatusMaquina(maq.status);
        final textoStatus = _textoStatusMaquina(maq.status);

        return InkWell(
          onTap: () => _modalDetalhesMaquina(maq),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: _cartao.withValues(alpha: 0.9),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: corStatus.withValues(alpha: 0.35)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        maq.codigo,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: corStatus.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        textoStatus,
                        style: TextStyle(
                          color: corStatus,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  maq.nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.timer_outlined,
                      size: 12,
                      color: Colors.cyanAccent,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${maq.horimetroAtual.toStringAsFixed(1)} h',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _modalDetalhesMaquina(MaquinaModel maq) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161619),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.asset(
                      _obterIconeEquipamento(maq.nome),
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          maq.nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Código: ${maq.codigo} • Tipo: ${maq.tipo}',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white12),
              const SizedBox(height: 10),
              _itemInfoModal(
                'Fabricante:',
                maq.fabricante.isNotEmpty ? maq.fabricante : 'Não especificado',
              ),
              _itemInfoModal(
                'Modelo:',
                maq.modelo.isNotEmpty ? maq.modelo : 'Não especificado',
              ),
              _itemInfoModal(
                'Horímetro Atual:',
                '${maq.horimetroAtual.toStringAsFixed(2)} horas',
              ),
              _itemInfoModal(
                'Status Atual:',
                maq.status,
                corValor: _corStatusMaquina(maq.status),
              ),
              const SizedBox(height: 20),
              const Text(
                'Alterar Status da Máquina no Banco:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withValues(alpha: 0.2),
                        side: const BorderSide(color: Colors.greenAccent),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await AppSession.alterarStatusMaquina(maq.id, 'ATIVA');
                      },
                      child: const Text(
                        'Operando',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.withValues(alpha: 0.2),
                        side: const BorderSide(color: Colors.orangeAccent),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await AppSession.alterarStatusMaquina(
                          maq.id,
                          'EM_MANUTENCAO',
                        );
                      },
                      child: const Text(
                        'Manutenção',
                        style: TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.withValues(alpha: 0.2),
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                      onPressed: () async {
                        Navigator.pop(ctx);
                        await AppSession.alterarStatusMaquina(
                          maq.id,
                          'INATIVA',
                        );
                      },
                      child: const Text(
                        'Inativa',
                        style: TextStyle(color: Colors.redAccent, fontSize: 11),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _itemInfoModal(String label, String valor, {Color? corValor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.55),
              fontSize: 12,
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              color: corValor ?? Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardNotificacao(NotificacaoModel notif) {
    final corTipo = _corTipoNotificacao(notif.tipo);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: notif.lida ? Colors.white10 : corTipo.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: corTipo.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              notif.tipo == 'MANUTENCAO'
                  ? Icons.warning_amber_rounded
                  : (notif.tipo == 'HORAS'
                        ? Icons.timer_outlined
                        : Icons.notifications_none_rounded),
              color: corTipo,
              size: 16,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notif.titulo,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: notif.lida
                              ? FontWeight.normal
                              : FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (!notif.lida)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: _vermelho,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'NOVA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  notif.mensagem,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _cardHoras(HorasModel hora) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.cyan.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.history_toggle_off_rounded,
              color: Colors.cyanAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hora.nomeMaquina.isNotEmpty
                          ? hora.nomeMaquina
                          : 'Máquina #${hora.maquinaId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '+${hora.horasTrabalhadas.toStringAsFixed(1)} horas',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Data: ${hora.dataOperacao} • Horímetro: ${hora.horimetroInicio.toStringAsFixed(1)}h ➔ ${hora.horimetroFim.toStringAsFixed(1)}h',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 10,
                  ),
                ),
                if (hora.observacoes.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      'Obs: "${hora.observacoes}"',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _painelVazio(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white10),
      ),
      child: Center(
        child: Text(
          texto,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

Widget _cabecalho(BuildContext context) => Padding(
  padding: const EdgeInsets.fromLTRB(12, 4, 12, 0),
  child: Row(
    children: [
      const Expanded(
        child: Text(
          'Área do gestor',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
      ),
      IconButton(
        tooltip: 'Perfil',
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => Perfil()),
        ),
        icon: const Icon(Icons.person, color: Colors.white),
      ),
    ],
  ),
);

Widget _navegacao(BuildContext context, int selecionado) => Container(
  decoration: const BoxDecoration(
    border: Border(top: BorderSide(color: Colors.white24)),
  ),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      _itemNavegacao(
        context,
        0,
        selecionado,
        'assets/painel.png',
        const Dashges(),
      ),
      _itemNavegacao(
        context,
        1,
        selecionado,
        'assets/grafico-preditivo.png',
        const Graficos(),
      ),
      _itemNavegacao(
        context,
        2,
        selecionado,
        'assets/formularios-do-google.png',
        const Respostaforms(),
      ),
    ],
  ),
);

Widget _itemNavegacao(
  BuildContext context,
  int indice,
  int selecionado,
  String asset,
  Widget destino,
) => IconButton(
  tooltip: ['Painel', 'Gráficos', 'Respostas'][indice],
  onPressed: indice == selecionado
      ? null
      : () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => destino),
        ),
  icon: Image.asset(
    asset,
    width: 25,
    height: 25,
    color: indice == selecionado ? Colors.white : Colors.grey,
  ),
);
