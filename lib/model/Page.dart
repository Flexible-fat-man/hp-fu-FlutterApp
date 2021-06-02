class Page<T> {
   int totalCount;
   int pageCount;
   int pageNum;
   int pageSize;
   int listCount;
   List<T> list;

  Page(int totalCount, int pageNum, int pageSize, List<T> list) {
    this.totalCount = totalCount;
    this.pageNum = pageNum;
    this.pageSize = pageSize;
    this.list = list;
    this.listCount = list.length;
    this.pageCount = (totalCount / pageSize).ceil();
  }

  Page.fromJson(Map<String, dynamic> json) {
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
