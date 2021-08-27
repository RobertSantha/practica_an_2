import 'globals.dart';

class IteDoc {
  final IteDocA iteDocA;
  final List<Item> items;

  IteDoc(this.iteDocA, this.items);

  Map<String, dynamic> toMap() {
    var retval = Map<String, dynamic>();

    retval['ITEDOC'] = this.iteDocA.toMap();
    retval['ITELINES'] = this.items.map((e) => e.toMap()).toList();

    return retval;
  }
}

class IteDocA {
  final int series;
  final DateTime trndata ;
  final String comments;


  IteDocA(this.series, this.trndata, this.comments);

  Map<String, dynamic> toMap() {
    var retval = Map<String, dynamic>();

    retval['SERIES'] = this.series;
    retval['TRNDATA'] = this.trndata.toIso8601String();
    retval['COMMENTS'] = this.comments;

    return retval;
  }

}

class Item{

  final String mtrl;
  final int QTY1;


  Item({
    required this.mtrl,
    required this.QTY1
  });

  Item.fromMap( Map<String, dynamic> map):

        this.mtrl=map['MTRL'],
        this.QTY1=map['QTY1'];

  Map<String, dynamic> toMap() {
    var retval = Map<String, dynamic>();

    retval['MTRL'] = this.mtrl;
    retval['QTY1'] = this.QTY1;

    return retval;
  }
}

