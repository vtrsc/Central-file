class MapLocalizarProcesso {
  String cod_retorno;
  String dsc_mensagem_retorno;
  String num_prateleira;
  String dta_info_prateleira;

  MapLocalizarProcesso(
      {required this.cod_retorno,
      required this.dsc_mensagem_retorno,
      required this.num_prateleira,
      required this.dta_info_prateleira});

  factory MapLocalizarProcesso.fromJson(Map<String, dynamic> parsedJson) {
    return MapLocalizarProcesso(
        cod_retorno: parsedJson['cod_retorno'].toString(),
        dsc_mensagem_retorno: parsedJson['dsc_mensagem_retorno'].toString(),
        num_prateleira: parsedJson['num_prateleira'].toString(),
        dta_info_prateleira: parsedJson['dta_info_prateleira'].toString());
  }
}
