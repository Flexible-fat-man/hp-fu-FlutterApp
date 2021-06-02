class ProfitModel<T> {
  int totalCount;
  int pageCount;
  int pageNum;
  int pageSize;
  int listCount;
  List<T> list;

  ProfitModel(int totalCount, int pageNum, int pageSize, List<T> list) {
    this.totalCount = totalCount;
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.list = list;
    this.listCount = list.length;
    this.pageCount = (totalCount / pageSize).ceil();
  }

  ProfitModel.fromJson(Map<String, dynamic> json) {
    this.totalCount = json['totalCount'];
    this.pageCount = json['pageCount'];
    this.pageNum = json['pageNum'];
    this.pageSize = json['pageSize'];
    this.listCount = json['listCount'];
    this.list = json['list'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['pageCount'] = this.pageCount;
    data['pageNum'] = this.pageNum;
    data['pageSize'] = this.pageSize;
    data['listCount'] = this.listCount;
    data['list'] = this.list;
    return data;
  }
}


class ProfitDetailModel {
  String agentNo;
  int money;
  int moneyType;
  int settleAccountType;
  int settleStatus;
  int relationType;
  String relationNo;
  String remark;
  int createTime;
  int deleteTime;

  ProfitDetailModel(
      {
        this.agentNo,
        this.money,
        this.moneyType,
        this.settleAccountType,
        this.settleStatus,
        this.relationType,
        this.relationNo,
        this.remark,
        this.createTime,
        this.deleteTime});

  ProfitDetailModel.fromJson(Map<String, dynamic> json) {
    this.agentNo = json['agentNo'];
    this.money = json['money'];
    this.moneyType = json['moneyType'];
    this.settleAccountType = json['settleAccountType'];
    this.settleStatus = json['settleStatus'];
    this.relationType = json['relationType'];
    this.relationNo = json['relationNo'];
    this.remark = json['remark'];
    this.createTime = json['createTime'];
    this.deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentNo'] = this.agentNo;
    data['money'] = this.money;
    data['moneyType'] = this.moneyType;
    data['settleAccountType'] = this.settleAccountType;
    data['settleStatus'] = this.settleStatus;
    data['relationType'] = this.relationType;
    data['relationNo'] = this.relationNo;
    data['remark'] = this.remark;
    data['createTime'] = createTime;
    data['deleteTime'] = this.deleteTime;

    return data;
  }
}