class Translator{
  Map<String, String> translations = {	'January': 'Janeiro',
    'February': 'Fevereiro',
    'March': 'Março',
    'April': 'Abril',
    'May': 'Maio',
    'June': 'Junho',
    'July': 'Julho',
    'August': 'Agosto',
    'September': 'Setembro',
    'October': 'Outubro',
    'November': 'Novembro',
    'December': 'Dezembro',
    'Sun': 'Dom', 'Mon': 'Seg', 'Tue': 'Ter', 'Wed': 'Qua', 'Thu': 'Qui', 'Fri': 'Sex', 'Sat': 'Sáb'};

  String translateMonth(s){
    var ano = s.split(' ')[1];
    s = s.split(' ')[0];
    return '${translations[s]} $ano';
  }

  String translateDay(String day) {
    return '${translations[day]}';
  }
}