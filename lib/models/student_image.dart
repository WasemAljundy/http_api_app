class StudentImage {
  late String image;
  late int studentId;
  late int id;
  late String imageUrl;

  StudentImage.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    studentId = json['student_id'];
    id = json['id'];
    imageUrl = json['image_url'];
  }

}
