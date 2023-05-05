import 'dart:async';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var tempo = 135;
  Timer? timer;
  late var tempoFormatado = formatarTempo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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