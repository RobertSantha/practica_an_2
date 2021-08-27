import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

 String? language;

class Util {
  static String mesaje(BuildContext context, String msg, [String? p1, String? p2]) {
    return S1Localizations.of(context)!.msg(msg, p1, p2);
  }

  static String s1base64(String s) {
    String retval;
    List<int> bytes = utf8.encode(s);

    if (Util.isNotEmpty(s)) {
      retval = base64.encode(bytes);
// print('${retval.substring(retval.length - 2,retval.length - 1)} - ${retval.substring(retval.length - 1,retval.length - 0)}');

      if (retval.substring(retval.length - 2, retval.length - 1) == '=') {
        retval = retval.substring(0, retval.length - 2) + '.' +
            retval.substring(retval.length - 1);
      }
      if (retval.substring(retval.length - 1, retval.length) == '=') {
        retval = retval.substring(0, retval.length - 1) + '.';
      }
    }
    else {
      retval = '';
    }

    return 'VALUE' + retval;
  }

  static bool? isEmpty (var xval) {
    bool? retval;
    if (xval == null) {
      retval = true;
    }
    else {
      String stype = xval.runtimeType.toString().toLowerCase();

      if (stype.compareTo('string') == 0) {
        retval = (xval.trim() == '');
      }
      else if (stype.compareTo('int') == 0) {
        retval = (xval == 0);
      }
      else if (stype.compareTo('double') == 0) {
        retval = (xval == 0);
      }
      else if (stype.compareTo('bool') == 0) {
        retval = (!xval);
      }
      else if (stype.startsWith('list') || stype.startsWith('_growablelist')) {
        retval = (xval.length == 0);
      }
      else if (stype.contains('hashmap')) {
        retval = (xval.length == 0);
      }
    }

    return retval;
  }

  static bool isNotEmpty(var xval) {
    return (!isEmpty(xval)!);
  }
}

class S1Localizations {
  final Map<String, Map<String, String>>? localizedValues;
  S1Localizations(this.locale, this.localizedValues);

  final Locale locale;

  static S1Localizations? of(BuildContext context) {
    return Localizations.of<S1Localizations>(context, S1Localizations);
  }

  String msg(String skey, [String? _p1, String? _p2]) {
    String retval;

    if (localizedValues![language!]!.containsKey(skey)) {
      retval = localizedValues![locale.languageCode]![skey]!;
      if (_p1 != null) retval = retval.replaceAll('{_p1}', _p1);
      if (_p2 != null) retval = retval.replaceAll('{_p2}', _p2);
    }
    else {
      retval = skey;
    }

    return retval;
  }
}


