class GradingModel {
  String? id, name, phy, chem, math;

  GradingModel(
      {required this.id,
      required this.name,
      required this.chem,
      required this.math,
      required this.phy});

  factory GradingModel.fromJson(Map<dynamic, dynamic> json) {
    return GradingModel(
      id: json['id'],
      name: json['name'],
      phy: json['phy'],
      chem: json['chem'],
      math: json['math'],
    );
  }
}
