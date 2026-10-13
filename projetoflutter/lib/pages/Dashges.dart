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
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF6B0000), Color(0xFF0F0F0F), Color(0xFF0A0A0A)],
          stops: [0.0, 0.22, 1.0],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Center(
            child: Image.asset(
              'assets/nome.png',
              height: 70,
              errorBuilder: (context, error, stackTrace) => const Text(
                'Gestão Industrial',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () {
                  Perfil.abrir(context);
                },
                child: const Hero(
                  tag: 'profile_avatar_hero',
                  child: CircleAvatar(
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
        drawer: const Drawer(),
        body: const SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ),
    );
  }
}
