import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:horariopucpr/modules/utils/Utils.dart';

final GlobalKey<ScaffoldState> ATT_ATVD_SCFLD_KEY =
    new GlobalKey<ScaffoldState>();

class AtualizaAtividade extends StatefulWidget {
  String nome;
  String desc;
  String materia;
  DateTime timestamp;
  var agendaId, materias;
  void Function(String, String, String, int) updateCallback;

  AtualizaAtividade(this.nome, this.materia, this.desc, this.timestamp,
      this.agendaId, this.materias, this.updateCallback);

  @override
  State createState() => AtualizaAtividadeState();
}

class AtualizaAtividadeState extends State<AtualizaAtividade> {

  int _selectedDayIndex = 0;
  int _selectedMateriaIndex = 0;

  TextEditingController nomeController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  FixedExtentScrollController _dateController;
  FixedExtentScrollController _materiaController ;


  @override
  void initState() {
    _selectedDayIndex = getDates(DateTime.now()).indexOf(this.widget.timestamp);
    _selectedMateriaIndex = this.widget.materias.indexOf(this.widget.materia);
    nomeController.text = this.widget.nome;
    descController.text = this.widget.desc;

    print('$_selectedMateriaIndex, $_selectedDayIndex, ${getDates(DateTime.now())}, ${this.widget.materias}');
    _dateController = new FixedExtentScrollController(initialItem: _selectedDayIndex);
    _materiaController = new FixedExtentScrollController(initialItem: _selectedMateriaIndex);
    print('Initted SHIW!, ${_materiaController.initialItem}, $_selectedDayIndex');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ATT_ATVD_SCFLD_KEY,
      appBar: AppBar(
        backgroundColor: PUC_COLOR,
        title: Text(
          'Editando uma atividade',
          style: TextStyle(fontSize: 18.0),
        ),
      ),
      body: Container(
        child: Column(
          children: buildOptions(),
        ),
        margin: EdgeInsets.only(left: 8.0, right: 8.0),
      ),
      backgroundColor: Colors.white,
    );
  }
  static List<DateTime> getDates(DateTime startTime) {
    List<DateTime> ret = new List<DateTime>();
    int ano = startTime.year;
    int numDaysByMonth(int year, int month) {
      return DateTime(year, month, 0).day;
    }

    for (int mes = startTime.month; mes <= 12; mes++) {
      int days = numDaysByMonth(ano, mes) + 1;
      for (int dia = 1; dia <= days; dia++) {
        DateTime dateTime = DateTime(ano, mes, dia);
        ret.add(dateTime);
      }
    }
    return ret;
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

    Widget buildMateriasSelector() {
      List<Widget> options = [];
      for (var i in this.widget.materias)
        options.add(
          Text(
            i,
            overflow: TextOverflow.ellipsis,
          ),
        );

      return CupertinoPicker(
          children: options,
          itemExtent: 20.0,
          onSelectedItemChanged: (int value) {
            _selectedMateriaIndex = value;
          },
          looping: true,
          scrollController: _materiaController,
          backgroundColor: Colors.white);
    }


    List<Widget> dateOptions() {
      List<Widget> ret = new List<Widget>();
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
      for (DateTime dateTime in getDates(DateTime.now())) {
        ret.add(Text(
            '${weekDays[dateTime.weekday - 1]}, ${dateTime.day} de ${months[dateTime.month - 1]}'));
      }

      return ret;
    }

    Widget buildDateSelector() {
      List<Widget> options = dateOptions();
      return CupertinoPicker(
          children: options,
          itemExtent: 20.0,
          onSelectedItemChanged: (int value) {
            _selectedDayIndex = value;
          },
          looping: false,
          scrollController: _dateController,
          backgroundColor: Colors.white
//      ThemeData
//          .light()
//          .scaffoldBackgroundColor,
          );
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
      onPressed: () => updateAtividade(),
    )));
    return ret;
  }

  updateAtividade() {
    if (nomeController.text == '') {
      FocusScope.of(context).requestFocus(new FocusNode());
      ATT_ATVD_SCFLD_KEY.currentState.showSnackBar(SnackBar(
        content: Text(
          'Você precisa dar um nome a sua tarefa!',
        ),
        duration: Duration(seconds: 4),
      ));
      return;
    }

    String nome = this.nomeController.value.text;
    String desc = this.descController.value.text;
    int time = getDates(DateTime.now())[_selectedDayIndex].millisecondsSinceEpoch;
    String materia = this.widget.materias[_selectedMateriaIndex];

    print('Updating materia $nome, $desc, $time, $materia');
    this.widget.updateCallback(nome, materia, desc, time);
    Navigator.pop(this.context);

  }
}
