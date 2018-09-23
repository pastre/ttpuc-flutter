import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';
import 'dart:math';

class AtividadeWidget extends StatefulWidget {

  List<String> options;

  AtividadeWidget({this.options});

  @override
  State<StatefulWidget> createState() {
    return AtividadeState();
  }

  List<DropdownMenuItem<String>> buildDDOptions() {
    List<DropdownMenuItem<String>> ret = new List<DropdownMenuItem<String>>();
    for (String o in this.options) {
      ret.add(new DropdownMenuItem(
        value: o,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(child: Text(o), width: 200.0,),
        ),
      ));
    }
    return ret;
  }

  List<Widget> buildMateriasOptions() {
    List<Widget> ret = new List<Widget>();
    var added = [];
    for (String o in this.options) {
      Widget toAppend = Text(o, overflow: TextOverflow.ellipsis,);
      if (added.contains(o)) continue;
      ret.add(toAppend);
      added.add(o);
    }

    return ret;
  }
}

class AtividadeState extends State<AtividadeWidget> {

  TextEditingController nomeController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  FixedExtentScrollController _c = new FixedExtentScrollController();
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

  Widget _selectedDayIndex, _selectedMateriaIndex;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: PUC_COLOR,
          title: Text(
            'Adicione uma atividade', style: TextStyle(fontSize: 18.0),),),
        body:
        Container(
          child: Column(children: buildOptions(),),
          margin: EdgeInsets.only(left: 8.0, right: 8.0),
        )
    );
  }

  List<Widget> buildOptions() {
    List<Widget> ret = new List<Widget>();
    ret.add(buildOption(
        TextField(
          controller: nomeController,
          decoration: this.decorateTextField(
              'Nome', 'Ex.:Prova, TDE, Atividade, etc...'),
          cursorColor: PUC_COLOR,
        )));
    ret.add(SizedBox(height: 32.0,));
    ret.add(buildOption(
        TextField(
          controller: descController,
          decoration: this.decorateTextField('Descrição',
              'Ex.: Prova valendo 10 pontos. Estudar capítulos 2 e 3 do livro'),
          cursorColor: PUC_COLOR,
        )));
    ret.add(SizedBox(height: 32.0,));
    ret.add(buildOption(buildMateriasSelector()));
    ret.add(buildOption(buildDateSelector()));


    ret.add(buildOption(SimpleDialogOption(child: Row(
      children: <Widget>[Text('Pronto', style: TextStyle(color: PUC_COLOR),)],
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,),
      onPressed: () => addAtividade(),)));
//    ret.add(SizedBox(height: 8.0,));
    return ret;
  }

  InputDecoration decorateTextField(String name, String helper) {
    return InputDecoration(
      labelText: name,
      labelStyle: TextStyle(color: PUC_COLOR),
      helperText: helper,
      helperStyle: TextStyle(
          color: PUC_COLOR.withAlpha(150), fontStyle: FontStyle.italic),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey)),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: PUC_COLOR),),

    );
  }

  Widget buildMateriasSelector() {
    List<Widget> options = this.widget.buildMateriasOptions();
    return CupertinoPicker(
      children: options,
      itemExtent: 20.0,
      onSelectedItemChanged: (int value) {
        _selectedMateriaIndex = options[value];
      },
      looping: true,
      scrollController: _c,
      backgroundColor: ThemeData
          .light()
          .scaffoldBackgroundColor,
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
      backgroundColor: ThemeData
          .light()
          .scaffoldBackgroundColor,
    );
  }

  List<Widget> dateOptions(DateTime startTime) {
    List<Widget> ret = new List<Widget>();
    int ano = startTime.year;

//    meses = ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun', 'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez'];
    var weekDays = ['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom',];
    for (int mes = startTime.month; mes <= 12; mes++) {
      int days = numDaysByMonth(ano, mes);
      for (int dia = 1; dia <= days; dia++) {
        DateTime dateTime = DateTime(ano, mes, dia);
        ret.add(Text('${weekDays[dateTime.weekday - 1]}, ${dateTime
            .day} de ${months[dateTime.month - 1]}'));
      }
    }

    return ret;
  }

  int numDaysByMonth(int year, int month) {
    return DateTime(year, month, 0).day;
  }

  Widget buildOption(Widget child) {
    var options = [Flexible(child: child,)];
    return
      Flexible(
        child:
        Row(
          children: options,
          mainAxisSize: MainAxisSize.min,
        )
        , fit: FlexFit.tight,
      );
  }

  void addAtividade() {
    String formatText(String text){
      return  text.replaceAll("(", '').replaceAll("\"", '').replaceAll(")", '').replaceFirst('Text', '');
    }

    String dia = formatText(_selectedDayIndex.toString()),
        materia = formatText(_selectedMateriaIndex.toString()),
        nome = this.nomeController.value.text,
        desc = this.descController.value.text;
    var splitted  =dia.split(' ');
    int time = DateTime(2018, months.indexOf(splitted.last) + 1, int.parse(splitted[1])).millisecondsSinceEpoch;
    print('DAY: $time\n MATERIA: $materia \nNOME: $nome \nDESC $desc');

  }


}