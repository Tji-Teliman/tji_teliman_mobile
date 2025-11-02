class MissionAccomplieResponse {
  final bool success;
  final String message;
  final MissionAccomplieData data;

  MissionAccomplieResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory MissionAccomplieResponse.fromJson(Map<String, dynamic> json) {
    return MissionAccomplieResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: MissionAccomplieData.fromJson(json['data'] ?? {}),
    );
  }
}

class MissionAccomplieData {
  final List<dynamic> missions;
  final int nombreMissions;

  MissionAccomplieData({
    required this.missions,
    required this.nombreMissions,
  });

  factory MissionAccomplieData.fromJson(Map<String, dynamic> json) {
    return MissionAccomplieData(
      missions: json['missions'] ?? [],
      nombreMissions: json['nombreMissions'] ?? 0,
    );
  }
}