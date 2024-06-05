abstract class BaseModel {
  String? id;
  int? priority;

  void setId(String newId) {
    id = newId;
  }

  void setPriority(int newPriority) {
    priority = newPriority;
  }

  Map<String, dynamic> toFirestore();
}
