class MerchantStatistic {
  int less500000;
  String less500000Text;
  int less1000000;
  String less1000000Text;
  int less3000000;
  String less3000000Text;
  int notLess3000000;
  String notLess3000000Text;
  int notLess0;
  String notLess0Text;

  MerchantStatistic(
      {this.less500000,
        this.less500000Text,
        this.less1000000,
        this.less1000000Text,
        this.less3000000,
        this.less3000000Text,
        this.notLess3000000,
        this.notLess3000000Text,
        this.notLess0,
        this.notLess0Text});

  MerchantStatistic.fromJson(Map<String, dynamic> json) {
    less500000 = json['less500000'];
    less500000Text = json['less500000Text'];
    less1000000 = json['less1000000'];
    less1000000Text = json['less1000000Text'];
    less3000000 = json['less3000000'];
    less3000000Text = json['less3000000Text'];
    notLess3000000 = json['notLess3000000'];
    notLess3000000Text = json['notLess3000000Text'];
    notLess0 = json['notLess0'];
    notLess0Text = json['notLess0Text'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['less500000'] = this.less500000;
    data['less500000Text'] = this.less500000Text;
    data['less1000000'] = this.less1000000;
    data['less1000000Text'] = this.less1000000Text;
    data['less3000000'] = this.less3000000;
    data['less3000000Text'] = this.less3000000Text;
    data['notLess3000000'] = this.notLess3000000;
    data['notLess3000000Text'] = this.notLess3000000Text;
    data['notLess0'] = this.notLess0;
    data['notLess0Text'] = this.notLess0Text;
    return data;
  }
}