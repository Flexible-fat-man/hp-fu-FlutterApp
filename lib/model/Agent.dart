class Agent {
  String agentNo;
  String agentMobile;
  String agentName;
  String password;
  String luckNumber;
  int lft;
  int rgt;
  int depth;
  String settleCardNo;
  String settleName;
  String settleMobile;
  String settleIdCard;
  int totalMoney;
  int canWithdrawalMoney;
  int applyWithdrawalMoney;
  int haveWithdrawalMoney;
  int fxTotalMoney;
  int fxCanWithdrawalMoney;
  int fxApplyWithdrawalMoney;
  int fxHaveWithdrawalMoney;
  int orgTotalMoney;
  int orgCanWithdrawalMoney;
  int orgApplyWithdrawalMoney;
  int orgHaveWithdrawalMoney;
  int createTime;
  int deleteTime;

  Agent(
      {this.agentNo,
      this.agentMobile,
      this.agentName,
      this.password,
      this.luckNumber,
      this.lft,
      this.rgt,
      this.depth,
      this.settleCardNo,
      this.settleName,
      this.settleMobile,
      this.settleIdCard,
      this.totalMoney,
      this.canWithdrawalMoney,
      this.applyWithdrawalMoney,
      this.haveWithdrawalMoney,
      this.fxTotalMoney,
      this.fxCanWithdrawalMoney,
      this.fxApplyWithdrawalMoney,
      this.fxHaveWithdrawalMoney,
      this.orgTotalMoney,
      this.orgCanWithdrawalMoney,
      this.orgApplyWithdrawalMoney,
      this.orgHaveWithdrawalMoney,
      this.createTime,
      this.deleteTime});
  Agent.fromJson(Map<String, dynamic> json) {
    agentNo = json['agentNo'];
    agentMobile = json['agentMobile'];
    agentName = json['agentName'];
    password = json['password'];
    luckNumber = json['luckNumber'];
    lft = json['lft'];
    rgt = json['rgt'];
    depth = json['depth'];
    settleCardNo = json['settleCardNo'];
    settleName = json['settleName'];
    settleMobile = json['settleMobile'];
    settleIdCard = json['settleIdCard'];
    totalMoney = json['totalMoney'];
    canWithdrawalMoney = json['canWithdrawalMoney'];
    applyWithdrawalMoney = json['applyWithdrawalMoney'];
    haveWithdrawalMoney = json['haveWithdrawalMoney'];
    fxTotalMoney = json['fxTotalMoney'];
    fxCanWithdrawalMoney = json['fxCanWithdrawalMoney'];
    fxApplyWithdrawalMoney = json['fxApplyWithdrawalMoney'];
    fxHaveWithdrawalMoney = json['fxHaveWithdrawalMoney'];
    orgTotalMoney = json['orgTotalMoney'];
    orgCanWithdrawalMoney = json['orgCanWithdrawalMoney'];
    orgApplyWithdrawalMoney = json['orgApplyWithdrawalMoney'];
    orgHaveWithdrawalMoney = json['orgHaveWithdrawalMoney'];
    createTime = json['createTime'];
    deleteTime = json['deleteTime'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentNo'] = this.agentNo;
    data['agentMobile'] = this.agentMobile;
    data['agentName'] = this.agentName;
    data['password'] = this.password;
    data['luckNumber'] = this.luckNumber;
    data['lft'] = this.lft;
    data['rgt'] = this.rgt;
    data['depth'] = this.depth;
    data['settleCardNo'] = this.settleCardNo;
    data['settleName'] = this.settleName;
    data['settleMobile'] = this.settleMobile;
    data['settleIdCard'] = this.settleIdCard;
    data['totalMoney'] = this.totalMoney;
    data['canWithdrawalMoney'] = this.canWithdrawalMoney;
    data['applyWithdrawalMoney'] = this.applyWithdrawalMoney;
    data['haveWithdrawalMoney'] = this.haveWithdrawalMoney;
    data['fxTotalMoney'] = this.fxTotalMoney;
    data['fxCanWithdrawalMoney'] = this.fxCanWithdrawalMoney;
    data['fxApplyWithdrawalMoney'] = this.fxApplyWithdrawalMoney;
    data['fxHaveWithdrawalMoney'] = this.fxHaveWithdrawalMoney;
    data['orgTotalMoney'] = this.orgTotalMoney;
    data['orgCanWithdrawalMoney'] = this.orgCanWithdrawalMoney;
    data['orgApplyWithdrawalMoney'] = this.orgApplyWithdrawalMoney;
    data['orgHaveWithdrawalMoney'] = this.orgHaveWithdrawalMoney;
    data['createTime'] = this.createTime;
    data['deleteTime'] = this.deleteTime;
    return data;
  }
}
