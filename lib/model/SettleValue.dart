class SettleValue {
  String agentRateNo;
  String agentNo;
  int type;
  String rate;

  SettleValue({this.agentRateNo, this.agentNo, this.type, this.rate});

  SettleValue.fromJson(Map<String, dynamic> json) {
    agentRateNo = json['agentRateNo'];
    agentNo = json['agentNo'];
    type = json['type'];
    rate = json['rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentRateNo'] = this.agentRateNo;
    data['agentNo'] = this.agentNo;
    data['type'] = this.type;
    data['rate'] = this.rate;
    return data;
  }
}