import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ItemRespostaNR12 {
  final String id;
  final String pergunta;
  final String resposta;
  final String categoria;
  final bool isAlerta;

  const ItemRespostaNR12({
    required this.id,
    required this.pergunta,
    required this.resposta,
    required this.categoria,
    this.isAlerta = false,
  });
}

class PerguntaDefinicao {
  final String id;
  final String pergunta;
  final String categoria;
  final bool respostaSimEhAlerta;

  const PerguntaDefinicao({
    required this.id,
    required this.pergunta,
    required this.categoria,
    this.respostaSimEhAlerta = false,
  });
}

class CatalogoPerguntasNR12 {
  static const List<PerguntaDefinicao> lista = [
    PerguntaDefinicao(
      id: 'rd3612972726f4acebafaffa00e092a8e',
      pergunta: 'A máquina está recebendo energia corretamente?',
      categoria: 'Elétrica e Segurança',
    ),
    PerguntaDefinicao(
      id: 'r519acd9956084c71bdc63238389626c4',
      pergunta: 'A chave geral está funcionando normalmente?',
      categoria: 'Elétrica e Segurança',
    ),
    PerguntaDefinicao(
      id: 're63e3e16d0d74512879c13565b2f10d0',
      pergunta: 'O painel elétrico apresenta funcionamento adequado?',
      categoria: 'Elétrica e Segurança',
    ),
    PerguntaDefinicao(
      id: 'r14546592655346f79bd5a07602e8368d',
      pergunta: 'O botão de emergência está funcionando corretamente?',
      categoria: 'Elétrica e Segurança',
    ),
    PerguntaDefinicao(
      id: 'r3ed2e8df36f04a9c9e99d036b78304d8',
      pergunta: 'Há presença de ruídos anormais após acionar a máquina?',
      categoria: 'Elétrica e Segurança',
      respostaSimEhAlerta: true,
    ),
    PerguntaDefinicao(
      id: 're90e15969d144e0aa278a906cd7edbad',
      pergunta: 'A frenagem da máquina está funcionando de forma eficaz?',
      categoria: 'Elétrica e Segurança',
    ),
    PerguntaDefinicao(
      id: 'r444c0c4262464dbfbb0f2e8449c76704',
      pergunta:
          'O sistema de segurança (corda de proteção, acrílicos e sensores) está bom?',
      categoria: 'Elétrica e Segurança',
    ),
    PerguntaDefinicao(
      id: 'r6b3ceddfb0d64f4583b395d41fdd095a',
      pergunta: 'Há componentes soltos na máquina?',
      categoria: 'Elétrica e Segurança',
      respostaSimEhAlerta: true,
    ),

    PerguntaDefinicao(
      id: 'r8d2f0d6dfa0341d8adc507c906253cd1',
      pergunta: 'O carro longitudinal está se movimentando corretamente?',
      categoria: 'Movimentação e Transmissão',
    ),
    PerguntaDefinicao(
      id: 'r3b36cad133154beba6de767d53e55b22',
      pergunta: 'O carro transversal está se movimentando corretamente?',
      categoria: 'Movimentação e Transmissão',
    ),
    PerguntaDefinicao(
      id: 'r8f231cab2a5c4273b9f0db96bd1ed14b',
      pergunta: 'O carro do contraponto está se deslocando corretamente?',
      categoria: 'Movimentação e Transmissão',
    ),
    PerguntaDefinicao(
      id: 'r42683c2f271c42bab962c2b4819bf761',
      pergunta: 'O contraponto está em boas condições de uso?',
      categoria: 'Movimentação e Transmissão',
    ),
    PerguntaDefinicao(
      id: 'r29a42063b2cc4ae99a9f64316f8c003a',
      pergunta:
          'O cabeçote e o contraponto estão alinhados axialmente, garantindo precisão?',
      categoria: 'Movimentação e Transmissão',
    ),
    PerguntaDefinicao(
      id: 'rb6d8c69359cd4efea46abf7779567d59',
      pergunta:
          'As alavancas de mudança de RPM estão funcionando corretamente?',
      categoria: 'Movimentação e Transmissão',
    ),
    PerguntaDefinicao(
      id: 'r72969141845343909e91a4a0cd42f067',
      pergunta: 'As correias estão em bom estado (sem desgaste ou folga)?',
      categoria: 'Movimentação e Transmissão',
    ),
    PerguntaDefinicao(
      id: 'r88901ec4059b419f8a7e3dc0cdfd97fe',
      pergunta: 'As engrenagens visíveis estão funcionando corretamente?',
      categoria: 'Movimentação e Transmissão',
    ),

    PerguntaDefinicao(
      id: 'r8b37c96108f642298ab3b9433eaf8509',
      pergunta: 'O nível de óleo lubrificante está adequado?',
      categoria: 'Lubrificação e Refrigeração',
    ),
    PerguntaDefinicao(
      id: 'rda8270b51cc04cbfb84c969204767256',
      pergunta: 'Há sinais de vazamento de óleo?',
      categoria: 'Lubrificação e Refrigeração',
      respostaSimEhAlerta: true,
    ),
    PerguntaDefinicao(
      id: 'rfd5bd68e6be24f1397e9b429ed802b06',
      pergunta: 'O ambiente ao redor está limpo e organizado?',
      categoria: 'Lubrificação e Refrigeração',
    ),
    PerguntaDefinicao(
      id: 'r44aca7682349483383761402dea00a69',
      pergunta:
          'O fluido está sendo direcionado corretamente para a zona de corte?',
      categoria: 'Lubrificação e Refrigeração',
    ),
    PerguntaDefinicao(
      id: 'r15ed81f42e364ba889ba1653fd4bce0f',
      pergunta: 'Há interrupções ou falhas no fornecimento do fluido?',
      categoria: 'Lubrificação e Refrigeração',
      respostaSimEhAlerta: true,
    ),
    PerguntaDefinicao(
      id: 'rc6dcddd9c1d5462297897519db9bb1f6',
      pergunta:
          'As mangueiras estão em bom estado (sem obstrução ou rachaduras)?',
      categoria: 'Lubrificação e Refrigeração',
    ),

    PerguntaDefinicao(
      id: 'rc39fbdbc0a894afeb65fc0c8b420f71a',
      pergunta: 'As ferramentas de aperto e desaperto estão todas presentes?',
      categoria: 'Ferramental e Estrutura',
    ),
    PerguntaDefinicao(
      id: 'rd9e77584d01f4e9bb5515d246a5cdff9',
      pergunta: 'As ferramentas estão em bom estado de conservação?',
      categoria: 'Ferramental e Estrutura',
    ),
    PerguntaDefinicao(
      id: 'r6f9498c1459e4beb952a4699ef64ed33',
      pergunta: 'A chave do mandril encaixa corretamente, sem folgas?',
      categoria: 'Ferramental e Estrutura',
    ),
    PerguntaDefinicao(
      id: 'r042889da94e74f339bc5ffc4471fbaf9',
      pergunta: 'Evita-se o uso de ferramentas improvisadas?',
      categoria: 'Ferramental e Estrutura',
    ),
    PerguntaDefinicao(
      id: 'r6ea9a7b9990a4315871366767f2f1aec',
      pergunta:
          'O ambiente está livre de ferramentas soltas (guardadas corretamente)?',
      categoria: 'Ferramental e Estrutura',
    ),
    PerguntaDefinicao(
      id: 'rf302ed6599d34cad9f2b36bd4289afb7',
      pergunta: 'Há sinais de trincas ou deformações no barramento/estrutura?',
      categoria: 'Ferramental e Estrutura',
      respostaSimEhAlerta: true,
    ),
    PerguntaDefinicao(
      id: 'rd5fb771a198545ac9497793c68614853',
      pergunta: 'Há desgastes nos trilhos e guias do torno?',
      categoria: 'Ferramental e Estrutura',
      respostaSimEhAlerta: true,
    ),
    PerguntaDefinicao(
      id: 'rd291e8376a7447959643e53d845e7602',
      pergunta: 'Os trilhos e guias estão bem lubrificados?',
      categoria: 'Ferramental e Estrutura',
    ),
  ];

  static List<ItemRespostaNR12> gerarRespostasDetalhadas(
    Map<String, String> respostas,
  ) {
    return lista.map((def) {
      final resp = respostas[def.id] ?? 'Sim';
      final clean = resp.trim().toLowerCase();
      bool alerta = false;
      if (def.respostaSimEhAlerta) {
        alerta = clean == 'sim';
      } else {
        alerta = clean == 'não' || clean == 'nao';
      }

      return ItemRespostaNR12(
        id: def.id,
        pergunta: def.pergunta,
        resposta: resp,
        categoria: def.categoria,
        isAlerta: alerta,
      );
    }).toList();
  }

  static List<RegistroRecente> criarRegistrosIniciais() {
    final agora = DateTime.now();

    final respostasLucas = <String, String>{};
    for (final p in lista) {
      respostasLucas[p.id] = p.respostaSimEhAlerta ? 'Não' : 'Sim';
    }
    respostasLucas['rda8270b51cc04cbfb84c969204767256'] = 'Sim';

    final respostasMariana = <String, String>{};
    for (final p in lista) {
      respostasMariana[p.id] = p.respostaSimEhAlerta ? 'Não' : 'Sim';
    }

    final respostasCarlos = <String, String>{};
    for (final p in lista) {
      respostasCarlos[p.id] = p.respostaSimEhAlerta ? 'Não' : 'Sim';
    }

    return [
      RegistroRecente(
        id: 'rec_101',
        titulo: 'Checklist NR-12 Torno Mecânico',
        equipamento: 'Torno Mecânico ROMI',
        operador: 'Lucas Mendonça',
        emailOperador: 'lucas.mendonca@industria.com',
        turno: 'Manhã (7h30-11h30)',
        curso: 'Usinagem CNC',
        data: agora.subtract(const Duration(minutes: 25)),
        status: 'Com Ressalva',
        observacao:
            'Gotejamento leve de óleo lubrificante próximo à tampa lateral do cabeçote.',
        respostasDetalhadas: gerarRespostasDetalhadas(respostasLucas),
        respostas: respostasLucas,
      ),
      RegistroRecente(
        id: 'rec_102',
        titulo: 'Checklist NR-12 Torno Mecânico',
        equipamento: 'Torno Mecânico NARDINI',
        operador: 'Mariana Souza',
        emailOperador: 'mariana.souza@industria.com',
        turno: 'Tarde (13h30-17h30)',
        curso: 'Eletromecânica',
        data: agora.subtract(const Duration(hours: 2, minutes: 10)),
        status: 'Concluído',
        observacao:
            'Equipamento limpo e testado antes do início da usinagem. Tudo operando perfeitamente.',
        respostasDetalhadas: gerarRespostasDetalhadas(respostasMariana),
        respostas: respostasMariana,
        vistoPeloGestor: true,
      ),
      RegistroRecente(
        id: 'rec_103',
        titulo: 'Checklist NR-12 Fresadora',
        equipamento: 'Fresadora Universal KONI KFU-1',
        operador: 'Carlos Eduardo Silva',
        emailOperador: 'carlos.silva@industria.com',
        turno: 'Manhã (7h30-11h30)',
        curso: 'Mecânica Industrial',
        data: agora.subtract(const Duration(hours: 4, minutes: 40)),
        status: 'Concluído',
        observacao: 'Barramento lubrificado no início do turno.',
        respostasDetalhadas: gerarRespostasDetalhadas(respostasCarlos),
        respostas: respostasCarlos,
        vistoPeloGestor: true,
      ),
    ];
  }
}

class RegistroRecente {
  final String id;
  final String titulo;
  final String equipamento;
  final String operador;
  final String emailOperador;
  final String turno;
  final String curso;
  final DateTime data;
  final String status;
  final String observacao;
  final List<ItemRespostaNR12> respostasDetalhadas;
  final Map<String, String> respostas;
  bool vistoPeloGestor;

  RegistroRecente({
    String? id,
    this.titulo = 'Checklist NR-12',
    required this.equipamento,
    required this.operador,
    this.emailOperador = '',
    required this.turno,
    this.curso = '',
    required this.data,
    this.status = 'Concluído',
    this.observacao = '',
    this.respostasDetalhadas = const [],
    this.respostas = const {},
    this.vistoPeloGestor = false,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();

  int get totalPerguntas => respostasDetalhadas.length;
  int get totalNaoConformidades =>
      respostasDetalhadas.where((r) => r.isAlerta).length;
  bool get temAlerta => totalNaoConformidades > 0;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'equipamento': equipamento,
      'operador': operador,
      'emailOperador': emailOperador,
      'turno': turno,
      'curso': curso,
      'data': data.toIso8601String(),
      'status': status,
      'observacao': observacao,
      'respostas': respostas,
      'vistoPeloGestor': vistoPeloGestor,
    };
  }

  factory RegistroRecente.fromJson(Map<String, dynamic> json) {
    Map<String, String> respostasMap = {};
    if (json['respostas'] is Map) {
      (json['respostas'] as Map).forEach((k, v) {
        respostasMap[k.toString()] = v.toString();
      });
    }

    final respostasDetalhadas = CatalogoPerguntasNR12.gerarRespostasDetalhadas(
      respostasMap,
    );

    DateTime dataFormatada;
    try {
      dataFormatada = DateTime.parse(json['data'].toString());
    } catch (_) {
      dataFormatada = DateTime.now();
    }

    return RegistroRecente(
      id: json['id']?.toString(),
      titulo: json['titulo']?.toString() ?? 'Checklist NR-12',
      equipamento: json['equipamento']?.toString() ?? 'Torno Mecânico',
      operador: json['operador']?.toString() ?? 'Operador',
      emailOperador: json['emailOperador']?.toString() ?? '',
      turno: json['turno']?.toString() ?? 'Manhã',
      curso: json['curso']?.toString() ?? '',
      data: dataFormatada,
      status: json['status']?.toString() ?? 'Concluído',
      observacao: json['observacao']?.toString() ?? '',
      respostasDetalhadas: respostasDetalhadas,
      respostas: respostasMap,
      vistoPeloGestor:
          json['vistoPeloGestor'] == true ||
          json['vistoPeloGestor'] == 1 ||
          json['vistoPeloGestor'] == '1',
    );
  }
}

class MaquinaModel {
  final int id;
  final String nome;
  final String codigo;
  final String tipo;
  final String fabricante;
  final String modelo;
  final double horimetroAtual;
  final String status;
  final DateTime? criadaEm;

  const MaquinaModel({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.tipo,
    required this.fabricante,
    required this.modelo,
    required this.horimetroAtual,
    required this.status,
    this.criadaEm,
  });

  bool get isAtiva => status == 'ATIVA';
  bool get isEmManutencao => status == 'EM_MANUTENCAO';
  bool get isInativa => status == 'INATIVA';

  factory MaquinaModel.fromJson(Map<String, dynamic> json) {
    return MaquinaModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      nome: json['nome']?.toString() ?? '',
      codigo: json['codigo']?.toString() ?? '',
      tipo: json['tipo']?.toString() ?? 'Máquina Industrial',
      fabricante: json['fabricante']?.toString() ?? '',
      modelo: json['modelo']?.toString() ?? '',
      horimetroAtual:
          double.tryParse(json['horimetro_atual']?.toString() ?? '0') ?? 0.0,
      status: json['status']?.toString() ?? 'ATIVA',
      criadaEm: json['criada_em'] != null
          ? DateTime.tryParse(json['criada_em'].toString())
          : null,
    );
  }
}

class HorasModel {
  final int id;
  final int maquinaId;
  final int usuarioId;
  final String dataOperacao;
  final double horasTrabalhadas;
  final double horimetroInicio;
  final double horimetroFim;
  final String observacoes;
  final DateTime? criadoEm;
  final String nomeMaquina;
  final String nomeOperador;

  const HorasModel({
    required this.id,
    required this.maquinaId,
    required this.usuarioId,
    required this.dataOperacao,
    required this.horasTrabalhadas,
    required this.horimetroInicio,
    required this.horimetroFim,
    this.observacoes = '',
    this.criadoEm,
    this.nomeMaquina = '',
    this.nomeOperador = '',
  });

  factory HorasModel.fromJson(Map<String, dynamic> json) {
    String nomeMaq = '';
    if (json['maquina'] is Map) {
      nomeMaq = json['maquina']['nome']?.toString() ?? '';
    }
    String nomeOp = '';
    if (json['usuario'] is Map) {
      nomeOp = json['usuario']['nome']?.toString() ?? '';
    }

    return HorasModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      maquinaId: json['maquina_id'] is int
          ? json['maquina_id']
          : int.tryParse(json['maquina_id'].toString()) ?? 0,
      usuarioId: json['usuario_id'] is int
          ? json['usuario_id']
          : int.tryParse(json['usuario_id'].toString()) ?? 0,
      dataOperacao: json['data_operacao']?.toString() ?? '',
      horasTrabalhadas:
          double.tryParse(json['horas_trabalhadas']?.toString() ?? '0') ?? 0.0,
      horimetroInicio:
          double.tryParse(json['horimetro_inicio']?.toString() ?? '0') ?? 0.0,
      horimetroFim:
          double.tryParse(json['horimetro_fim']?.toString() ?? '0') ?? 0.0,
      observacoes: json['observacoes']?.toString() ?? '',
      criadoEm: json['criado_em'] != null
          ? DateTime.tryParse(json['criado_em'].toString())
          : null,
      nomeMaquina: nomeMaq,
      nomeOperador: nomeOp,
    );
  }
}

class NotificacaoModel {
  final int id;
  final int usuarioId;
  final int? maquinaId;
  final String tipo;
  final String titulo;
  final String mensagem;
  final bool lida;
  final DateTime? criadaEm;
  final String nomeMaquina;

  const NotificacaoModel({
    required this.id,
    required this.usuarioId,
    this.maquinaId,
    required this.tipo,
    required this.titulo,
    required this.mensagem,
    required this.lida,
    this.criadaEm,
    this.nomeMaquina = '',
  });

  factory NotificacaoModel.fromJson(Map<String, dynamic> json) {
    String nomeMaq = '';
    if (json['maquina'] is Map) {
      nomeMaq = json['maquina']['nome']?.toString() ?? '';
    }

    return NotificacaoModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(json['id'].toString()) ?? 0,
      usuarioId: json['usuario_id'] is int
          ? json['usuario_id']
          : int.tryParse(json['usuario_id'].toString()) ?? 0,
      maquinaId: json['maquina_id'] != null
          ? (json['maquina_id'] is int
                ? json['maquina_id']
                : int.tryParse(json['maquina_id'].toString()))
          : null,
      tipo: json['tipo']?.toString() ?? 'AVISO',
      titulo: json['titulo']?.toString() ?? '',
      mensagem: json['mensagem']?.toString() ?? '',
      lida: json['lida'] == 1 || json['lida'] == true || json['lida'] == '1',
      criadaEm: json['criada_em'] != null
          ? DateTime.tryParse(json['criada_em'].toString())
          : null,
      nomeMaquina: nomeMaq,
    );
  }
}

class DashboardResumoModel {
  final int totalMaquinas;
  final int maquinasAtivas;
  final int maquinasEmManutencao;
  final int maquinasInativas;
  final double totalHorasTrabalhadas;
  final int totalNotificacoes;
  final int notificacoesNaoLidas;
  final Map<String, int> alertasPorTipo;
  final List<Map<String, dynamic>> horasPorMaquina;
  final List<MaquinaModel> maquinas;
  final List<HorasModel> ultimasHoras;
  final List<NotificacaoModel> ultimasNotificacoes;

  const DashboardResumoModel({
    required this.totalMaquinas,
    required this.maquinasAtivas,
    required this.maquinasEmManutencao,
    required this.maquinasInativas,
    required this.totalHorasTrabalhadas,
    required this.totalNotificacoes,
    required this.notificacoesNaoLidas,
    required this.alertasPorTipo,
    required this.horasPorMaquina,
    required this.maquinas,
    required this.ultimasHoras,
    required this.ultimasNotificacoes,
  });

  factory DashboardResumoModel.fromJson(Map<String, dynamic> json) {
    final listMaquinas = (json['maquinas'] as List? ?? [])
        .map((m) => MaquinaModel.fromJson(m as Map<String, dynamic>))
        .toList();

    final listHoras = (json['ultimasHoras'] as List? ?? [])
        .map((h) => HorasModel.fromJson(h as Map<String, dynamic>))
        .toList();

    final listNotifs = (json['ultimasNotificacoes'] as List? ?? [])
        .map((n) => NotificacaoModel.fromJson(n as Map<String, dynamic>))
        .toList();

    final mapAlertas = <String, int>{};
    if (json['alertasPorTipo'] is Map) {
      (json['alertasPorTipo'] as Map).forEach((k, v) {
        mapAlertas[k.toString()] = int.tryParse(v.toString()) ?? 0;
      });
    }

    final listHorasMaq = <Map<String, dynamic>>[];
    if (json['horasPorMaquina'] is List) {
      for (final item in json['horasPorMaquina']) {
        if (item is Map) {
          listHorasMaq.add(Map<String, dynamic>.from(item));
        }
      }
    }

    return DashboardResumoModel(
      totalMaquinas: json['totalMaquinas'] ?? listMaquinas.length,
      maquinasAtivas:
          json['maquinasAtivas'] ??
          listMaquinas.where((m) => m.status == 'ATIVA').length,
      maquinasEmManutencao:
          json['maquinasEmManutencao'] ??
          listMaquinas.where((m) => m.status == 'EM_MANUTENCAO').length,
      maquinasInativas:
          json['maquinasInativas'] ??
          listMaquinas.where((m) => m.status == 'INATIVA').length,
      totalHorasTrabalhadas:
          double.tryParse(json['totalHorasTrabalhadas']?.toString() ?? '0') ??
          0.0,
      totalNotificacoes: json['totalNotificacoes'] ?? listNotifs.length,
      notificacoesNaoLidas:
          json['notificacoesNaoLidas'] ??
          listNotifs.where((n) => !n.lida).length,
      alertasPorTipo: mapAlertas,
      horasPorMaquina: listHorasMaq,
      maquinas: listMaquinas,
      ultimasHoras: listHoras,
      ultimasNotificacoes: listNotifs,
    );
  }

  static DashboardResumoModel criarPadrao() {
    final maquinasPadrao = [
      const MaquinaModel(
        id: 1,
        nome: 'Torno Mecânico ROMI',
        codigo: 'TOR-01',
        tipo: 'Torno Mecânico',
        fabricante: 'ROMI',
        modelo: 'Centur 30D',
        horimetroAtual: 1420.50,
        status: 'ATIVA',
      ),
      const MaquinaModel(
        id: 2,
        nome: 'Torno Mecânico NARDINI',
        codigo: 'TOR-02',
        tipo: 'Torno Mecânico',
        fabricante: 'NARDINI',
        modelo: 'Masicote MS-220',
        horimetroAtual: 890.20,
        status: 'EM_MANUTENCAO',
      ),
      const MaquinaModel(
        id: 3,
        nome: 'Fresadora Universal KONI KFU-1',
        codigo: 'FRS-01',
        tipo: 'Fresadora',
        fabricante: 'KONI',
        modelo: 'KFU-1 Universal',
        horimetroAtual: 645.00,
        status: 'ATIVA',
      ),
      const MaquinaModel(
        id: 4,
        nome: 'Fresadora KONI KFU-2',
        codigo: 'FRS-02',
        tipo: 'Fresadora',
        fabricante: 'KONI',
        modelo: 'KFU-2 Vertical',
        horimetroAtual: 1150.80,
        status: 'ATIVA',
      ),
      const MaquinaModel(
        id: 5,
        nome: 'Retífica Plana Ferdimat',
        codigo: 'RET-01',
        tipo: 'Retífica',
        fabricante: 'Ferdimat',
        modelo: 'TA-60',
        horimetroAtual: 312.40,
        status: 'INATIVA',
      ),
    ];

    final horasPadrao = [
      const HorasModel(
        id: 1,
        maquinaId: 1,
        usuarioId: 2,
        dataOperacao: '2026-11-23',
        horasTrabalhadas: 4.0,
        horimetroInicio: 1416.50,
        horimetroFim: 1420.50,
        observacoes: 'Usinagem de peças de alumínio, lubrificação checada',
        nomeMaquina: 'Torno Mecânico ROMI',
        nomeOperador: 'Carlos Eduardo',
      ),
      const HorasModel(
        id: 2,
        maquinaId: 2,
        usuarioId: 2,
        dataOperacao: '2026-11-23',
        horasTrabalhadas: 2.5,
        horimetroInicio: 887.70,
        horimetroFim: 890.20,
        observacoes:
            'Alerta de vibração no cabeçote móvel, enviado para revisão',
        nomeMaquina: 'Torno Mecânico NARDINI',
        nomeOperador: 'Mariana Souza',
      ),
      const HorasModel(
        id: 3,
        maquinaId: 3,
        usuarioId: 2,
        dataOperacao: '2026-11-24',
        horasTrabalhadas: 3.5,
        horimetroInicio: 641.50,
        horimetroFim: 645.00,
        observacoes: 'Fresa de faceamento operando perfeitamente',
        nomeMaquina: 'Fresadora KONI KFU-1',
        nomeOperador: 'Lucas Mendonça',
      ),
    ];

    final notifsPadrao = [
      const NotificacaoModel(
        id: 1,
        usuarioId: 2,
        maquinaId: 2,
        tipo: 'MANUTENCAO',
        titulo: 'Manutenção Preventiva Necessária',
        mensagem:
            'Torno Mecânico NARDINI atingiu intervalo de troca de óleo e ajuste de correia.',
        lida: false,
        nomeMaquina: 'Torno Mecânico NARDINI',
      ),
      const NotificacaoModel(
        id: 2,
        usuarioId: 2,
        maquinaId: 1,
        tipo: 'HORAS',
        titulo: 'Registro de Horímetro Concluído',
        mensagem: '4 horas trabalhadas adicionadas ao Torno ROMI hoje.',
        lida: true,
        nomeMaquina: 'Torno Mecânico ROMI',
      ),
      const NotificacaoModel(
        id: 3,
        usuarioId: 2,
        maquinaId: 3,
        tipo: 'AVISO',
        titulo: 'Inspeção NR-12 Conforme',
        mensagem: 'Checklist matinal concluído com 100% de conformidade.',
        lida: false,
        nomeMaquina: 'Fresadora KONI KFU-1',
      ),
      const NotificacaoModel(
        id: 4,
        usuarioId: 2,
        tipo: 'SISTEMA',
        titulo: 'Atualização da Norma NR-12',
        mensagem:
            'Novo protocolo de segurança cadastrado para o parque fabril.',
        lida: true,
      ),
    ];

    return DashboardResumoModel(
      totalMaquinas: maquinasPadrao.length,
      maquinasAtivas: 3,
      maquinasEmManutencao: 1,
      maquinasInativas: 1,
      totalHorasTrabalhadas: 14.0,
      totalNotificacoes: notifsPadrao.length,
      notificacoesNaoLidas: 2,
      alertasPorTipo: {'MANUTENCAO': 1, 'HORAS': 1, 'AVISO': 1, 'SISTEMA': 1},
      horasPorMaquina: [
        {
          'nome': 'Torno ROMI',
          'codigo': 'TOR-01',
          'horas': 8.0,
          'horimetro': 1420.50,
        },
        {
          'nome': 'Torno NARDINI',
          'codigo': 'TOR-02',
          'horas': 2.5,
          'horimetro': 890.20,
        },
        {
          'nome': 'Fresadora KONI',
          'codigo': 'FRS-01',
          'horas': 3.5,
          'horimetro': 645.00,
        },
      ],
      maquinas: maquinasPadrao,
      ultimasHoras: horasPadrao,
      ultimasNotificacoes: notifsPadrao,
    );
  }
}

class AppSession {
  static int? id;
  static String nome = 'Carlos Eduardo Silva';
  static String email = 'carlos.silva@industria.com';
  static String cargo = 'Gestor';
  static String telefone = '(11) 98765-4321';
  static bool isGestor = false;
  static bool notificacoesAtivas = true;

  static final ValueNotifier<List<RegistroRecente>> registrosRecentesNotifier =
      ValueNotifier<List<RegistroRecente>>(
        CatalogoPerguntasNR12.criarRegistrosIniciais(),
      );

  static final ValueNotifier<DashboardResumoModel> dashboardNotifier =
      ValueNotifier<DashboardResumoModel>(DashboardResumoModel.criarPadrao());

  static List<RegistroRecente> get registrosRecentes =>
      registrosRecentesNotifier.value;

  static DashboardResumoModel get dashboard => dashboardNotifier.value;

  static void adicionarRegistro(RegistroRecente registro) {
    final listaAtual = registrosRecentesNotifier.value
        .where((r) => r.id != registro.id)
        .toList();
    registrosRecentesNotifier.value = [registro, ...listaAtual];
  }

  static void marcarComoVisto(String id) {
    registrosRecentesNotifier.value = registrosRecentesNotifier.value.map((
      reg,
    ) {
      if (reg.id == id) {
        reg.vistoPeloGestor = true;
      }
      return reg;
    }).toList();

    try {
      http
          .put(
            Uri.parse('http://localhost:3000/inspecoes-nr12/$id/visto'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 2))
          .then((_) {})
          .catchError((_) {});
    } catch (_) {}
  }

  static Future<bool> carregarDadosCompletosDoBanco() async {
    try {
      final response = await http
          .get(
            Uri.parse('http://localhost:3000/dashboard/resumo'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          dashboardNotifier.value = DashboardResumoModel.fromJson(data);
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> alterarStatusMaquina(int id, String novoStatus) async {
    try {
      final response = await http
          .patch(
            Uri.parse('http://localhost:3000/maquinas/$id/status'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'status': novoStatus}),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        await carregarDadosCompletosDoBanco();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<void> notificarQuaseNoFinal({
    required String equipamento,
    required String operador,
    required int etapaAtual,
    required int totalEtapas,
    required bool temAlertasAteAgora,
  }) async {
    try {
      await http
          .post(
            Uri.parse('http://localhost:3000/inspecoes-nr12/quase-no-final'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'equipamento': equipamento,
              'operador': operador,
              'etapaAtual': etapaAtual,
              'totalEtapas': totalEtapas,
              'temAlertasAteAgora': temAlertasAteAgora,
            }),
          )
          .timeout(const Duration(seconds: 3));
    } catch (_) {}
  }

  static Future<bool> marcarNotificacaoLida(int id) async {
    try {
      final response = await http
          .put(
            Uri.parse('http://localhost:3000/notificacoes/$id/lida'),
            headers: {'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200) {
        await carregarDadosCompletosDoBanco();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> registrarHoras({
    required int maquinaId,
    required double horasTrabalhadas,
    required double horimetroInicio,
    required double horimetroFim,
    String? observacoes,
  }) async {
    try {
      final body = {
        'maquina_id': maquinaId,
        'usuario_id': id ?? 2,
        'horas_trabalhadas': horasTrabalhadas,
        'horimetro_inicio': horimetroInicio,
        'horimetro_fim': horimetroFim,
        'observacoes': observacoes,
      };

      final response = await http
          .post(
            Uri.parse('http://localhost:3000/horas'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 3));

      if (response.statusCode == 200 || response.statusCode == 201) {
        await carregarDadosCompletosDoBanco();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> carregarRegistrosDoBanco() async {
    try {
      final response = await http
          .get(
            Uri.parse('http://localhost:3000/inspecoes-nr12'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data['inspecoes'] is List) {
          final List listaJson = data['inspecoes'];
          if (listaJson.isNotEmpty) {
            final registrosBanco = listaJson
                .map(
                  (item) =>
                      RegistroRecente.fromJson(item as Map<String, dynamic>),
                )
                .toList();

            registrosRecentesNotifier.value = registrosBanco;
            return true;
          }
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static Future<bool> salvarInspecaoNoBanco(
    RegistroRecente registro, {
    double? horimetroInicio,
    double? horimetroFim,
    double? horasTrabalhadas,
  }) async {
    adicionarRegistro(registro);

    try {
      final payload = {
        'titulo': registro.titulo,
        'equipamento': registro.equipamento,
        'operador': registro.operador,
        'emailOperador': registro.emailOperador,
        'turno': registro.turno,
        'curso': registro.curso,
        'data': registro.data.toIso8601String(),
        'status': registro.status,
        'observacao': registro.observacao,
        'respostas': registro.respostas,
        if (horimetroInicio != null) 'horimetroInicio': horimetroInicio,
        if (horimetroFim != null) 'horimetroFim': horimetroFim,
        if (horasTrabalhadas != null) 'horasTrabalhadas': horasTrabalhadas,
      };

      final response = await http
          .post(
            Uri.parse('http://localhost:3000/inspecoes-nr12'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(const Duration(seconds: 4));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        if (data is Map && data['inspecao'] != null) {
          final novoDoBanco = RegistroRecente.fromJson(
            data['inspecao'] as Map<String, dynamic>,
          );
          final listaAtualizada = registrosRecentesNotifier.value
              .map((r) => r.id == registro.id ? novoDoBanco : r)
              .toList();
          registrosRecentesNotifier.value = listaAtualizada;
        }
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static void setUsuario({
    int? idUsuario,
    required String nomeUsuario,
    required String emailUsuario,
    bool gestor = false,
    String? telefoneUsuario,
  }) {
    id = idUsuario;
    nome = nomeUsuario;
    email = emailUsuario;
    isGestor = gestor;
    cargo = gestor ? 'Gestor' : 'Operário de Manutenção';
    if (telefoneUsuario != null && telefoneUsuario.trim().isNotEmpty) {
      telefone = telefoneUsuario.trim();
    }
  }

  static void atualizarPerfil({
    String? novoNome,
    String? novoEmail,
    String? novoTelefone,
  }) {
    if (novoNome != null && novoNome.trim().isNotEmpty) {
      nome = novoNome.trim();
    }
    if (novoEmail != null && novoEmail.trim().isNotEmpty) {
      email = novoEmail.trim();
    }
    if (novoTelefone != null && novoTelefone.trim().isNotEmpty) {
      telefone = novoTelefone.trim();
    }
  }

  static Future<bool> salvarNoBanco({
    String? novoNome,
    String? novoEmail,
    String? novoTelefone,
  }) async {
    try {
      final body = {
        if (id != null) 'id': id,
        'email': (novoEmail ?? email).trim(),
        'nome': (novoNome ?? nome).trim(),
        'telefone': (novoTelefone ?? telefone).trim(),
      };

      final response = await http.put(
        Uri.parse('http://localhost:3000/auth/perfil'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data is Map &&
          data['sucesso'] == true) {
        atualizarPerfil(
          novoNome: novoNome,
          novoEmail: novoEmail,
          novoTelefone: novoTelefone,
        );
        return true;
      }

      atualizarPerfil(
        novoNome: novoNome,
        novoEmail: novoEmail,
        novoTelefone: novoTelefone,
      );
      return false;
    } catch (_) {
      atualizarPerfil(
        novoNome: novoNome,
        novoEmail: novoEmail,
        novoTelefone: novoTelefone,
      );
      return false;
    }
  }
}
