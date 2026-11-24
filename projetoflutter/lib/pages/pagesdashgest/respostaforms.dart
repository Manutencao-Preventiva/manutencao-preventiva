import 'package:flutter/material.dart';
import 'package:projetoflutter/pages/dashges.dart';
import 'package:projetoflutter/pages/pagesdashgest/graficos.dart';
import 'package:projetoflutter/pages/perfil.dart';
import 'package:projetoflutter/session.dart';

const _fundo = Color(0xFF101012);
const _cartao = Color(0xFF1A1A1E);
const _vermelho = Color(0xFFB00404);

class Respostaforms extends StatefulWidget {
  final int abaInicial;
  const Respostaforms({super.key, this.abaInicial = 2});

  @override
  State<Respostaforms> createState() => _RespostaformsState();
}

class _RespostaformsState extends State<Respostaforms> {
  final TextEditingController _buscaController = TextEditingController();
  late int _abaSelecionada;
  String _termoBusca = '';

  @override
  void initState() {
    super.initState();
    _abaSelecionada = widget.abaInicial;
    _recarregar();
  }

  Future<void> _recarregar() async {
    await Future.wait([
      AppSession.carregarDadosCompletosDoBanco(),
      AppSession.carregarRegistrosDoBanco(),
    ]);
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
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
                        builder: (context, checklists, _) {
                          return ListView(
                            padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                            children: [
                              const Text(
                                'Formulários & Registros',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      'Histórico de apontamento de horas, notificações do sistema e checklists NR-12.',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.65,
                                        ),
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.refresh,
                                      color: Colors.white70,
                                    ),
                                    tooltip: 'Recarregar dados do banco',
                                    onPressed: _recarregar,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              Container(
                                decoration: BoxDecoration(
                                  color: _cartao.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.12),
                                  ),
                                ),
                                child: TextField(
                                  controller: _buscaController,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  onChanged: (val) {
                                    setState(() => _termoBusca = val.trim());
                                  },
                                  decoration: InputDecoration(
                                    hintText:
                                        'Buscar por máquina, operador ou texto...',
                                    hintStyle: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.4,
                                      ),
                                      fontSize: 13,
                                    ),
                                    prefixIcon: Icon(
                                      Icons.search,
                                      color: Colors.white.withValues(
                                        alpha: 0.5,
                                      ),
                                      size: 20,
                                    ),
                                    suffixIcon: _termoBusca.isNotEmpty
                                        ? IconButton(
                                            icon: const Icon(
                                              Icons.clear,
                                              color: Colors.white70,
                                              size: 18,
                                            ),
                                            onPressed: () {
                                              _buscaController.clear();
                                              setState(() => _termoBusca = '');
                                            },
                                          )
                                        : null,
                                    border: InputBorder.none,
                                    contentPadding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                      horizontal: 10,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _abaChip(
                                      indice: 0,
                                      titulo:
                                          'Apontamento de Horas (${dashboard.ultimasHoras.length})',
                                      icone: Icons.timer_outlined,
                                    ),
                                    const SizedBox(width: 8),
                                    _abaChip(
                                      indice: 1,
                                      titulo:
                                          'Notificações & Alertas (${dashboard.ultimasNotificacoes.length})',
                                      icone: Icons.notifications_none_rounded,
                                    ),
                                    const SizedBox(width: 8),
                                    _abaChip(
                                      indice: 2,
                                      titulo:
                                          'Checklists NR-12 (${checklists.length})',
                                      icone:
                                          Icons.assignment_turned_in_outlined,
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 18),

                              if (_abaSelecionada == 0)
                                _secaoHoras(dashboard)
                              else if (_abaSelecionada == 1)
                                _secaoNotificacoes(dashboard)
                              else
                                _secaoChecklists(checklists),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
                _navegacao(context, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _abaChip({
    required int indice,
    required String titulo,
    required IconData icone,
  }) {
    final selecionado = _abaSelecionada == indice;

    return InkWell(
      onTap: () => setState(() => _abaSelecionada = indice),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selecionado ? _vermelho : _cartao.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selecionado
                ? _vermelho
                : Colors.white.withValues(alpha: 0.12),
            width: selecionado ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icone,
              size: 15,
              color: selecionado ? Colors.white : Colors.white70,
            ),
            const SizedBox(width: 6),
            Text(
              titulo,
              style: TextStyle(
                color: selecionado ? Colors.white : Colors.white70,
                fontSize: 12,
                fontWeight: selecionado ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _secaoHoras(DashboardResumoModel dashboard) {
    final filtradas = dashboard.ultimasHoras.where((h) {
      if (_termoBusca.isEmpty) return true;
      final busca = _termoBusca.toLowerCase();
      return h.nomeMaquina.toLowerCase().contains(busca) ||
          h.nomeOperador.toLowerCase().contains(busca) ||
          h.observacoes.toLowerCase().contains(busca) ||
          h.dataOperacao.contains(busca);
    }).toList();

    if (filtradas.isEmpty) {
      return _painelVazio('Nenhum apontamento de horas encontrado.');
    }

    return Column(
      children: filtradas.map((hora) {
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cartao.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      hora.nomeMaquina.isNotEmpty
                          ? hora.nomeMaquina
                          : 'Máquina #${hora.maquinaId}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
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
                      color: Colors.cyan.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: Colors.cyanAccent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Text(
                      '+${hora.horasTrabalhadas.toStringAsFixed(1)} horas',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hora.dataOperacao,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Icon(
                    Icons.person_outline_rounded,
                    size: 13,
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    hora.nomeOperador.isNotEmpty
                        ? hora.nomeOperador
                        : 'Operador #${hora.usuarioId}',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Horímetro Início: ${hora.horimetroInicio.toStringAsFixed(1)} h',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      size: 12,
                      color: Colors.white38,
                    ),
                    Text(
                      'Horímetro Fim: ${hora.horimetroFim.toStringAsFixed(1)} h',
                      style: const TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              if (hora.observacoes.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Observação: "${hora.observacoes}"',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _secaoNotificacoes(DashboardResumoModel dashboard) {
    final filtradas = dashboard.ultimasNotificacoes.where((n) {
      if (_termoBusca.isEmpty) return true;
      final busca = _termoBusca.toLowerCase();
      return n.titulo.toLowerCase().contains(busca) ||
          n.mensagem.toLowerCase().contains(busca) ||
          n.tipo.toLowerCase().contains(busca) ||
          n.nomeMaquina.toLowerCase().contains(busca);
    }).toList();

    if (filtradas.isEmpty) {
      return _painelVazio('Nenhuma notificação encontrada.');
    }

    return Column(
      children: filtradas.map((notif) {
        final cor = _corTipoNotificacao(notif.tipo);

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _cartao.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notif.lida ? Colors.white10 : cor.withValues(alpha: 0.4),
              width: notif.lida ? 1 : 1.3,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: cor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      notif.tipo,
                      style: TextStyle(
                        color: cor,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!notif.lida)
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () =>
                          AppSession.marcarNotificacaoLida(notif.id),
                      icon: const Icon(
                        Icons.done_all,
                        color: Colors.greenAccent,
                        size: 14,
                      ),
                      label: const Text(
                        'Marcar como lida',
                        style: TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 11,
                        ),
                      ),
                    )
                  else
                    const Text(
                      'Lida',
                      style: TextStyle(color: Colors.white38, fontSize: 11),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                notif.titulo,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: notif.lida ? FontWeight.normal : FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                notif.mensagem,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
              if (notif.nomeMaquina.isNotEmpty) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.precision_manufacturing_rounded,
                      size: 13,
                      color: Colors.white38,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Máquina: ${notif.nomeMaquina}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _secaoChecklists(List<RegistroRecente> checklists) {
    final filtrados = checklists.where((c) {
      if (_termoBusca.isEmpty) return true;
      final busca = _termoBusca.toLowerCase();
      return c.equipamento.toLowerCase().contains(busca) ||
          c.operador.toLowerCase().contains(busca) ||
          c.observacao.toLowerCase().contains(busca);
    }).toList();

    if (filtrados.isEmpty) {
      return _painelVazio('Nenhum checklist NR-12 encontrado.');
    }

    return Column(
      children: filtrados.map((registro) {
        final temAlerta = registro.temAlerta;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: _cartao.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: temAlerta
                  ? Colors.orangeAccent.withValues(alpha: 0.4)
                  : Colors.white10,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _modalAuditoriaChecklist(context, registro),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            registro.equipamento,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: temAlerta
                                ? Colors.orangeAccent.withValues(alpha: 0.15)
                                : Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(
                            temAlerta ? 'Com Ressalva' : 'Conforme',
                            style: TextStyle(
                              color: temAlerta
                                  ? Colors.orangeAccent
                                  : Colors.greenAccent,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Operador: ${registro.operador} • Turno: ${registro.turno}',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                    if (registro.observacao.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        'Obs: "${registro.observacao}"',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _modalAuditoriaChecklist(
    BuildContext context,
    RegistroRecente registro,
  ) {
    AppSession.marcarComoVisto(registro.id);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141417),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.all(18),
              child: ListView(
                controller: scrollController,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        registro.equipamento,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12),
                  const SizedBox(height: 8),
                  Text(
                    'Operador: ${registro.operador}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Turno: ${registro.turno}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  Text(
                    'Status: ${registro.status}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                  if (registro.observacao.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        'Observações: ${registro.observacao}',
                        style: const TextStyle(color: Colors.white60),
                      ),
                    ),
                  const SizedBox(height: 14),
                  const Text(
                    'Itens Inspecionados:',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...registro.respostasDetalhadas.map((item) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: item.isAlerta
                            ? Colors.redAccent.withValues(alpha: 0.15)
                            : Colors.white.withValues(alpha: 0.03),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: item.isAlerta
                              ? Colors.redAccent.withValues(alpha: 0.4)
                              : Colors.white10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            item.isAlerta
                                ? Icons.cancel_outlined
                                : Icons.check_circle_outline,
                            color: item.isAlerta
                                ? Colors.redAccent
                                : Colors.greenAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              item.pergunta,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          Text(
                            item.resposta,
                            style: TextStyle(
                              color: item.isAlerta
                                  ? Colors.redAccent
                                  : Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _modalRegistrarHoras(BuildContext context) {
    final maquinas = AppSession.dashboard.maquinas;
    if (maquinas.isEmpty) return;

    int maquinaId = maquinas.first.id;
    final horasCtrl = TextEditingController(text: '4.0');
    final horimetroInicioCtrl = TextEditingController(
      text: maquinas.first.horimetroAtual.toStringAsFixed(1),
    );
    final horimetroFimCtrl = TextEditingController(
      text: (maquinas.first.horimetroAtual + 4.0).toStringAsFixed(1),
    );
    final obsCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF161619),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
                left: 20,
                right: 20,
                top: 20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Apontar Horas de Operação',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 14),
                  DropdownButtonFormField<int>(
                    value: maquinaId,
                    dropdownColor: _cartao,
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    decoration: const InputDecoration(
                      labelText: 'Máquina',
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                    items: maquinas.map((m) {
                      return DropdownMenuItem<int>(
                        value: m.id,
                        child: Text('${m.codigo} - ${m.nome}'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          maquinaId = val;
                          final maqSel = maquinas.firstWhere(
                            (m) => m.id == val,
                          );
                          horimetroInicioCtrl.text = maqSel.horimetroAtual
                              .toStringAsFixed(1);
                          final h = double.tryParse(horasCtrl.text) ?? 4.0;
                          horimetroFimCtrl.text = (maqSel.horimetroAtual + h)
                              .toStringAsFixed(1);
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: horasCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Horas Trabalhadas',
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                    onChanged: (val) {
                      final h = double.tryParse(val) ?? 0.0;
                      final inicio =
                          double.tryParse(horimetroInicioCtrl.text) ?? 0.0;
                      horimetroFimCtrl.text = (inicio + h).toStringAsFixed(1);
                    },
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: obsCtrl,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Observações da Atividade',
                      labelStyle: TextStyle(color: Colors.white60),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _vermelho,
                      ),
                      onPressed: () async {
                        final horas = double.tryParse(horasCtrl.text) ?? 1.0;
                        final inicio =
                            double.tryParse(horimetroInicioCtrl.text) ?? 0.0;
                        final fim =
                            double.tryParse(horimetroFimCtrl.text) ??
                            (inicio + horas);

                        Navigator.pop(ctx);
                        await AppSession.registrarHoras(
                          maquinaId: maquinaId,
                          horasTrabalhadas: horas,
                          horimetroInicio: inicio,
                          horimetroFim: fim,
                          observacoes: obsCtrl.text.trim(),
                        );
                      },
                      child: const Text(
                        'Salvar no Banco',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _painelVazio(String texto) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(
        color: _cartao.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          Icon(
            Icons.find_in_page_outlined,
            color: Colors.white.withValues(alpha: 0.35),
            size: 40,
          ),
          const SizedBox(height: 10),
          Text(
            texto,
            style: const TextStyle(color: Colors.white70, fontSize: 13),
          ),
        ],
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
