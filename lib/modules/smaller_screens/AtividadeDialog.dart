import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/core/Agenda.dart';
import 'package:horariopucpr/modules/smaller_screens/LoadingScreen.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'package:horariopucpr/modules/core/Generic.dart';

class AtividadeWidget extends GenericAppWidget {
  List<String> options;
  AgendaState agenda;

  AtividadeWidget({this.options, this.agenda}) : super(state: AtividadeState(agenda: agenda));

  @override
  State<StatefulWidget> createState() {
    return AtividadeState(agenda: agenda);
  }
}

class AtividadeState extends GenericAppState<AtividadeWidget> {
  // Variaveis dos campos
  TextEditingController nomeController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  Widget _selectedDayIndex, _selectedMateriaIndex;
  FixedExtentScrollController _c = new FixedExtentScrollController();
  //-----------------------------------------------------//
  var materias = [];
  List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  AgendaState agenda;
  AtividadeState({this.agenda});

  bool isLoading = false;


  @override
  void preinit() {
    isLoading = false;
    materias = [];
  }


  @override
  Widget build(BuildContext ctx) {
    return super.build(ctx);
  }

  @override
  Widget buildScreen(BuildContext ctx) {
    if(isLoading == null) isLoading = false;
    return  buildMain();
  }

  @override
  bool hasLoaded() {
    return this.materias.isNotEmpty;
  }

  @override
  void updateLocal(data) {
    this.storage.setMaterias(data);
  }

  @override
  Future loadLocal() {
    return this.storage.getMaterias();
  }

  @override
  Future apiCall() {
    return this.api.getMaterias();
  }

  @override
  void updateState(data) {
    setState(() {
      print('Data is $data');
      var ret =  json.decode(data);
      this.materias = ret['materias'];
    });
  }
  Widget buildMain(){

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PUC_COLOR,
        title: Text(
          'Adicione uma atividade',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      body: Container(
        child:  isLoading ? LoadingWidget() : Column(
          children: buildOptions(),
        ),
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
      ),
      backgroundColor: Colors.white,
    );
  }

  List<Widget> buildOptions() {
    InputDecoration decorateTextField(String name, String helper) {
      return InputDecoration(
        labelText: name,
        labelStyle: TextStyle(color: PUC_COLOR),
        helperText: helper,
        helperStyle: TextStyle(
            color: PUC_COLOR.withAlpha(150), fontStyle: FontStyle.italic),
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: PUC_COLOR),
        ),
      );
    }
    List<Widget> ret = new List<Widget>();
    ret.add(buildOption(TextField(
      controller: nomeController,
      decoration:
          decorateTextField('Nome', 'Ex.:Prova, TDE, Atividade, etc...'),
      cursorColor: PUC_COLOR,
    )));
    ret.add(SizedBox(
      height: 32.0,
    ));
    ret.add(buildOption(TextField(
      controller: descController,
      decoration: decorateTextField('Descrição',
          'Ex.: Prova valendo 10 pontos. Estudar capítulos 2 e 3 do livro'),
      cursorColor: PUC_COLOR,
    )));
    ret.add(SizedBox(
      height: 32.0,
    ));
    ret.add(buildOption(buildMateriasSelector()));
    ret.add(buildOption(buildDateSelector()));

    ret.add(buildOption(SimpleDialogOption(
      child: Row(
        children: <Widget>[
          Text(
            'Pronto',
            style: TextStyle(color: PUC_COLOR),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.end,
      ),
      onPressed: () => addAtividade(),
    )));
//    ret.add(SizedBox(height: 8.0,));
    return ret;
  }

  Widget buildMateriasSelector() {
    // TODO Pegar isso da memoria
    List<Widget> options = [];
    for(var m in materias)
      options.add(
        Text(
          m,
          overflow: TextOverflow.ellipsis,
        ),);

    return CupertinoPicker(
        children: options,
        itemExtent: 20.0,
        onSelectedItemChanged: (int value) {
          _selectedMateriaIndex = options[value];
        },
        looping: true,
        scrollController: _c,
        backgroundColor: Colors.white
//      ThemeData
//          .light()
//          .scaffoldBackgroundColor,
        );
  }

  Widget buildDateSelector() {
    List<Widget> options = dateOptions(DateTime.now());
    return CupertinoPicker(
        children: options,
        itemExtent: 20.0,
        onSelectedItemChanged: (int value) {
          _selectedDayIndex = options[value];
        },
        looping: false,
        scrollController: _c,
        backgroundColor: Colors.white
//      ThemeData
//          .light()
//          .scaffoldBackgroundColor,
        );
  }

  List<Widget> dateOptions(DateTime startTime) {
    List<Widget> ret = new List<Widget>();
    int ano = startTime.year;
    int numDaysByMonth(int year, int month) {
      return DateTime(year, month, 0).day;
    }

//    meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    var weekDays = [
      'Seg',
      'Ter',
      'Qua',
      'Qui',
      'Sex',
      'Sáb',
      'Dom',
    ];
    for (int mes = startTime.month; mes <= 12; mes++) {
      int days = numDaysByMonth(ano, mes);
      for (int dia = 1; dia <= days; dia++) {
        DateTime dateTime = DateTime(ano, mes, dia);
        ret.add(Text(
            '${weekDays[dateTime.weekday - 1]}, ${dateTime.day} de ${months[dateTime.month - 1]}'));
      }
    }

    return ret;
  }

  Widget buildOption(Widget child) {
    var options = [
      Flexible(
        child: child,
      )
    ];
    return Flexible(
      child: Row(
        children: options,
        mainAxisSize: MainAxisSize.min,
      ),
      fit: FlexFit.tight,
    );
  }

  void addAtividade() {
    String formatText(String text) {
      return text
          .replaceAll("(", '')
          .replaceAll("\"", '')
          .replaceAll(")", '')
          .replaceFirst('Text', '')
          .replaceAll(',', '');
    }

    String dia = formatText(_selectedDayIndex.toString()),
        materia = formatText(_selectedMateriaIndex.toString().replaceAll(' overflow: ellipsis',  '')),
        nome = this.nomeController.value.text,
        desc = this.descController.value.text;
    var splitted = dia.split(' ');
    int time = DateTime(
            2018, months.indexOf(splitted.last) + 1, int.parse(splitted[1]))
        .millisecondsSinceEpoch;
    splitted = materia.split(' ');
    materia = splitted[0];
    setState(() {
      isLoading = true;
    });
    this.api.addAtividade(nome, desc, time, materia ).then((val){
      print('Atividades is $val');
      this.storage.setAtividades(val);
      this.agenda.fetchData();
      Navigator.pop(this.context);
    });
    print(
        'DAY: $time\nMATERIA: $materia \nNOME: $nome \nDESC $desc');
  }
}
