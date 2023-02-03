import 'package:arquivo_central/FuncoesGenericas.dart';
import 'package:arquivo_central/globals/styles.dart';
import 'package:arquivo_central/helpers/cameraController.dart';
import 'package:flutter/material.dart';
import 'package:arquivo_central/helpers/ProcessoApi.dart';

class LocalizarProcesso extends StatefulWidget {
  const LocalizarProcesso({Key? key}) : super(key: key);

  @override
  _LocalizarProcessoState createState() => _LocalizarProcessoState();
}

class _LocalizarProcessoState extends State<LocalizarProcesso> {
  final _crtNumero_processo = TextEditingController();
  final _ctrlNumero_ano = TextEditingController();
  final _ctrlLocalizacaoProcesso = TextEditingController();
  final _formkey = GlobalKey<FormState>();
  bool _isLoading = false;
  var res;
  var cameraControlador1 = CameraController();
  var cameraControlador2 = CameraController();

  late FocusNode NProcesso;
  late FocusNode NAno;
  late FocusNode Submit;

  String? _valida_NumeroProcesso(String? texto) {
    if (texto!.isEmpty) {
      return "Digite o número do Processo";
    }

    return null;
  }

  String? _valida_AnoProcesso(String? texto) {
    if (texto!.isEmpty) {
      return "Digite o ano do Processo";
    }

    return null;
  }

  void initState() {
    super.initState();
    NProcesso = FocusNode();
    NAno = FocusNode();
    Submit = FocusNode();
  }

  void _LocalizarProcesso() async {
    bool formOk = _formkey.currentState!.validate();

    if (!formOk) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String RetornoInfoProcesso = "";
    String RetornoInfoEstante = "";
    String NumeroProcesso = _crtNumero_processo.text.trim();
    String AnoProcesso = _ctrlNumero_ano.text.trim();
    dynamic localizarAPI =
        await ProcessoApi.LocalizarProcesso(NumeroProcesso, AnoProcesso);

    if (localizarAPI['tablename'][0]['cod_retorno'] == 1) {
      /*RetornoInfoEstante =
          (localizarAPI['tablename'][0]['num_prateleira'] == null)
              ? "Estante/Prateleira não informada!"
              : "Estante/Prateleira " +
                  localizarAPI['tablename'][0]['num_prateleira'];
                  localizarAPI['tablename'][0]['dsc_dados_processo'];*/

      /*
      {
        "tablename": 
        [
          {
            "cod_retorno": 1,
            "dsc_mensagem_retorno": "PROCESSO RECEBIDO NO ARQUIVO CENTRAL",
            "num_processo": "101",
            "num_ano_processo": "2022",
            "dta_abertura": "03/01/2022",
            "dsc_interessado": "PRACA DE ATENDIMENTO - TRIBUTOS",
            "dsc_assunto": "PARCELAMENTO DE DEBITOS",
            "num_prateleira": "23K",
            "dta_info_prateleira": "2022-05-12T14:51:26",
            "dsc_dados_processo": "101/2022#03/01/2022#PRACA ATENDIMENTO - TRIBUTOS#PARCELAMENTO DE DÉBITOS",
            "num_prateleira_sugest": null
          }
        ]
      }
      
      {
        "RELATORIO": 
        [
          0
          {
            "cod_retorno": 1,
            "dsc_mensagem_retorno": "PROCESSO RECEBIDO NO ARQUIVO CENTRAL",
            "num_prateleira": "23K",
            "dta_info_prateleira": "2022-05-12T14:51:26",
            "dsc_dados_processo": "101/2022#03/01/2022#PRACA ATENDIMENTO - TRIBUTOS#PARCELAMENTO DE DÉBITOS",
            "num_prateleira_sugest": null
          },
          1
          {
            "cod_retorno": 1,
            "dsc_mensagem_retorno": "PROCESSO RECEBIDO NO ARQUIVO CENTRAL",
            "num_prateleira": "23K",
            "dta_info_prateleira": "2022-05-12T14:51:26",
            "dsc_dados_processo": "101/2022#03/01/2022#PRACA ATENDIMENTO - TRIBUTOS#PARCELAMENTO DE DÉBITOS",
            "num_prateleira_sugest": null
          },
          2
          {
            "cod_retorno": 1,
            "dsc_mensagem_retorno": "PROCESSO RECEBIDO NO ARQUIVO CENTRAL",
            "num_prateleira": "23K",
            "dta_info_prateleira": "2022-05-12T14:51:26",
            "dsc_dados_processo": "101/2022#03/01/2022#PRACA ATENDIMENTO - TRIBUTOS#PARCELAMENTO DE DÉBITOS",
            "num_prateleira_sugest": null
          },
          3
          {
            "cod_retorno": 1,
            "dsc_mensagem_retorno": "PROCESSO RECEBIDO NO ARQUIVO CENTRAL",
            "num_prateleira": "23K",
            "dta_info_prateleira": "2022-05-12T14:51:26",
            "dsc_dados_processo": "101/2022#03/01/2022#PRACA ATENDIMENTO - TRIBUTOS#PARCELAMENTO DE DÉBITOS",
            "num_prateleira_sugest": null
          }

        ]
      }
      
      */

      //  PROCESSO  DATA ABERTURA       INTERESSADO                ASSUNTO
      //    0           1                    2                        3
      //"101/2022 # 03/01/2022 # PRACA ATENDIMENTO - TRIBUTOS # PARCELAMENTO DE DÉBITOS"

      List<String> lstDadosDoProcesso = localizarAPI['tablename'][0]
              ['dsc_dados_processo']
          .toString()
          .split("#");

      RetornoInfoEstante = "Processo n°: " + lstDadosDoProcesso[0] + "\n\n";

      RetornoInfoEstante =
          RetornoInfoEstante + "Aberto em: " + lstDadosDoProcesso[1] + "\n\n";

      RetornoInfoEstante =
          RetornoInfoEstante + "Interessado\n" + lstDadosDoProcesso[2] + "\n\n";

      RetornoInfoEstante =
          RetornoInfoEstante + "Assunto\n" + lstDadosDoProcesso[3] + "\n\n";

      RetornoInfoEstante = RetornoInfoEstante +
          "Localizado na estante\n" +
          localizarAPI['tablename'][0]['num_prateleira'];

      _ctrlLocalizacaoProcesso.text = RetornoInfoEstante;

      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ATENÇAO'),
                content: Text(' ${RetornoInfoEstante}'),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
                title: const Text('ATENÇAO'),
                content:
                    const Text('Processo Não se Encontra no Arquivo Central '),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ));
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _ScanearProcessoAno() async {
    await cameraControlador1.escanearCodigoBarras();
    int ProcessoAno = int.parse(cameraControlador1.valorCodigoBarras);
    String NumProcesso =
        ProcessoAno.toString().substring(0, ProcessoAno.toString().length - 4);
    String AnoProcesso = ProcessoAno.toString().lastChars(4);
    _crtNumero_processo.text = NumProcesso;
    _ctrlNumero_ano.text = AnoProcesso;
    _LocalizarProcesso();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbranco,
      appBar: AppBar(
        title: Text('Consulta de Processos'),
        backgroundColor: kazulEscuro,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                //NUMERO DO PROCESSO

                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    autofocus: true,
                    focusNode: NProcesso,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Digite o Numero do Processo',
                      suffixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                        child: IconButton(
                          icon: const Icon(Icons.qr_code_2),
                          onPressed: () async {
                            _ScanearProcessoAno();
                          },
                        ),
                      ),
                    ),
                    controller: _crtNumero_processo,
                    validator: _valida_NumeroProcesso,
                  ),
                ),

                //ANO DO PROCESSO

                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15.0, top: 15, bottom: 0),
                  child: TextFormField(
                    autofocus: true,
                    focusNode: NAno,
                    keyboardType: TextInputType.number,
                    obscureText: false,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Digite o Ano do Processo',
                      suffixIcon: Align(
                        widthFactor: 1.0,
                        heightFactor: 1.0,
                      ),
                    ),
                    controller: _ctrlNumero_ano,
                    validator: _valida_AnoProcesso,
                  ),
                ),

                //LOCALIZAÇÃO DO PROCESSO

                //BOTÃO LOCALIZAR

                Container(
                    margin: EdgeInsets.fromLTRB(0, 30, 0, 0),
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: kazulEscuro,
                        borderRadius: BorderRadius.circular(20)),
                    child: ElevatedButton.icon(
                      icon: _isLoading
                          ? CircularProgressIndicator()
                          : Icon(Icons.search),
                      label: Text(
                        _isLoading ? 'Localizando...' : 'Localizar',
                        style: TextStyle(color: kbranco, fontSize: 20),
                      ),
                      onPressed: () async {
                        _LocalizarProcesso();
                      },
                      style: ElevatedButton.styleFrom(
                          primary: kverde, fixedSize: Size(250, 50)),
                    )),
              ],
            )),
      ),
    );
  }
}
