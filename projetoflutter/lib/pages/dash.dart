import 'package:flutter/material.dart';
import 'package:projetoflutter/pages/formularioNR12.dart';
import 'package:projetoflutter/pages/perfil.dart';
import 'package:projetoflutter/session.dart';

class Dash extends StatefulWidget {
  const Dash({super.key});

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  Future<void> _abrirChecklist([String? equipamento]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Formularionr12(
          equipamentoInicial: equipamento,
        ),
      ),
    );
    if (mounted) {
      setState(() {});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/image.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Perfil()),
                          );
                        },
                        icon: Icon(Icons.person, color: Colors.white, size: 25),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Bom-Dia Operador',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        'Minha Área',
                        style: TextStyle(color: Colors.white, fontSize: 27),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 100,

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent,
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icone-escudo-check.png',
                                width: 75,
                                height: 75,
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    'Checklist pré-operacional NR-12',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'verifique a segurança antes de operar',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 250,
                                    height: 30,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0XFFB00404),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: () => _abrirChecklist(),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.play_arrow_rounded,
                                              color: Colors.white,
                                            ),
                                            Spacer(),
                                            Text(
                                              'Iniciar Checklist',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 100,

                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                        color: Colors.transparent,
                      ),

                      child: Column(
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/icone-documento-linhas.png',
                                width: 75,
                                height: 75,
                              ),
                              Spacer(),
                              Column(
                                children: [
                                  Text(
                                    'Nova Ordem de Serviço',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'regsitros falhas e atividades nao realizadas',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  SizedBox(height: 10),
                                  SizedBox(
                                    width: 250,
                                    height: 30,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Color(0XFFB00404),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.transparent,
                                          shadowColor: Colors.transparent,
                                        ),
                                        onPressed: () {},
                                        child: Row(
                                          children: [
                                            SizedBox(width: 7),
                                            Icon(
                                              Icons.description_outlined,
                                              color: Colors.white,
                                            ),
                                            Spacer(),
                                            Text(
                                              'Preencher Ordem',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Spacer(),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Escolha o equipamento',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Selecione a máquina para visualizar',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            'ou registrar atividades.',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEquipmentCard(
                          imagePath: 'assets/icone-torno-mecanico.png',
                          type: 'Torno Mecânico',
                          name: 'ROMI',
                          onTap: () => _abrirChecklist('Torno Mecânico ROMI'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildEquipmentCard(
                          imagePath: 'assets/icone-torno-mecanico.png',
                          type: 'Torno Mecânico',
                          name: 'NARDINI',
                          onTap: () => _abrirChecklist('Torno Mecânico NARDINI'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEquipmentCard(
                          imagePath: 'assets/icone-fresadora-vertical.png',
                          type: 'Fresadora',
                          name: 'KONI KFU-1',
                          onTap: () => _abrirChecklist('Fresadora KONI KFU-1'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildEquipmentCard(
                          imagePath: 'assets/icone-fresadora-vertical.png',
                          type: 'Fresadora',
                          name: 'KONI KFU-2',
                          onTap: () => _abrirChecklist('Fresadora KONI KFU-2'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Registros recentes',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _exibirTodosRegistros(context),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          'Ver tudo',
                          style: TextStyle(
                            color: Color(0xFFB00404),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ValueListenableBuilder<List<RegistroRecente>>(
                    valueListenable: AppSession.registrosRecentesNotifier,
                    builder: (context, registros, _) {
                      if (registros.isEmpty) {
                        return Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 22,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF141414).withValues(alpha: 0.75),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.08),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.assignment_outlined,
                                color: Colors.white.withValues(alpha: 0.35),
                                size: 34,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Nenhum registro recente',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Ao concluir o checklist NR-12, os dois registros mais recentes aparecerão aqui.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.45),
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      // Pega os 2 registros mais recentes
                      final maisRecentes = registros.take(2).toList();

                      return Column(
                        children: maisRecentes
                            .map(
                              (registro) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _buildRecentRecordCard(registro),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _obterIconeEquipamento(String equipamento) {
    final lower = equipamento.toLowerCase();
    if (lower.contains('torno')) {
      return 'assets/icone-torno-mecanico.png';
    } else if (lower.contains('fresadora')) {
      return 'assets/icone-fresadora-vertical.png';
    }
    return 'assets/icone-escudo-check.png';
  }

  String _formatarDataHora(DateTime data) {
    final now = DateTime.now();
    final isHoje =
        data.year == now.year && data.month == now.month && data.day == now.day;
    final hora = data.hour.toString().padLeft(2, '0');
    final min = data.minute.toString().padLeft(2, '0');

    if (isHoje) {
      return 'Hoje, $hora:$min';
    }
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes, $hora:$min';
  }

  Widget _buildRecentRecordCard(RegistroRecente registro) {
    final iconPath = _obterIconeEquipamento(registro.equipamento);
    final dataHoraStr = _formatarDataHora(registro.data);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _exibirDetalhesRegistro(context, registro),
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF141414).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 44,
                height: 44,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Image.asset(
                  iconPath,
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            registro.equipamento,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(
                                Icons.check_circle_rounded,
                                size: 10,
                                color: Colors.greenAccent,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'Concluído',
                                style: TextStyle(
                                  color: Colors.greenAccent,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      registro.titulo,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          dataHoraStr,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 11,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Icon(
                          Icons.person_outline_rounded,
                          size: 11,
                          color: Colors.white.withValues(alpha: 0.4),
                        ),
                        const SizedBox(width: 3),
                        Expanded(
                          child: Text(
                            registro.operador,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.35),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exibirDetalhesRegistro(BuildContext context, RegistroRecente registro) {
    final dataHoraStr = _formatarDataHora(registro.data);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(
              Icons.assignment_turned_in_rounded,
              color: Colors.greenAccent,
              size: 24,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                registro.equipamento,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Tipo:', registro.titulo),
            _buildDetailRow('Operador:', registro.operador),
            if (registro.curso.isNotEmpty)
              _buildDetailRow('Curso:', registro.curso),
            _buildDetailRow('Turno:', registro.turno),
            _buildDetailRow('Data e Hora:', dataHoraStr),
            _buildDetailRow(
              'Status:',
              registro.status,
              valorCor: Colors.greenAccent,
            ),
            if (registro.observacao.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Observações:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                registro.observacao,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB00404),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Fechar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exibirTodosRegistros(BuildContext context) {
    final registros = AppSession.registrosRecentes;
    if (registros.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nenhum registro realizado ainda.'),
          backgroundColor: Color(0xFFB00404),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF161618),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.65,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      const Icon(Icons.history, color: Color(0xFFB00404)),
                      const SizedBox(width: 8),
                      const Text(
                        'Histórico de Registros',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white70),
                        onPressed: () => Navigator.pop(ctx),
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.white12),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: registros.length,
                    itemBuilder: (context, index) {
                      final item = registros[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildRecentRecordCard(item),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String valor, {Color? valorCor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 12,
              ),
            ),
          ),
          Expanded(
            child: Text(
              valor,
              style: TextStyle(
                color: valorCor ?? Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentCard({
    required String imagePath,
    required String type,
    required String name,
    VoidCallback? onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF141414).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.12),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Image.asset(
                imagePath,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      type,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 11,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.white.withValues(alpha: 0.35),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
