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
    final rawData = json['data'];
    NotationData? parsedData;
    if (rawData is num) {
      parsedData = NotationData(moyenne: rawData.toDouble());
    } else if (rawData is Map<String, dynamic>) {
      parsedData = NotationData.fromJson(rawData);
    } else {
      parsedData = null;
    }
    return NotationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: parsedData,
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