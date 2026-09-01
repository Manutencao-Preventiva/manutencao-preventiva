import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Dash extends StatefulWidget {
  const Dash({super.key});

  @override
  State<Dash> createState() => _DashState();
}

class _DashState extends State<Dash> {
  int selectedIndex = 0;

  final menus = const [
    {'titulo': 'MTTR', 'descricao': 'Tempo médio para reparo'},
    {'titulo': 'MTBF', 'descricao': 'Tempo médio entre falhas'},
    {'titulo': 'OEE', 'descricao': 'Eficiência geral do equipamento'},
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(backgroundColor: Colors.black),
        drawer: Drawer(
          surfaceTintColor: Colors.white,
          child: Column(
            children: [
              CircleAvatar(child: Icon(Icons.person, color: Colors.black)),
            ],
          ),
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(color: Colors.black),
          child: SafeArea(
            child: Column(
              children: [
                Row(
                  children: [
                    const Spacer(),
                    //
                    const SizedBox(width: 5),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                  child: CarouselSlider(
                    options: CarouselOptions(autoPlay: true),
                    items: menus.map((menu) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color.fromARGB(
                                        255,
                                        53,
                                        53,
                                        53,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),

                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.lock_clock_outlined),
                                        Text(
                                          '    ${menu['titulo']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
