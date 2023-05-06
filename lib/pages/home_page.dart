import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var tempoController = TextEditingController();
  var tempo = 135;
  Timer? timer;
  late var tempoFormatado = formatarTempo();

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
                    Text("Tempo"),
                    Expanded(child: TextField(
                      controller: tempoController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),),
                  ],
                ),
                ElevatedButton(onPressed: (){
                  setState(() {
                    tempo = int.parse(tempoController.text)*60;
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