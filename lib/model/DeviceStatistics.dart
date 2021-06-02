class DeviceStatistics {
  String agentNo;
  String agentName;
  int unEnableAndUnBind;
  String unEnableAndUnBindText;
  int unEnableAndBind;
  String unEnableAndBindText;
  int enableAndUnBind;
  String enableAndUnBindText;
  int enableAndBind;
  String enableAndBindText;
  int all;
  String allText;

  DeviceStatistics(
      {this.agentNo,
      this.agentName,
      this.unEnableAndUnBind,
      this.unEnableAndUnBindText,
      this.unEnableAndBind,
      this.unEnableAndBindText,
      this.enableAndUnBind,
      this.enableAndUnBindText,
      this.enableAndBind,
      this.enableAndBindText,
      this.all,
      this.allText});

  DeviceStatistics.fromJson(Map<String, dynamic> json) {
    agentNo = json['agentNo'];
    agentName = json['agentName'];

    unEnableAndUnBind = json['unEnableAndUnBind'];
    unEnableAndUnBindText = json['unEnableAndUnBindText'];
    unEnableAndBind = json['unEnableAndBind'];
    unEnableAndBindText = json['unEnableAndBindText'];
    enableAndUnBind = json['enableAndUnBind'];
    enableAndUnBindText = json['enableAndUnBindText'];
    enableAndBind = json['enableAndBind'];
    enableAndBindText = json['enableAndBindText'];
    all = json['all'];
    allText = json['allText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data['agentNo'] = this.agentNo;
    data['agentName'] = this.agentName;

    data['unEnableAndUnBind'] = this.unEnableAndUnBind;
    data['unEnableAndUnBindText'] = this.unEnableAndUnBindText;
    data['unEnableAndBind'] = this.unEnableAndBind;
    data['unEnableAndBindText'] = this.unEnableAndBindText;
    data['enableAndUnBind'] = this.enableAndUnBind;
    data['enableAndUnBindText'] = this.enableAndUnBindText;
    data['enableAndBind'] = this.enableAndBind;
    data['enableAndBindText'] = this.enableAndBindText;
    data['all'] = this.all;
    data['allText'] = this.allText;
    return data;
  }
}
