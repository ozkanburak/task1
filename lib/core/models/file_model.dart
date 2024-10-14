class File {
  final String originalname;
  final String filename;
  final String location;

  File({
    required this.originalname,
    required this.filename,
    required this.location,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    return File(
      originalname: json['originalname'],
      filename: json['filename'],
      location: json['location'],
    );
  }
}

 