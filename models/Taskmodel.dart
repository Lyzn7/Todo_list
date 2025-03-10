import 'dart:convert';


class Taskmodel {
  final String id;
  String tittle;
  bool isCompleted;

  Taskmodel({
    required this.id,
    required this.tittle,
    this.isCompleted = false,
  });

  @override
  String toString() =>
      'Taskmodel(id: $id, tittle: $tittle, isCompleted: $isCompleted)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'tittle': tittle,
      'isCompleted': isCompleted,
    };
  }

  factory Taskmodel.fromMap(Map<String, dynamic> map) {
    return Taskmodel(
      id: map['id'] as String,
      tittle: map['tittle'] as String,
      isCompleted: map['isCompleted'] as bool,
    );
  }
  String toJson() => json.encode(toMap());
  factory Taskmodel.fromJson(String source) =>
      Taskmodel.fromMap(json.decode(source) as Map<String, dynamic>);
}
