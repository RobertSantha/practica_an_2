class Product {
  final String COMPANY;
  final String CODE;
  final String NAME_1;
  final String PRICEW;
  final String CODE1;
  final String MTRL;
  final String COUNTRY;
  final String NAME;

  Product({
    required this.COMPANY,
    required this.CODE,
    required this.NAME_1,
    required this.PRICEW,
    required this.CODE1,
    required this.MTRL,
    required this.COUNTRY,
    required this.NAME
  });

  Product.fromJson(Map<String, dynamic> json) :
    this.COMPANY = json['COMPANY'],
    this.NAME_1 = json['NAME_1'],
    this.PRICEW = json['PRICEW'],
    this.CODE1 = json['CODE1'],
    this.CODE = json['CODE'],
    this.MTRL = json['MTRL'],
    this.COUNTRY = json['COUNTRY'],
    this.NAME =json['NAME'];
}