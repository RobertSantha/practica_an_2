import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import 'constants.dart';
import 'utils.dart';
import 'wsq.dart';
import 'globals.dart';
import 'Item.dart';


class Ws{

  static String? sUrl;
  static BuildContext? context;
  String? message;

  Ws(/*{required this.context}*/);


/* --------------------------------------------------------------------------------------
   * putItem()
   * inscrie un item in BD
   * par -parametru I/O
   * structura {'in': Map<String, dynamic>, 'out': Map<String, dynamic>}
   * Exemplu: {'in': {"filter": {"pret_min": 0.0, "pret_max": 99.0}}, 'out': Map<String, dynamic>}
   * filter poate fi redenumit
   *
   * apel js script
   *  ws.puItem(scripName, ...)
   * apel services
   * ws.puItem('setData', ..., reqMode: 'service')
   * Ex.
   * ws.puItem('setData', {'out': {'filter': {'data': iteDoc.toMap()}}}, reqMode: 'service')
   */

    Future<bool> putItem( String srequest, Map<String, dynamic> par,
    {String reqMode = 'SqlName' ,required Function processResp}) async {
    bool retval;

    try{
      Map<String, dynamic> bodyP = {
        "clientID": Wsq.clientID2,
        "company": G.company,
        "branch": G.branch,
        "appID": G.appid,
        "module": G.module,
        "refID": G.refid,
        "service":G.sqlservice,
        "OBJECT": G.Itedoc
        //"service2":G.backservice,
        //"SqlName": srequest,
      };

      bodyP[reqMode] = srequest;
       par={
        'in': {"filter": {"min":G.min, "max": G.max}},
        'out': {'filter2': {'data': G.itedoc.toMap()}}
      };



      if (par.containsKey("in") && par["in"].containsKey("filter")
          && par.containsKey("out") && par["out"].containsKey("filter2")) {

        // par["in"]["filter"].forEach((key, value) => (Util.isNotEmpty(value) ? bodyP[key] = value : null) );
        par["in"]["filter"].forEach((key, value) => (bodyP[key] = value) );
        par["out"]["filter2"].forEach((key, value) => (bodyP[key] = value) );
      }

     /* if (par.containsKey("in") && par["in"].containsKey("filter")) {

        // par["in"]["filter"].forEach((key, value) => (Util.isNotEmpty(value) ? bodyP[key] = value : null) );
        par["in"]["filter"].forEach((key, value) => (bodyP[key] = value) );

      }else if(par.containsKey("out") && par["out"].containsKey("filter2"))
      {
        par["out"]["filter2"].forEach((key, value) => (bodyP[key] = value) );
      }*/

      var body = JSON.jsonEncode(bodyP);
      http.Response response = await http.post(
          Uri.parse('https://dev-qbs.oncloud.gr/s1services'),
          headers: {"Accept": "application/json"},
          body: body).timeout(Duration(seconds: httptimeoutseconds));

      if (response.statusCode != 200) {
        throw ("Eroare comunicatie. Eroare cod:  " +
            response.statusCode.toString());
      }

      var jsresponse = JSON.jsonDecode(response.body);
      if (!jsresponse["success"]) {
        if (jsresponse.containsKey('error')) {
          throw('Autentificare nereusita: ' + jsresponse["error"]);
        }
        else {
          throw('Autentificare nereusita!');
        }
      }

      processResp(jsresponse);

      retval = true;
    }
    on SocketException {
      message = 'Eroare legatura la internet!';
      retval = false;
    }
    on TimeoutException {
      message = 'Perioada de asteptare expirata!';
      retval = false;
    }
    catch (err) {
      message = err.toString();
      retval = false;
    }
    return retval;
    }
}