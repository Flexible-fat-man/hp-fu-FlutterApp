class MessageModel<T> {
  int totalCount;
  int pageCount;
  int pageNum;
  int pageSize;
  int listCount;
  List<T> list;

  MessageModel(int totalCount, int pageNum, int pageSize, List<T> list) {
    this.totalCount = totalCount;
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.list = list;
    this.listCount = list.length;
    this.pageCount = (totalCount / pageSize).ceil();
  }

  MessageModel.fromJson(Map<String, dynamic> json) {
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


class MessageDetailModel {
  String agentMessageNo;
  String agentNo;
  String title;
  String content;
  int messageType;
  int readStatus; //1未读 2已读
  int createTime;
  int deleteTime;

  MessageDetailModel(
      {
        this.agentMessageNo,
        this.agentNo,
        this.title,
        this.content,
        this.messageType,
        this.readStatus,
        this.createTime,
        this.deleteTime});

  MessageDetailModel.fromJson(Map<String, dynamic> json) {
    this.agentMessageNo = json['agentMessageNo'];
    this.agentNo = json['agentNo'];
    this.title = json['title'];
    this.content = json['content'];
    this.messageType = json['messageType'];
    this.readStatus = json['readStatus'];
    this.createTime = json['createTime'];
    this.deleteTime = json['deleteTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['agentMessageNo'] = this.agentMessageNo;
    data['agentNo'] = this.agentNo;
    data['title'] = this.title;
    data['content'] = this.content;
    data['messageType'] = this.messageType;
    data['readStatus'] = this.readStatus;
    data['createTime'] = createTime;
    data['deleteTime'] = this.deleteTime;

    return data;
  }
}