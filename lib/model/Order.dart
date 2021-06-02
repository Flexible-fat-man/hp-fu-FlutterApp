class Order<T> {
  int totalCount;
  int pageCount;
  int pageNum;
  int pageSize;
  int listCount;
  List<T> list;

  Order(int totalCount, int pageNum, int pageSize, List<T> list) {
    this.totalCount = totalCount;
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.list = list;
    this.listCount = list.length;
    this.pageCount = (totalCount / pageSize).ceil();
  }

  Order.fromJson(Map<String, dynamic> json) {
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


class OrderDetail {
   String orderNo;
   int orderType;

   String agentNo;
   String agentName;
   String deviceNo;
   String deviceRate;

   String memNo;
   String memName;

   int payStatus;
   String payDate;
   int payTime;

   String apiOrderNo;
   String cardClass;
   String cardNo;
   String posEntry;
   String transType;
   String transTypeText;
   String transTypeFlag;
   int cancelStatus;
   int shareMoneyStatus;
   String orderRemark;
   String transDate;
   String transTime;

   int transAmt;
   String fee;

   int createTime;
   int deleteTime;

   OrderDetail(
      {
        this.deviceRate,
        this.agentName,
        this.transAmt,
       this.fee,
        this.transDate,
        this.transTime,
       this.orderNo,
       this.orderType,
       this.agentNo,
       this.deviceNo,
       this.memNo,
       this.memName,
       this.payStatus,
       this.payDate,
       this.payTime,
       this.apiOrderNo,
       this.cardClass,
       this.cardNo,
       this.posEntry,
       this.transType,
       this.transTypeText,
       this.transTypeFlag,
       this.cancelStatus,
       this.shareMoneyStatus,
       this.orderRemark,
       this.createTime,
       this.deleteTime});

   OrderDetail.fromJson(Map<String, dynamic> json) {
     this.deviceRate = json['deviceRate'];
     this.agentName = json['agentName'];
     this.transAmt = json['transAmt'];
     this.fee = json['fee'];
     this.transDate = json['transDate'];
     this.transTime = json['transTime'];
     this.orderNo = json['orderNo'];
    this.orderNo = json['orderNo'];
    this.orderType = json['orderType'];
    this.agentNo = json['agentNo'];
    this.deviceNo = json['deviceNo'];
    this.memNo = json['memNo'];
    this.memName = json['memName'];
    this.payStatus = json['payStatus'];
    this.payDate = json['payDate'];
    this.payTime = json['payTime'];
    this.apiOrderNo = json['apiOrderNo'];
    this.cardClass = json['cardClass'];
    this.cardNo = json['cardNo'];
    this.posEntry = json['posEntry'];
    this.transType = json['transType'];
    this.transTypeText = json['transTypeText'];
    this.transTypeFlag = json['transTypeFlag'];
    this.cancelStatus = json['cancelStatus'];
    this.shareMoneyStatus = json['shareMoneyStatus'];
    this.orderRemark = json['orderRemark'];
    this.createTime = json['createTime'];
    this.deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deviceRate'] = this.deviceRate;
    data['agentName'] = this.agentName;
    data['transAmt'] = this.transAmt;
    data['fee'] = this.fee;
    data['transDate'] = this.transDate;
    data['transTime'] = this.transTime;
    data['orderNo'] = this.orderNo;
    data['orderType'] = this.orderType;
    data['agentNo'] = this.agentNo;
    data['deviceNo'] = deviceNo;
    data['memNo'] = this.memNo;
    data['memName'] = this.memName;
    data['payStatus'] = this.payStatus;
    data['payDate'] = this.payDate;
    data['payTime'] = this.payTime;
    data['apiOrderNo'] = this.apiOrderNo;
    data['cardClass'] = this.cardClass;
    data['cardNo'] = this.cardNo;
    data['posEntry'] = this.posEntry;
    data['transType'] = this.transType;
    data['transTypeText'] = this.transTypeText;
    data['transTypeFlag'] = this.transTypeFlag;
    data['cancelStatus'] = this.cancelStatus;
    data['shareMoneyStatus'] = this.shareMoneyStatus;
    data['orderRemark'] = this.orderRemark;
    data['createTime'] = this.createTime;
    data['deleteTime'] = this.deleteTime;

    return data;
  }
}
