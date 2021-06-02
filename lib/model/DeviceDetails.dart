class DeviceDetails {
  String deviceNo;
  String snNo;
  String agentNo;
  String memNo;
  String memName;
  String memPhone;
  String bindDate;
  String bindTime;
  int bindStatus;
  int enableStatus;
  String enableTime;
  String enableDate;
  String untilDate;
  String highRate;
  String normalRate;
  String lowRate;
  String compreRate;
  String remark;
  int transAmtTotal;
  int enableTargeStatus;
  String monthFirst;
  int monthFirstRewardStatus;
  String monthSecond;
  int monthSecondRewardStatus;
  String monthThird;
  int monthThirdRewardStatus;
  String monthFourth;
  int monthFourthRewardStatus;
  String monthFifth;
  int monthFifthRewardStatus;
  String halfYearStart;
  String halfYearEnd;
  int halfYearRewardStatus;
  String yearStart;
  String yearEnd;
  int yearRewardStatus;
  int createTime;
  int deleteTime;

  DeviceDetails(
      {this.deviceNo,
      this.snNo,
      this.agentNo,
      this.memNo,
      this.memName,
      this.memPhone,
      this.bindDate,
      this.bindTime,
      this.bindStatus,
      this.enableStatus,
      this.enableTime,
      this.enableDate,
      this.untilDate,
      this.highRate,
      this.normalRate,
      this.lowRate,
      this.compreRate,
      this.remark,
      this.transAmtTotal,
      this.enableTargeStatus,
      this.monthFirst,
      this.monthFirstRewardStatus,
      this.monthSecond,
      this.monthSecondRewardStatus,
      this.monthThird,
      this.monthThirdRewardStatus,
      this.monthFourth,
      this.monthFourthRewardStatus,
      this.monthFifth,
      this.monthFifthRewardStatus,
      this.halfYearStart,
      this.halfYearEnd,
      this.halfYearRewardStatus,
      this.yearStart,
      this.yearEnd,
      this.yearRewardStatus,
      this.createTime,
      this.deleteTime});

  DeviceDetails.fromJson(Map<String, dynamic> json) {
    deviceNo = json['deviceNo'];
    snNo = json['snNo'];
    agentNo = json['agentNo'];
    memNo = json['memNo'];
    memName = json['memName'];
    memPhone = json['memPhone'];
    bindDate = json['bindDate'];
    bindTime = json['bindTime'];
    bindStatus = json['bindStatus'];
    enableStatus = json['enableStatus'];
    enableTime = json['enableTime'];
    enableDate = json['enableDate'];
    untilDate = json['untilDate'];
    highRate = json['highRate'];
    normalRate = json['normalRate'];
    lowRate = json['lowRate'];
    compreRate = json['compreRate'];
    remark = json['remark'];
    transAmtTotal = json['transAmtTotal'];
    enableTargeStatus = json['enableTargeStatus'];
    monthFirst = json['monthFirst'];
    monthFirstRewardStatus = json['monthFirstRewardStatus'];
    monthSecond = json['monthSecond'];
    monthSecondRewardStatus = json['monthSecondRewardStatus'];
    monthThird = json['monthThird'];
    monthThirdRewardStatus = json['monthThirdRewardStatus'];
    monthFourth = json['monthFourth'];
    monthFourthRewardStatus = json['monthFourthRewardStatus'];
    monthFifth = json['monthFifth'];
    monthFifthRewardStatus = json['monthFifthRewardStatus'];
    halfYearStart = json['halfYearStart'];
    halfYearEnd = json['halfYearEnd'];
    halfYearRewardStatus = json['halfYearRewardStatus'];
    yearStart = json['yearStart'];
    yearEnd = json['yearEnd'];
    yearRewardStatus = json['yearRewardStatus'];
    createTime = json['createTime'];
    deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceNo'] = this.deviceNo;
    data['snNo'] = this.snNo;
    data['agentNo'] = this.agentNo;
    data['memNo'] = this.memNo;
    data['memName'] = this.memName;
    data['memPhone'] = this.memPhone;
    data['bindDate'] = this.bindDate;
    data['bindTime'] = this.bindTime;
    data['bindStatus'] = this.bindStatus;
    data['enableStatus'] = this.enableStatus;
    data['enableTime'] = this.enableTime;
    data['enableDate'] = this.enableDate;
    data['untilDate'] = this.untilDate;
    data['highRate'] = this.highRate;
    data['normalRate'] = this.normalRate;
    data['lowRate'] = this.lowRate;
    data['compreRate'] = this.compreRate;
    data['remark'] = this.remark;
    data['transAmtTotal'] = this.transAmtTotal;
    data['enableTargeStatus'] = this.enableTargeStatus;
    data['monthFirst'] = this.monthFirst;
    data['monthFirstRewardStatus'] = this.monthFirstRewardStatus;
    data['monthSecond'] = this.monthSecond;
    data['monthSecondRewardStatus'] = this.monthSecondRewardStatus;
    data['monthThird'] = this.monthThird;
    data['monthThirdRewardStatus'] = this.monthThirdRewardStatus;
    data['monthFourth'] = this.monthFourth;
    data['monthFourthRewardStatus'] = this.monthFourthRewardStatus;
    data['monthFifth'] = this.monthFifth;
    data['monthFifthRewardStatus'] = this.monthFifthRewardStatus;
    data['halfYearStart'] = this.halfYearStart;
    data['halfYearEnd'] = this.halfYearEnd;
    data['halfYearRewardStatus'] = this.halfYearRewardStatus;
    data['yearStart'] = this.yearStart;
    data['yearEnd'] = this.yearEnd;
    data['yearRewardStatus'] = this.yearRewardStatus;
    data['createTime'] = this.createTime;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
}
