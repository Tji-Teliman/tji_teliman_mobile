class NotationResponse {
  final bool success;
  final String message;
  final NotationData? data;

  NotationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory NotationResponse.fromJson(Map<String, dynamic> json) {
    return NotationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null ? NotationData.fromJson(json['data']) : null,
    );
  }
}

class NotationData {
  final double moyenne;

  NotationData({
    required this.moyenne,
  });

  factory NotationData.fromJson(Map<String, dynamic> json) {
    return NotationData(
      moyenne: (json['moyenne'] ?? 0.0).toDouble(),
    );
  }
}