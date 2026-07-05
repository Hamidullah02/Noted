class note {
  String id;
  String title;
  String description;

  note({required this.id, required this.title, required this.description});

  factory note.fromFirestore(Map<String, dynamic> json, String docID) {
    return note(
      id: docID,
      title: json['title'],
      description: json['description'],
    );
  }
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
    };
    }
}
