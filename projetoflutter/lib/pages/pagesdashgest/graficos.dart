import 'package:flutter/material.dart';
import 'package:projetoflutter/pages/dashges.dart';
import 'package:projetoflutter/pages/pagesdashgest/respostaforms.dart';
import 'package:projetoflutter/pages/perfil.dart';
import 'package:projetoflutter/session.dart';

const _fundo = Color(0xFF101012);
const _cartao = Color(0xFF1A1A1E);
const _vermelho = Color(0xFFB00404);

class Graficos extends StatefulWidget {
  const Graficos({super.key});

  @override
  State<Graficos> createState() => _GraficosState();
}

class _GraficosState extends State<Graficos> {
  @override
  void initState() {
    super.initState();
    AppSession.carregarDadosCompletosDoBanco();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _fundo,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/image.png', fit: BoxFit.cover),
          ),
          SafeArea(
            child: Column(
              children: [
                _cabecalho(context),
                Expanded(
                  child: ValueListenableBuilder<DashboardResumoModel>(
                    valueListenable: AppSession.dashboardNotifier,
                    builder: (context, dashboard, _) {
                      return ValueListenableBuilder<List<RegistroRecente>>(
                        valueListenable: AppSession.registrosRecentesNotifier,
                        builder: (context, registros, _) {
                          return _conteudo(dashboard, registros);
                        },
                      );
                    },
                  ),
                ),
                _navegacao(context, 1),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _conteudo(DashboardResumoModel db, List<RegistroRecente> registros) {
    final totalInspecoes = registros.length;
    final comRessalva = registros.where((r) => r.temAlerta).length;
    final conformes = totalInspecoes - comRessalva;
    final percDisponibilidade = db.totalMaquinas == 0
        ? 0.0
        : (db.maquinasAtivas / db.totalMaquinas);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
      children: [
        const Text(
          'Indicadores & Gráficos',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Métricas consolidadas do parque fabril e histórico de operações.',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.65),
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 18),

        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.6,
          children: [
            _indicador(
              'Horas Operadas',
              '${db.totalHorasTrabalhadas.toStringAsFixed(1)}h',
              Icons.timer_rounded,
              Colors.cyanAccent,
            ),
            _indicador(
              'Disponibilidade',
              '${(percDisponibilidade * 100).round()}%',
              Icons.check_circle_outline,
              Colors.greenAccent,
            ),
            _indicador(
              'Máq. Manutenção',
              '${db.maquinasEmManutencao}',
              Icons.build_circle_outlined,
              Colors.orangeAccent,
            ),
            _indicador(
              'Total de Alertas',
              '${db.totalNotificacoes}',
              Icons.notifications_active_outlined,
              Colors.redAccent,
            ),
          ],
        ),

        const SizedBox(height: 16),

        _painel(
          titulo: 'Horas Trabalhadas por Máquina (Tabela Horas)',
          icone: Icons.bar_chart_rounded,
          child: db.horasPorMaquina.isEmpty
              ? _vazio('Nenhum registro de horas no banco.')
              : Column(
                  children: db.horasPorMaquina.map((item) {
                    final nome = item['nome']?.toString() ?? 'Máquina';
                    final codigo = item['codigo']?.toString() ?? '';
                    final horas =
                        double.tryParse(item['horas']?.toString() ?? '0') ??
                        0.0;
                    final maxHoras = db.totalHorasTrabalhadas > 0
                        ? db.totalHorasTrabalhadas
                        : 10.0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  '$nome ($codigo)',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Text(
                                '${horas.toStringAsFixed(1)} h',
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (horas / maxHoras).clamp(0.0, 1.0),
                              minHeight: 8,
                              backgroundColor: Colors.white12,
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.cyanAccent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),

        const SizedBox(height: 16),

        _painel(
          titulo: 'Status das Máquinas no Parque Fabril',
          icone: Icons.pie_chart_outline_rounded,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  height: 14,
                  child: Row(
                    children: [
                      if (db.maquinasAtivas > 0)
                        Expanded(
                          flex: db.maquinasAtivas,
                          child: Container(color: Colors.greenAccent),
                        ),
                      if (db.maquinasEmManutencao > 0)
                        Expanded(
                          flex: db.maquinasEmManutencao,
                          child: Container(color: Colors.orangeAccent),
                        ),
                      if (db.maquinasInativas > 0)
                        Expanded(
                          flex: db.maquinasInativas,
                          child: Container(color: Colors.redAccent),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _legenda(
                Colors.greenAccent,
                'Operando normalmente (Ativas)',
                db.maquinasAtivas,
              ),
              const SizedBox(height: 6),
              _legenda(
                Colors.orangeAccent,
                'Em manutenção ou revisão',
                db.maquinasEmManutencao,
              ),
              const SizedBox(height: 6),
              _legenda(
                Colors.redAccent,
                'Inativas / Paradas',
                db.maquinasInativas,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _painel(
          titulo: 'Notificações por Tipo (Tabela Notificações)',
          icone: Icons.notification_important_outlined,
          child: Column(
            children: [
              _barraProgressoSimples(
                'Manutenção Preventiva',
                db.alertasPorTipo['MANUTENCAO'] ?? 0,
                db.totalNotificacoes,
                Colors.redAccent,
              ),
              _barraProgressoSimples(
                'Horímetro / Horas',
                db.alertasPorTipo['HORAS'] ?? 0,
                db.totalNotificacoes,
                Colors.cyanAccent,
              ),
              _barraProgressoSimples(
                'Avisos de Operação',
                db.alertasPorTipo['AVISO'] ?? 0,
                db.totalNotificacoes,
                Colors.orangeAccent,
              ),
              _barraProgressoSimples(
                'Sistema e Protocolos',
                db.alertasPorTipo['SISTEMA'] ?? 0,
                db.totalNotificacoes,
                Colors.blueAccent,
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        _painel(
          titulo: 'Horímetro Acumulado (Uso Total)',
          icone: Icons.speed_rounded,
          child: Column(
            children: db.maquinas.map((maq) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        '${maq.codigo} - ${maq.nome}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        '${maq.horimetroAtual.toStringAsFixed(1)} h',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),

        const SizedBox(height: 16),

        _painel(
          titulo: 'Conformidade dos Checklists NR-12',
          icone: Icons.assignment_turned_in_outlined,
          child: totalInspecoes == 0
              ? _vazio('Nenhuma inspeção realizada ainda.')
              : Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: LinearProgressIndicator(
                              value: totalInspecoes == 0
                                  ? 0
                                  : conformes / totalInspecoes,
                              minHeight: 12,
                              backgroundColor: Colors.orangeAccent.withValues(
                                alpha: 0.5,
                              ),
                              valueColor: const AlwaysStoppedAnimation(
                                Colors.greenAccent,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          '${((conformes / totalInspecoes) * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _legenda(Colors.greenAccent, 'Conformes', conformes),
                    const SizedBox(height: 5),
                    _legenda(Colors.orangeAccent, 'Com Ressalva', comRessalva),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _indicador(String titulo, String valor, IconData icone, Color cor) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cor.withValues(alpha: 0.28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icone, color: cor, size: 22),
          Text(
            valor,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
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
    );
  }

  Widget _painel({
    required String titulo,
    required IconData icone,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icone, color: const Color(0xFFE53935), size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _barraProgressoSimples(
    String label,
    int quantidade,
    int total,
    Color cor,
  ) {
    final proporcao = total == 0 ? 0.0 : quantidade / total;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                '$quantidade',
                style: TextStyle(
                  color: cor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: proporcao.clamp(0.0, 1.0),
              minHeight: 6,
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(cor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legenda(Color cor, String titulo, int valor) => Row(
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: cor, shape: BoxShape.circle),
      ),
      const SizedBox(width: 7),
      Expanded(
        child: Text(
          titulo,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ),
      Text(
        '$valor',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );

  Widget _vazio(String texto) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Text(
      texto,
      style: const TextStyle(color: Colors.white54, fontSize: 13),
    ),
  );
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
