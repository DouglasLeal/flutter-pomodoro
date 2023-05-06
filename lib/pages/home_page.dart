import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pomodoroController = TextEditingController();
  var pausaCurtaController = TextEditingController();
  var pausaLongaController = TextEditingController();

  var pomodoroTempo = 60;
  var pausaCurtaTempo = 60;
  var pausaLongaTempo = 60;

  Timer? timer;
  late var tempo = pomodoroTempo;
  late var tempoFormatado = formatarTempo();

  @override
  void initState() {
    super.initState();

    pomodoroController.text = (pomodoroTempo ~/ 60).toString();
    pausaCurtaController.text = (pausaCurtaTempo ~/ 60).toString();
    pausaLongaController.text = (pausaLongaTempo ~/ 60).toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: Drawer(
          child: SafeArea(
            child: Column(
              children: [
                Text("Config"),
                Row(
                  children: [
                    Text("Pomodoro"),
                    Expanded(child: TextField(
                      controller: pomodoroController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),),
                  ],
                ),
                Row(
                  children: [
                    Text("Pausa Curta"),
                    Expanded(child: TextField(
                      controller: pausaCurtaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),),
                  ],
                ),
                Row(
                  children: [
                    Text("Pausa Longa"),
                    Expanded(child: TextField(
                      controller: pausaLongaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),),
                  ],
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    pomodoroTempo = int.parse(pomodoroController.text)*60;
                    pausaCurtaTempo = int.parse(pausaCurtaController.text)*60;
                    pausaLongaTempo = int.parse(pausaLongaController.text)*60;
                    tempoFormatado = formatarTempo();
                  });
                  if(timer != null){
                    iniciarEPausarContagem();
                  }
                  Navigator.pop(context);
                }, child: Text("Salvar"),),
              ],
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: Text(tempoFormatado),),
            ElevatedButton(onPressed: (){
              iniciarEPausarContagem();
            }, child: timer == null ? const Text("Iniciar") : const Text("Pausar"),),
          ],
        )
    );
  }

  void iniciarEPausarContagem(){
    if(timer != null){
      timer!.cancel();
      timer = null;
    }else{
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if( tempo > 0) {
          tempo--;
          setState(() {
            tempoFormatado = formatarTempo();
          });
        }
      });
    }

    setState(() {
    });
  }

  String formatarTempo(){
    var minutos = tempo ~/ 60;
    var segundos = tempo % 60;
    return "${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}";
  }
}