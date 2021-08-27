import 'dart:io';
import 'dart:async';
import 'dart:convert' as JSON;
import 'package:http/http.dart' as http;
import 'constants.dart' as cc;

import 'globals.dart';

class Wsq {
  static final String sUrl1 = 'https://dev-qbs.oncloud.gr/s1services';
  static var appId;
  static var clientID2;
  static String? message;


  /* ---------------------------------------------------------------------------
   * autentifcateQBS()
   * Autentification on ws Soft1
   */
   static Future<bool> autentificate() async {
    bool retval;

    try {
      // autentificare: PAS 1
      // =====================
      var body = JSON.jsonEncode({
        "service": G.logservice,
        "username": G.user,
        "password": G.password,
        "appId": G.appid});

      http.Response response = await http.post(
          Uri.parse(sUrl1),
          headers: {"Accept": "application/json"},
          body: body
      ).timeout(Duration(seconds: cc.httptimeoutseconds));

      if (response.statusCode != 200) {
        throw("Eroare comunicatie. Eroare cod:  " +
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

      appId = jsresponse["appid"];

      // autentificare: PAS 2
      // =====================
      body = JSON.jsonEncode({"service": G.authsservice,
        "clientID": jsresponse['clientID'],
        "COMPANY": G.company,
        "BRANCH": G.branch,
        "MODULE": G.module,
        "REFID": G.refid});

      response = await http.post(
          Uri.parse(sUrl1),
          headers: {"Accept": "application/json"},
          body: body
      ).timeout(Duration(seconds: cc.httptimeoutseconds));

      if (response.statusCode != 200) {
        throw("Eroare comunicatie. Eroare cod:  " +
            response.statusCode.toString());
      }

      jsresponse = JSON.jsonDecode(response.body);
      if (!jsresponse["success"]) {
        if (jsresponse.containsKey('error')) {
          throw('Autentificare nereusita: ' + jsresponse["error"]);
        }
        else {
          throw('Autentificare nereusita!');
        }
      }
      clientID2 = jsresponse["clientID"];

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