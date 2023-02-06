import 'dart:convert';
import 'package:http/http.dart' as http;

class ProcessoApi 
{
  static LocalizarProcesso(String NumProcesso, String AnoProcesso) async 
  {
    Uri url = Uri.parse('http://www.santoandre.sp.gov.br/APIportalservico/AppPSA/consultaprocesso');

    Map<String, String> cabecalhoToken = 
    {
      "Content-Type": "application/json-patch+json",
      "accept": "/",
      "usuario": "",
      "senha": "",
    };

    Map dadosProcesso = {"numeroproc": NumProcesso, "anoproc": AnoProcesso};
    var bodyProcesso = json.encode(dadosProcesso);
    var response = await http.post(url, headers: cabecalhoToken, body: bodyProcesso);
    var v_statusCode = response.statusCode;
    var JsonDadosRetornoDecode;

    if (v_statusCode == 200) 
    {
      JsonDadosRetornoDecode = json.decode(response.body);
    } 
    else 
    {
      Map<String, String> DadosRetornoErro = 
      {
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

  static GuardarProcesso(String NumProcesso, String AnoProcesso, String EstantePrateleira) async 
  {
    Uri url = Uri.parse('http://www.santoandre.sp.gov.br/APIportalservico/AppPSA/processoestanteprateleira');

    Map<String, String> cabecalhoToken = 
    {
      "Content-Type": "application/json-patch+json",
      "accept": "/",
      "usuario": "apparqcentral",
      "senha": "ce!LRarDETXkdDo!rKNm",
    };

    Map dadosProcesso = 
    {
      "processo": 
      {
        "numeroproc": NumProcesso,
        "anoproc": AnoProcesso,
      },
      "prateleira": EstantePrateleira
    };

    var bodyProcesso = json.encode(dadosProcesso);
    var response     = await http.post(url, headers: cabecalhoToken, body: bodyProcesso);
    var v_statusCode = response.statusCode;
    var JsonDadosRetornoDecode;

    if (v_statusCode == 200) 
    {
      JsonDadosRetornoDecode = json.decode(response.body);
    } 
    else 
    {
      Map<String, String> DadosRetornoErro = 
      {
        "cod_retorno": "4",
        "dsc_mensagem_retorno": "SERVIÇO FORA DO AR, FAVOR CONTACTAR O SUPORTE DO APP",
        "num_prateleira": "",
        "dta_info_prateleira": ""
      };

      var JsonDadosRetornoErro   = json.encode(DadosRetornoErro);
      JsonDadosRetornoDecode = json.decode(JsonDadosRetornoErro.toString());
    }

    return JsonDadosRetornoDecode;
  }
}
