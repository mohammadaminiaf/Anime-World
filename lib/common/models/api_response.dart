class ApiResponse {
  final dynamic data;
  final String? accessToken;
  final String? tokenType;
  final String? message;
  final int? statusCode;

  ApiResponse({
    required this.data,
    this.accessToken,
    this.tokenType,
    this.message,
    this.statusCode,
  });

  factory ApiResponse.fromJson(dynamic json) {
    return ApiResponse(
      data: json['data'],
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      message: json['message'],
      statusCode: json['status_code'],
    );
  }
}
