import 'dart:convert';
import 'package:http/http.dart' as http;

class GuardarProcessoApi {
  static GuardarProcesso(String NumProcesso, String AnoProcesso,
      String NumEstanteEPrateleira) async {
    Uri url = Uri.parse(
        'http://www.santoandre.sp.gov.br/APIportalservico/AppPSA/processoestanteprateleira');

    Map<String, String> cabecalhoToken = {
      "Content-Type": "application/json-patch+json",
      "accept": "/",
      "usuario": "apparqcentral",
      "senha": "ce!LRarDETXkdDo!rKNm",
    };

    Map dadosProcesso = {
      "processo": {"numeroproc": NumProcesso, "anoproc": AnoProcesso},
      "prateleira": NumEstanteEPrateleira
    };

    var bodyProcesso = json.encode(dadosProcesso);

    var response =
        await http.post(url, headers: cabecalhoToken, body: bodyProcesso);

    var v_statusCode = response.statusCode;
    var JsonDadosRetornoDecode;

    if (v_statusCode == 200) {
      JsonDadosRetornoDecode = json.decode(response.body);
    } else {
      Map<String, String> DadosRetornoErro = {
        "cod_retorno": "4",
        "dsc_mensagem_retorno":
            "SERVIÇO FORA DO AR, CONTACTAR O SUPORTE DO APP",
        "num_prateleira": "",
        "dta_info_prateleira": ""
      };

      var JsonDadosRetornoErro = json.encode(DadosRetornoErro);

      JsonDadosRetornoDecode = json.decode(JsonDadosRetornoErro.toString());
    }

    return JsonDadosRetornoDecode;
  }
}
