class StatisticByDate {
  int countTransAmt;
  int sumTransAmt;

  StatisticByDate({this.countTransAmt, this.sumTransAmt});

  StatisticByDate.fromJson(Map<String, dynamic> json) {
    countTransAmt = json['countTransAmt'];
    sumTransAmt = json['sumTransAmt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['countTransAmt'] = this.countTransAmt;
    data['sumTransAmt'] = this.sumTransAmt;
    return data;
  }
}