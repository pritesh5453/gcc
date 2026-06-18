class BannerModel {
  final int? id;
  final String? title;
  final String? image;
  final String? status;
  final int? order;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  BannerModel({
    this.id,
    this.title,
    this.image,
    this.status,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      status: json['status'],
      order: json['order'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}