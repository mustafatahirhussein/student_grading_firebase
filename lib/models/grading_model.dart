class GradingModel {
  String? id, name, phy, chem, math, url;

  GradingModel({
    required this.id,
    required this.name,
    required this.chem,
    required this.math,
    required this.phy,
    required this.url,
  });

  factory GradingModel.fromJson(Map<dynamic, dynamic> json) {
    return GradingModel(
      id: json['id'],
      name: json['name'],
      phy: json['phy'],
      chem: json['chem'],
      math: json['math'],
      url: json['url'],
    );
  }
}
