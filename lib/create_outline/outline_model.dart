class OutlineModel {
  String outlineId;
  String courseId;
  String outline;

  int order;

  OutlineModel({required this.outlineId,required  this.courseId, required this.outline,required this.order});

  Map<String, dynamic> toMap() {
    return {
      'outlineId': outlineId,
      'courseId': courseId,
      'outline': outline,
      'order': order,
    };
  }

  factory OutlineModel.fromMap(Map<String, dynamic> map, String documentId) {
    return OutlineModel(
      outlineId: documentId,
      courseId: map['courseId'],
      outline: map['outline'],
      order: map['order'],);
  }

}





