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

  var pomodoroTempo = 900;
  var pausaCurtaTempo = 300;
  var pausaLongaTempo = 900;

  Timer? timer;
  var contagemPausas = 0;
  var momentoPomodoro = false;
  Color? corBackground;

  late var tempo;
  late var tempoFormatado = formatarTempo();

  @override
  void initState() {
    super.initState();

    apresentarTemposNoTextField();
    prepararPomodoro();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: corBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.black,
          actions: [
            TextButton(onPressed: () { reiniciar(); },
            child: const Icon(Icons.refresh, color: Colors.black,),)
          ],
        ),
        drawer: Drawer(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  txt("Config", fontSize: 32.0),
                  timeInput("Pomodoro", pomodoroController),
                  timeInput("Pausa Curta", pausaCurtaController),
                  timeInput("Pausa Longa", pausaLongaController),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        pomodoroTempo = int.parse(pomodoroController.text) * 60;
                        pausaCurtaTempo =
                            int.parse(pausaCurtaController.text) * 60;
                        pausaLongaTempo =
                            int.parse(pausaLongaController.text) * 60;
                        tempoFormatado = formatarTempo();
                      });
                      reiniciar();
                      Navigator.pop(context);
                    },
                    child: Text("Salvar"),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                tempoFormatado,
                style: const TextStyle(
                  fontSize: 120,
                ),
              ),
            ),
            timer == null
                ? button("Iniciar", iniciarContagem)
                : button("Pausar", pausarContagem),
          ],
        ));
  }

  void iniciarContagem() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (tempo > 0) {
        tempo--;
        setState(() {
          tempoFormatado = formatarTempo();
        });
      } else {
        pausarContagem();
        if (momentoPomodoro) {
          if (contagemPausas > 3) {
            contagemPausas = 0;
            prepararPausaLonga();
          } else {
            contagemPausas++;
            prepararPausaCurta();
          }
        } else {
          prepararPomodoro();
        }
      }
    });

    setState(() {});
  }

  void pausarContagem() {
    if(timer != null){
      timer!.cancel();
      timer = null;
    }

    setState(() {});
  }

  void reiniciar(){
    pausarContagem();
    prepararPomodoro();
  }

  void prepararPomodoro() {
    tempo = pomodoroTempo;
    tempoFormatado = formatarTempo();
    momentoPomodoro = true;
    corBackground = Colors.redAccent;
    setState(() {});
  }

  void prepararPausaCurta() {
    tempo = pausaCurtaTempo;
    tempoFormatado = formatarTempo();
    momentoPomodoro = false;
    corBackground = Colors.blueAccent;
    setState(() {});
  }

  void prepararPausaLonga() {
    tempo = pausaLongaTempo;
    tempoFormatado = formatarTempo();
    momentoPomodoro = false;
    corBackground = Colors.greenAccent;
    setState(() {});
  }

  void apresentarTemposNoTextField() {
    pomodoroController.text = (pomodoroTempo ~/ 60).toString();
    pausaCurtaController.text = (pausaCurtaTempo ~/ 60).toString();
    pausaLongaController.text = (pausaLongaTempo ~/ 60).toString();
  }

  String formatarTempo() {
    var minutos = tempo ~/ 60;
    var segundos = tempo % 60;
    return "${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}";
  }
}

Widget button(String texto, Function fn) {
  return ElevatedButton(
    onPressed: () {
      fn();
    },
    style: ButtonStyle(),
    child: Text(
      texto,
      style: const TextStyle(
        fontSize: 40,
      ),
    ),
  );
}

Widget txt(texto, {fontSize = 16.0}){
  return Text(texto, style: TextStyle(fontSize: fontSize),);
}

Widget timeInput(texto, controller){
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      txt(texto),
      SizedBox(
        width: 170,
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: const InputDecoration(
            suffix: Text("min"),
          ),
        ),
      ),
    ],
  );
}