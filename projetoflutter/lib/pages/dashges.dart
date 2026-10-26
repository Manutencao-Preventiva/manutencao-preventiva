import 'package:flutter/material.dart';
import 'package:projetoflutter/pages/perfil.dart';

class Dashges extends StatefulWidget {
  const Dashges({super.key});

  @override
  State<Dashges> createState() => _DashgesState();
}

class _DashgesState extends State<Dashges> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Perfil()),
          );
        },
        child: Text('asdbcibuic'),
      ),
    );
  }
}
