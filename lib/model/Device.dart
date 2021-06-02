class Device {
  String deviceNo;
  String snNo;
  String agentNo;
  String agentName;
  String memNo;
  String memName;
  String memPhone;
  String bindDate;
  String bindTime;
  String untilDate;
  int bindStatus;
  int enableStatus;
  String enableTime;
  String enableDate;
  String highRate;
  String normalRate;
  String lowRate;
  String compreRate;
  String remark;
  int transAmtTotal;
  int enableTargeStatus;
  int createTime;
  int deleteTime;

  Device(
      {this.deviceNo,
      this.snNo,
      this.agentNo,
      this.agentName,
      this.memNo,
      this.memName,
      this.memPhone,
      this.bindDate,
      this.bindTime,
      this.untilDate,
      this.bindStatus,
      this.enableStatus,
      this.enableTime,
      this.enableDate,
      this.highRate,
      this.normalRate,
      this.lowRate,
      this.compreRate,
      this.remark,
      this.transAmtTotal,
      this.enableTargeStatus,
      this.createTime,
      this.deleteTime});

  Device.fromJson(Map<String, dynamic> json) {
    deviceNo = json['deviceNo'];
    snNo = json['snNo'];
    agentNo = json['agentNo'];
    agentName = json['agentName'];

    agentName = json['agentName'];
    memNo = json['memNo'];
    memName = json['memName'];
    memPhone = json['memPhone'];
    bindDate = json['bindDate'];
    bindTime = json['bindTime'];
    untilDate = json['untilDate'];
    bindStatus = json['bindStatus'];
    enableStatus = json['enableStatus'];
    enableTime = json['enableTime'];
    enableDate = json['enableDate'];
    highRate = json['highRate'];
    normalRate = json['normalRate'];
    lowRate = json['lowRate'];
    compreRate = json['compreRate'];
    remark = json['remark'];
    transAmtTotal = json['transAmtTotal'];
    enableTargeStatus = json['enableTargeStatus'];
    createTime = json['createTime'];
    deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceNo'] = this.deviceNo;
    data['snNo'] = this.snNo;
    data['agentNo'] = this.agentNo;
    data['agentName'] = this.agentName;

    data['memNo'] = this.memNo;
    data['memName'] = this.memName;
    data['memPhone'] = this.memPhone;
    data['bindDate'] = this.bindDate;
    data['bindTime'] = this.bindTime;
    data['untilDate'] = this.untilDate;
    data['bindStatus'] = this.bindStatus;
    data['enableStatus'] = this.enableStatus;
    data['enableTime'] = this.enableTime;
    data['enableDate'] = this.enableDate;
    data['highRate'] = this.highRate;
    data['normalRate'] = this.normalRate;
    data['lowRate'] = this.lowRate;
    data['compreRate'] = this.compreRate;
    data['remark'] = this.remark;
    data['transAmtTotal'] = this.transAmtTotal;
    data['enableTargeStatus'] = this.enableTargeStatus;
    data['createTime'] = this.createTime;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
}
