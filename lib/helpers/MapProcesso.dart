class MapProcesso {
  String cod_retorno;
  String dsc_mensagem_retorno;
  String num_prateleira;
  String dta_info_prateleira;

  MapProcesso(
      {required this.cod_retorno,
      required this.dsc_mensagem_retorno,
      required this.num_prateleira,
      required this.dta_info_prateleira});

  factory MapProcesso.fromJson(Map<String, dynamic> parsedJson) {
    return MapProcesso(
        cod_retorno: parsedJson['cod_retorno'].toString(),
        dsc_mensagem_retorno: parsedJson['dsc_mensagem_retorno'].toString(),
        num_prateleira: parsedJson['num_prateleira'].toString(),
        dta_info_prateleira: parsedJson['num_prateleira'].toString());
  }

  Map toJson() {
    return {
      "cod_retorno": this.cod_retorno,
      "dsc_mensagem_retorno": this.dsc_mensagem_retorno,
      "num_prateleira": this.num_prateleira,
      "dta_info_prateleira": this.dta_info_prateleira,
    };
  }
}
