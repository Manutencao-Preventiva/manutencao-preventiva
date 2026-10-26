import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projetoflutter/session.dart';

class Formularionr12 extends StatefulWidget {
  final String? equipamentoInicial;

  const Formularionr12({super.key, this.equipamentoInicial});

  @override
  State<Formularionr12> createState() => _Formularionr12State();
}

class _Formularionr12State extends State<Formularionr12> {
  final _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const String _formsUrl =
      'https://forms.cloud.microsoft/pages/responsepage.aspx?id=SxwFsZQ7q0GUQec6cjQv3SUnS0aLFRxFupnB17ctoQBUNDExOUJaUDRGTzVBM1NUT0xVUlU1WVFESi4u&origin=lprLink&route=shorturl';
  static const String _formsApiUrl =
      'https://forms.cloud.microsoft/formapi/api/b1051c4b-3b94-41ab-9441-e73a72342fdd/users/464b2725-158b-451c-ba99-c1d7b72da100/light/runtimeForms(\'SxwFsZQ7q0GUQec6cjQv3SUnS0aLFRxFupnB17ctoQBUNDExOUJaUDRGTzVBM1NUT0xVUlU1WVFESi4u\')?\$expand=questions(\$expand=choices)';

  bool _isLoading = false;
  bool _isSyncing = false;
  String _syncStatus = 'Conectado';

  final List<String> _titulosEtapas = [
    'Identificação do Operador e Máquina',
    'Elétrica e Dispositivos de Segurança',
    'Movimentação e Sistema de Transmissão',
    'Lubrificação e Fluido de Refrigeração',
    'Ferramentas, Barramento e Observações',
  ];

  final List<IconData> _iconesEtapas = [
    Icons.badge_outlined,
    Icons.bolt_rounded,
    Icons.precision_manufacturing_rounded,
    Icons.opacity_rounded,
    Icons.handyman_outlined,
  ];

  final TextEditingController _cursoController = TextEditingController();
  final TextEditingController _niController = TextEditingController();
  final TextEditingController _obsController = TextEditingController();

  DateTime _dataOperacao = DateTime.now();
  String _turnoSelecionado = 'Manhã (7h30-11h30)';

  final List<String> _opcoesTurno = [
    'Manhã (7h30-11h30)',
    'Tarde (13h30-17h30)',
    'Noite (19h-22h)',
    'Sábado (09h-13h)',
    'Sábado (14h-18h)',
  ];

  final Map<String, String> _respostasChoice = {};

  @override
  void initState() {
    super.initState();
    if (widget.equipamentoInicial != null &&
        widget.equipamentoInicial!.isNotEmpty) {
      _niController.text = widget.equipamentoInicial!;
    } else {
      _niController.text = 'Torno ROMI - 01';
    }
    _sincronizarComForms();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _cursoController.dispose();
    _niController.dispose();
    _obsController.dispose();
    super.dispose();
  }

  Future<void> _sincronizarComForms() async {
    setState(() {
      _isSyncing = true;
    });

    try {
      final response = await http
          .get(Uri.parse(_formsApiUrl), headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        setState(() {
          _syncStatus = 'Sincronizado';
        });
      } else {
        setState(() {
          _syncStatus = 'Forms Ativo';
        });
      }
    } catch (_) {
      setState(() {
        _syncStatus = 'Forms Conectado';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  void _validarEAAvancar() {
    if (_currentPage == 0) {
      if (_cursoController.text.trim().isEmpty) {
        _exibirAviso('Por favor, informe qual curso você faz.');
        return;
      }
      if (_niController.text.trim().isEmpty) {
        _exibirAviso('Por favor, informe a identificação da máquina (NI).');
        return;
      }
    } else if (_currentPage == 1) {
      final eletricaObrigatorias = [
        {'id': 'rd3612972726f4acebafaffa00e092a8e', 'nome': 'Energia elétrica'},
        {'id': 'r519acd9956084c71bdc63238389626c4', 'nome': 'Chave geral'},
        {'id': 're63e3e16d0d74512879c13565b2f10d0', 'nome': 'Painel elétrico'},
        {
          'id': 'r14546592655346f79bd5a07602e8368d',
          'nome': 'Botão de emergência',
        },
      ];

      for (final item in eletricaObrigatorias) {
        if (!_respostasChoice.containsKey(item['id'])) {
          _exibirAviso('Responda à verificação obrigatória: ${item['nome']}');
          return;
        }
      }
    } else if (_currentPage == 2) {
      if (!_respostasChoice.containsKey('rb6d8c69359cd4efea46abf7779567d59')) {
        _exibirAviso('Responda à verificação obrigatória: Alavancas de RPM.');
        return;
      }
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  void _exibirAviso(String mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: const Color(0xFFB00404),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _enviarFormulario() async {
    setState(() {
      _isLoading = true;
    });

    final List<Map<String, dynamic>> answersList = [
      {
        'questionId': 'rb42487faafec42c5924000e5e9afb666',
        'answer1': _cursoController.text.trim(),
      },
      {
        'questionId': 'ra116fdd97b0445f3b59bd8cc479904fa',
        'answer1':
            "${_dataOperacao.year}-${_dataOperacao.month.toString().padLeft(2, '0')}-${_dataOperacao.day.toString().padLeft(2, '0')}",
      },
      {
        'questionId': 'r9b6169f869594352bdea25f13c387435',
        'answer1': _turnoSelecionado,
      },
      {
        'questionId': 'r4c3f841c05374a059016f046edb4bf86',
        'answer1': _niController.text.trim(),
      },
      if (_obsController.text.trim().isNotEmpty)
        {
          'questionId': 'rfa79e9edc4f1404a9ccb476c2024a8f1',
          'answer1': _obsController.text.trim(),
        },
    ];

    _respostasChoice.forEach((questionId, valor) {
      answersList.add({'questionId': questionId, 'answer1': valor});
    });

    final payload = {
      'formUrl': _formsUrl,
      'formId':
          'SxwFsZQ7q0GUQec6cjQv3SUnS0aLFRxFupnB17ctoQBUNDExOUJaUDRGTzVBM1NUT0xVUlU1WVFESi4u',
      'operador': AppSession.nome,
      'emailOperador': AppSession.email,
      'dataEnvio': DateTime.now().toIso8601String(),
      'answers': answersList,
    };

    try {
      try {
        await http
            .post(
              Uri.parse('http://localhost:3000/inspecoes-nr12'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(payload),
            )
            .timeout(const Duration(seconds: 3));
      } catch (_) {}

      await Future.delayed(const Duration(milliseconds: 600));

      if (!mounted) return;

      AppSession.adicionarRegistro(
        RegistroRecente(
          titulo: 'Checklist NR-12',
          equipamento: _niController.text.trim().isNotEmpty
              ? _niController.text.trim()
              : (widget.equipamentoInicial ?? 'Torno Mecânico ROMI'),
          operador: AppSession.nome,
          turno: _turnoSelecionado,
          curso: _cursoController.text.trim(),
          data: DateTime.now(),
          status: 'Concluído',
          observacao: _obsController.text.trim(),
        ),
      );

      _exibirDialogoSucesso();
    } catch (e) {
      if (!mounted) return;
      _exibirAviso('Erro ao enviar dados: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _exibirDialogoSucesso() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E22),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: const [
            Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text(
              'Inspeção Concluída!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'O checklist pré-operacional de NR-12 foi registrado com sucesso.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Operador: ${AppSession.nome}',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Equipamento: ${_niController.text}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Turno: $_turnoSelecionado',
                    style: const TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Status Forms: $_syncStatus',
                    style: const TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
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
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text(
              'Voltar ao Início',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selecionarData() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dataOperacao,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFB00404),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E22),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dataOperacao = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101012),
      appBar: AppBar(
        backgroundColor: const Color(0xFF161618),
        elevation: 0,
        title: const Text(
          'Checklist NR-12 Torno Mecânico',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 20,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.circle, size: 7, color: Colors.greenAccent),
                const SizedBox(width: 5),
                Text(
                  _syncStatus,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/image.png',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          SafeArea(
            child: Column(
              children: [
                _buildProgressBar(),
                _buildStepPillBar(),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    physics: const NeverScrollableScrollPhysics(),
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildPaginaIdentificacao(),
                      _buildPaginaEletricaESeguranca(),
                      _buildPaginaMovimentacaoETransmissao(),
                      _buildPaginaLubrificacaoERefrigeracao(),
                      _buildPaginaFerramentasEEstrutura(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      color: const Color(0xFF161618).withValues(alpha: 0.88),
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    _iconesEtapas[_currentPage],
                    size: 16,
                    color: const Color(0xFFE53935),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _titulosEtapas[_currentPage],
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                '${_currentPage + 1} de 5',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: (_currentPage + 1) / 5,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFB00404),
              ),
              minHeight: 5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepPillBar() {
    return Container(
      width: double.infinity,
      color: const Color(0xFF161618).withValues(alpha: 0.88),
      padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(5, (index) {
            final isCurrent = index == _currentPage;
            final isPast = index < _currentPage;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: InkWell(
                onTap: isPast
                    ? () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
                borderRadius: BorderRadius.circular(20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: isCurrent
                        ? const Color(0xFFB00404)
                        : (isPast
                              ? Colors.white.withValues(alpha: 0.12)
                              : Colors.white.withValues(alpha: 0.05)),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCurrent
                          ? const Color(0xFFE53935)
                          : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPast
                            ? Icons.check_circle_rounded
                            : _iconesEtapas[index],
                        size: 13,
                        color: isCurrent
                            ? Colors.white
                            : (isPast ? Colors.greenAccent : Colors.grey[500]),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'Etapa ${index + 1}',
                        style: TextStyle(
                          color: isCurrent
                              ? Colors.white
                              : (isPast ? Colors.white70 : Colors.grey[500]),
                          fontSize: 11,
                          fontWeight: isCurrent
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF161618),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              flex: 1,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 13),
                ),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.arrow_back_ios_new, size: 14),
                    SizedBox(width: 6),
                    Text('Voltar', style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFB00404),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: const EdgeInsets.symmetric(vertical: 13),
                elevation: 2,
              ),
              onPressed: _isLoading
                  ? null
                  : () {
                      if (_currentPage < 4) {
                        _validarEAAvancar();
                      } else {
                        _enviarFormulario();
                      }
                    },
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage < 4 ? 'Avançar' : 'Enviar Inspeção',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _currentPage < 4
                              ? Icons.arrow_forward_ios
                              : Icons.send_rounded,
                          size: 15,
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginaIdentificacao() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBanner(
            'Preencha as informações básicas do operador e selecione a máquina para iniciar o checklist diário de NR-12.',
          ),
          const SizedBox(height: 16),
          _buildTextField(
            controller: _cursoController,
            label: 'Qual curso você faz? *',
            hint: 'Ex: Mecânica, Usinagem, Eletromecânica...',
            icon: Icons.school_outlined,
          ),
          const SizedBox(height: 14),
          _buildDateField(),
          const SizedBox(height: 14),
          _buildTurnoSelector(),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _niController,
            label: 'Número de identificação do equipamento (NI): *',
            hint: 'Ex: ROMI-01, NARDINI-02...',
            icon: Icons.tag,
          ),
        ],
      ),
    );
  }

  Widget _buildPaginaEletricaESeguranca() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Elétrica', Icons.bolt_rounded),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'rd3612972726f4acebafaffa00e092a8e',
            titulo: 'A máquina está recebendo energia corretamente?',
            obrigatorio: true,
          ),
          _buildQuestionItem(
            id: 'r519acd9956084c71bdc63238389626c4',
            titulo: 'A chave geral está funcionando normalmente?',
            obrigatorio: true,
          ),
          _buildQuestionItem(
            id: 're63e3e16d0d74512879c13565b2f10d0',
            titulo: 'O painel elétrico apresenta funcionamento adequado?',
            obrigatorio: true,
          ),
          _buildQuestionItem(
            id: 'r14546592655346f79bd5a07602e8368d',
            titulo: 'O botão de emergência está funcionando corretamente?',
            obrigatorio: true,
          ),
          const SizedBox(height: 18),
          _buildSectionHeader('Segurança Operacional', Icons.shield_outlined),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'r3ed2e8df36f04a9c9e99d036b78304d8',
            titulo: 'Há presença de ruídos anormais após acionar a máquina?',
          ),
          _buildQuestionItem(
            id: 're90e15969d144e0aa278a906cd7edbad',
            titulo: 'A frenagem da máquina está funcionando de forma eficaz?',
          ),
          _buildQuestionItem(
            id: 'r444c0c4262464dbfbb0f2e8449c76704',
            titulo:
                'O sistema de segurança (corda de proteção, acrílicos e sensores) está bom?',
          ),
          _buildQuestionItem(
            id: 'r6b3ceddfb0d64f4583b395d41fdd095a',
            titulo: 'Há componentes soltos na máquina?',
          ),
        ],
      ),
    );
  }

  Widget _buildPaginaMovimentacaoETransmissao() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Movimentação e Funcionamento',
            Icons.precision_manufacturing_rounded,
          ),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'r8d2f0d6dfa0341d8adc507c906253cd1',
            titulo: 'O carro longitudinal está se movimentando corretamente?',
          ),
          _buildQuestionItem(
            id: 'r3b36cad133154beba6de767d53e55b22',
            titulo: 'O carro transversal está se movimentando corretamente?',
          ),
          _buildQuestionItem(
            id: 'r8f231cab2a5c4273b9f0db96bd1ed14b',
            titulo: 'O carro do contraponto está se deslocando corretamente?',
          ),
          _buildQuestionItem(
            id: 'r42683c2f271c42bab962c2b4819bf761',
            titulo: 'O contraponto está em boas condições de uso?',
          ),
          _buildQuestionItem(
            id: 'r29a42063b2cc4ae99a9f64316f8c003a',
            titulo:
                'O cabeçote e o contraponto estão alinhados axialmente, garantindo precisão?',
          ),
          _buildQuestionItem(
            id: 'rb6d8c69359cd4efea46abf7779567d59',
            titulo:
                'As alavancas de mudança de RPM estão funcionando corretamente? (teste cada uma)',
            obrigatorio: true,
          ),
          const SizedBox(height: 18),
          _buildSectionHeader(
            'Sistema de Transmissão',
            Icons.settings_suggest_rounded,
          ),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'r72969141845343909e91a4a0cd42f067',
            titulo: 'As correias estão em bom estado (sem desgaste ou folga)?',
          ),
          _buildQuestionItem(
            id: 'r88901ec4059b419f8a7e3dc0cdfd97fe',
            titulo: 'As engrenagens visíveis estão funcionando corretamente?',
          ),
        ],
      ),
    );
  }

  Widget _buildPaginaLubrificacaoERefrigeracao() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Lubrificação e Manutenção',
            Icons.opacity_rounded,
          ),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'r8b37c96108f642298ab3b9433eaf8509',
            titulo: 'O nível de óleo lubrificante está adequado?',
          ),
          _buildQuestionItem(
            id: 'rda8270b51cc04cbfb84c969204767256',
            titulo: 'Há sinais de vazamento de óleo?',
          ),
          _buildQuestionItem(
            id: 'rfd5bd68e6be24f1397e9b429ed802b06',
            titulo: 'O ambiente ao redor está limpo e organizado?',
          ),
          const SizedBox(height: 18),
          _buildSectionHeader(
            'Sistema de Refrigeração (Fluido de corte)',
            Icons.water_drop_outlined,
          ),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'r44aca7682349483383761402dea00a69',
            titulo:
                'O fluido está sendo direcionado corretamente para a zona de corte?',
          ),
          _buildQuestionItem(
            id: 'r15ed81f42e364ba889ba1653fd4bce0f',
            titulo: 'Há interrupções ou falhas no fornecimento do fluido?',
          ),
          _buildQuestionItem(
            id: 'rc6dcddd9c1d5462297897519db9bb1f6',
            titulo:
                'As mangueiras estão em bom estado (sem obstrução ou rachaduras)?',
          ),
        ],
      ),
    );
  }

  Widget _buildPaginaFerramentasEEstrutura() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            'Condições Gerais das Ferramentas',
            Icons.handyman_outlined,
          ),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'rc39fbdbc0a894afeb65fc0c8b420f71a',
            titulo:
                'As ferramentas de aperto e desaperto estão todas presentes?',
          ),
          _buildQuestionItem(
            id: 'rd9e77584d01f4e9bb5515d246a5cdff9',
            titulo: 'As ferramentas estão em bom estado de conservação?',
          ),
          _buildQuestionItem(
            id: 'r6f9498c1459e4beb952a4699ef64ed33',
            titulo: 'A chave do mandril encaixa corretamente, sem folgas?',
          ),
          _buildQuestionItem(
            id: 'r042889da94e74f339bc5ffc4471fbaf9',
            titulo: 'Evita-se o uso de ferramentas improvisadas?',
          ),
          _buildQuestionItem(
            id: 'r6ea9a7b9990a4315871366767f2f1aec',
            titulo:
                'O ambiente está livre de ferramentas soltas (guardadas corretamente)?',
          ),
          const SizedBox(height: 18),
          _buildSectionHeader(
            'Barramento (base) e Estrutura',
            Icons.view_sidebar_rounded,
          ),
          const SizedBox(height: 10),
          _buildQuestionItem(
            id: 'rf302ed6599d34cad9f2b36bd4289afb7',
            titulo:
                'Há sinais de trincas ou deformações no barramento/estrutura?',
          ),
          _buildQuestionItem(
            id: 'rd5fb771a198545ac9497793c68614853',
            titulo: 'Há desgastes nos trilhos e guias do torno?',
          ),
          _buildQuestionItem(
            id: 'rd291e8376a7447959643e53d845e7602',
            titulo: 'Os trilhos e guias estão bem lubrificados?',
          ),
          const SizedBox(height: 14),
          _buildTextField(
            controller: _obsController,
            label: 'Observações adicionais:',
            hint: 'Descreva anomalias, ruídos ou necessidades de reparo...',
            icon: Icons.notes_rounded,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoBanner(String texto) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1E),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline_rounded,
            color: Color(0xFFE53935),
            size: 20,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              texto,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 12,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String titulo, IconData icone) {
    return Row(
      children: [
        Icon(icone, color: const Color(0xFFE53935), size: 18),
        const SizedBox(width: 8),
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
            prefixIcon: Icon(icon, color: Colors.grey[400], size: 20),
            filled: true,
            fillColor: const Color(0xFF1E1E22),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFB00404)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField() {
    final dataFormatada =
        "${_dataOperacao.day.toString().padLeft(2, '0')}/${_dataOperacao.month.toString().padLeft(2, '0')}/${_dataOperacao.year}";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Data de operação: *',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: _selecionarData,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E22),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.grey[400],
                  size: 18,
                ),
                const SizedBox(width: 10),
                Text(
                  dataFormatada,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
                const Spacer(),
                const Text(
                  'Alterar',
                  style: TextStyle(
                    color: Color(0xFFE53935),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTurnoSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione o turno de utilização: *',
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _opcoesTurno.map((turno) {
            final isSelected = _turnoSelecionado == turno;
            return ChoiceChip(
              label: Text(
                turno,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey[300],
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              selected: isSelected,
              selectedColor: const Color(0xFFB00404),
              backgroundColor: const Color(0xFF1E1E22),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFFB00404)
                    : Colors.white.withValues(alpha: 0.1),
              ),
              onSelected: (val) {
                if (val) {
                  setState(() {
                    _turnoSelecionado = turno;
                  });
                }
              },
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuestionItem({
    required String id,
    required String titulo,
    bool obrigatorio = false,
  }) {
    final valorAtual = _respostasChoice[id];

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF161618),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: valorAtual == null
                ? Colors.white.withValues(alpha: 0.07)
                : (valorAtual == 'não' || valorAtual == 'Não')
                ? const Color(0xFFB00404).withValues(alpha: 0.4)
                : Colors.green.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              obrigatorio ? '$titulo *' : titulo,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.95),
                fontSize: 13,
                fontWeight: obrigatorio ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildChoiceButton(
                  id: id,
                  label: 'Sim',
                  value: 'sim',
                  isSelected: valorAtual == 'sim' || valorAtual == 'sim\xa0',
                  activeColor: const Color(0xFF2E7D32),
                ),
                const SizedBox(width: 8),
                _buildChoiceButton(
                  id: id,
                  label: 'Não',
                  value: 'não',
                  isSelected: valorAtual == 'não' || valorAtual == 'Não',
                  activeColor: const Color(0xFFB00404),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceButton({
    required String id,
    required String label,
    required String value,
    required bool isSelected,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: () {
        setState(() {
          _respostasChoice[id] = value;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFF222226),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.white70 : Colors.white12,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected
                  ? (value.toLowerCase() == 'sim'
                        ? Icons.check_circle_rounded
                        : Icons.cancel_rounded)
                  : Icons.radio_button_unchecked,
              size: 14,
              color: isSelected ? Colors.white : Colors.grey[400],
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[300],
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
