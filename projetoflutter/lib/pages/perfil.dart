import 'package:flutter/material.dart';
import 'package:projetoflutter/pages/Dashges.dart';
import 'package:projetoflutter/pages/Dashope.dart';
import 'package:projetoflutter/pages/login.dart';
import 'package:projetoflutter/session.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  static Route route() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => const Perfil(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.12),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.96,
                end: 1.0,
              ).animate(curvedAnimation),
              child: child,
            ),
          ),
        );
      },
      transitionDuration: const Duration(milliseconds: 500),
    );
  }

  static Future<void> abrir(BuildContext context) {
    return Navigator.push(context, route());
  }

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> with TickerProviderStateMixin {
  late final AnimationController _animController;

  late final Animation<double> _headerScale;
  late final Animation<double> _headerFade;
  late final Animation<Offset> _badgeSlide;
  late final Animation<Offset> _actionsSlide;
  late final Animation<double> _actionsFade;
  late final Animation<double> _logoutFade;

  bool _notificacoesAtivas = true;

  @override
  void initState() {
    super.initState();
    _notificacoesAtivas = AppSession.notificacoesAtivas;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _headerFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.40, curve: Curves.easeOut),
      ),
    );

    _badgeSlide = Tween<Offset>(begin: const Offset(0.0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.20, 0.55, curve: Curves.easeOutCubic),
          ),
        );

    _actionsSlide =
        Tween<Offset>(begin: const Offset(0.0, 0.25), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.35, 0.75, curve: Curves.easeOutCubic),
          ),
        );

    _actionsFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.35, 0.70, curve: Curves.easeOut),
      ),
    );

    _logoutFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.60, 0.90, curve: Curves.easeOut),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _voltar() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              AppSession.isGestor ? const Dashges() : const Dash(),
        ),
      );
    }
  }

  void _abrirModalEdicao() {
    final nomeCtrl = TextEditingController(text: AppSession.nome);
    final emailCtrl = TextEditingController(text: AppSession.email);
    final telefoneCtrl = TextEditingController(text: AppSession.telefone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF181818),
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Colors.black87,
                blurRadius: 20,
                offset: Offset(0, -4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Row(
                  children: [
                    Icon(Icons.edit_note_rounded, color: Color(0xFFE53935)),
                    SizedBox(width: 8),
                    Text(
                      'Editar Dados Pessoais',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Atualize seu nome e dados de contato no sistema.',
                  style: TextStyle(color: Colors.white60, fontSize: 13),
                ),
                const SizedBox(height: 20),
                _campoModal(nomeCtrl, 'Nome Completo', Icons.person_outline),
                const SizedBox(height: 14),
                _campoModal(
                  emailCtrl,
                  'E-mail Corporativo',
                  Icons.email_outlined,
                  readOnly: true,
                ),
                const SizedBox(height: 14),
                _campoModal(
                  telefoneCtrl,
                  'Telefone / Ramal',
                  Icons.phone_outlined,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white70,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => Navigator.pop(ctx),
                        child: const Text('Cancelar'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB00404),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 4,
                        ),
                        onPressed: () async {
                          final novoNome = nomeCtrl.text.trim();
                          final novoTelefone = telefoneCtrl.text.trim();

                          Navigator.pop(ctx);

                          // Salva as alterações no banco de dados
                          final sucesso = await AppSession.salvarNoBanco(
                            novoNome: novoNome,
                            novoTelefone: novoTelefone,
                          );

                          if (!mounted) return;
                          setState(() {});

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: sucesso
                                  ? const Color(0xFF2E7D32)
                                  : Colors.orange.shade800,
                              content: Row(
                                children: [
                                  Icon(
                                    sucesso
                                        ? Icons.check_circle
                                        : Icons.cloud_off,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    sucesso
                                        ? 'Perfil salvo no banco de dados com sucesso!'
                                        : 'Perfil atualizado localmente.',
                                  ),
                                ],
                              ),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                        child: const Text(
                          'Salvar',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
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

  Widget _campoModal(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70, fontSize: 14),
        prefixIcon: Icon(icon, color: Colors.white70, size: 20),
        filled: true,
        fillColor: const Color(0xFF232323),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE53935), width: 1.5),
        ),
      ),
    );
  }

  void _abrirModalSenha() {
    final atualCtrl = TextEditingController();
    final novaCtrl = TextEditingController();
    final confirmaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: Color(0xFFE53935)),
            SizedBox(width: 10),
            Text('Alterar Senha', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: atualCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Senha Atual',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE53935)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: novaCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nova Senha',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE53935)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmaCtrl,
              obscureText: true,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Confirmar Nova Senha',
                labelStyle: TextStyle(color: Colors.white70),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white24),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFE53935)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB00404),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (novaCtrl.text.isEmpty || novaCtrl.text != confirmaCtrl.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.redAccent,
                    content: Text('As senhas não coincidem ou estão vazias.'),
                  ),
                );
                return;
              }
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Color(0xFF2E7D32),
                  content: Text('Senha alterada com sucesso!'),
                ),
              );
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  void _abrirHistoricoManutencoes() {
    final historico = [
      {
        'maquina': 'Prensa Hidráulica 04',
        'tipo': 'Preventiva Mensal',
        'data': 'Ontem, 14:30',
        'status': 'Concluída',
        'color': const Color(0xFF00E676),
      },
      {
        'maquina': 'Torno CNC Mazak 02',
        'tipo': 'Troca de Óleo e Filtros',
        'data': '11/10/2026, 09:15',
        'status': 'Concluída',
        'color': const Color(0xFF00E676),
      },
      {
        'maquina': 'Esteira Transportadora L3',
        'tipo': 'Ajuste de Tensão / Rolamento',
        'data': '08/10/2026, 16:40',
        'status': 'Concluída',
        'color': const Color(0xFF00E676),
      },
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF181818),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 44,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: [
                Icon(Icons.history_rounded, color: Color(0xFFE53935)),
                SizedBox(width: 8),
                Text(
                  'Histórico Recente de O.S.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...historico.map(
              (item) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF222222),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white10),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.build_circle_outlined,
                        color: Color(0xFFE53935),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['maquina'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${item['tipo']} • ${item['data']}',
                            style: const TextStyle(
                              color: Colors.white60,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: (item['color'] as Color).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        item['status'] as String,
                        style: TextStyle(
                          color: item['color'] as Color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmarLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Color(0xFFE53935)),
            SizedBox(width: 10),
            Text('Sair do Sistema', style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          'Deseja realmente encerrar sua sessão? Você precisará fazer login novamente para acessar o sistema.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB00404),
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
              );
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isGestor = AppSession.isGestor;

    return Scaffold(
      backgroundColor: const Color(0xFF0C0C0C),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/image.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(),
            ),
          ),


          SafeArea(
            child: Column(
              children: [
                _buildAppBar(),

                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildHeaderAnimado(isGestor),

                        const SizedBox(height: 18),

                        _buildStatusBadge(isGestor),

                        const SizedBox(height: 28),

                        _buildAcoesCardAnimado(),

                        const SizedBox(height: 28),

                        _buildBotaoLogoutAnimado(),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: _voltar,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),

          const SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildHeaderAnimado(bool isGestor) {
    return FadeTransition(
      opacity: _headerFade,
      child: ScaleTransition(
        scale: _headerScale,
        child: Column(
          children: [
            Hero(
              tag: 'profile_avatar_hero',
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFE53935), Color(0xFF500000)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFB00404).withValues(alpha: 0.45),
                      blurRadius: 22,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF1F1F1F),
                  child: Text(
                    AppSession.nome.isNotEmpty
                        ? AppSession.nome
                              .split(' ')
                              .map((e) => e.isNotEmpty ? e[0] : '')
                              .take(2)
                              .join()
                              .toUpperCase()
                        : (isGestor ? 'GE' : 'OP'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),

            Text(
              AppSession.nome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              AppSession.email,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isGestor) {
    final String cargoTexto = isGestor ? 'Gestor' : 'Operário de Manutenção';
    final IconData cargoIcone = isGestor
        ? Icons.admin_panel_settings_rounded
        : Icons.engineering_rounded;

    return SlideTransition(
      position: _badgeSlide,
      child: FadeTransition(
        opacity: _headerFade,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF8B0000), Color(0xFF4A0000)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFB00404).withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(cargoIcone, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                cargoTexto,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAcoesCardAnimado() {
    return SlideTransition(
      position: _actionsSlide,
      child: FadeTransition(
        opacity: _actionsFade,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF171717).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black45,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _itemAcao(
                icon: Icons.edit_note_rounded,
                titulo: 'Editar Perfil',
                subtitulo: 'Atualize seus dados cadastrais e de contato',
                onTap: _abrirModalEdicao,
              ),
              const Divider(color: Colors.white10, height: 1, indent: 56),
              _itemAcao(
                icon: Icons.lock_outline_rounded,
                titulo: 'Alterar Senha de Acesso',
                subtitulo: 'Atualize sua credencial de segurança',
                onTap: _abrirModalSenha,
              ),
              const Divider(color: Colors.white10, height: 1, indent: 56),
              _itemAcao(
                icon: Icons.history_rounded,
                titulo: 'Histórico de Manutenções',
                subtitulo: 'Consulte ordens de serviço finalizadas',
                onTap: _abrirHistoricoManutencoes,
              ),
              const Divider(color: Colors.white10, height: 1, indent: 56),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.notifications_active_outlined,
                        color: Colors.white70,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alertas e Notificações',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Avisos de máquinas e O.S. críticas',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch(
                      value: _notificacoesAtivas,
                      activeTrackColor: const Color(0xFF8B0000),
                      activeThumbColor: const Color(0xFFE53935),
                      onChanged: (val) {
                        setState(() {
                          _notificacoesAtivas = val;
                          AppSession.notificacoesAtivas = val;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              val
                                  ? 'Notificações de máquinas ativadas.'
                                  : 'Notificações desativadas.',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const Divider(color: Colors.white10, height: 1, indent: 56),
              _itemAcao(
                icon: Icons.help_outline_rounded,
                titulo: 'Central de Ajuda da Planta',
                subtitulo: 'Manuais técnicos e suporte do setor',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      title: const Text(
                        'Suporte Técnico',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Para chamados urgentes na linha de produção, utilize o ramal 4002 ou comunique o líder de turno.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFB00404),
                          ),
                          onPressed: () => Navigator.pop(ctx),
                          child: const Text(
                            'Entendido',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemAcao({
    required IconData icon,
    required String titulo,
    required String subtitulo,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
      title: Text(
        titulo,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        subtitulo,
        style: const TextStyle(color: Colors.white54, fontSize: 12),
      ),
      trailing: const Icon(
        Icons.chevron_right_rounded,
        color: Colors.white38,
        size: 20,
      ),
    );
  }

  Widget _buildBotaoLogoutAnimado() {
    return FadeTransition(
      opacity: _logoutFade,
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF260A0A),
            foregroundColor: const Color(0xFFFF5252),
            elevation: 0,
            side: const BorderSide(color: Color(0xFF751515), width: 1.2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: _confirmarLogout,
          icon: const Icon(Icons.logout_rounded, size: 20),
          label: const Text(
            'Sair da Conta',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
