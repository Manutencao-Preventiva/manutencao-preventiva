import 'dart:convert';
import 'package:http/http.dart' as http;

class AppSession {
  static int? id;
  static String nome = 'Carlos Eduardo Silva';
  static String email = 'carlos.silva@industria.com';
  static String cargo = 'Operário de Manutenção';
  static String telefone = '(11) 98765-4321';
  static bool isGestor = false;
  static bool notificacoesAtivas = true;

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

  /// Salva no banco de dados via API NestJS (nome e telefone)
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

      if (response.statusCode == 200 && data is Map && data['sucesso'] == true) {
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
