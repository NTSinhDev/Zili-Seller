abstract class NWResponse {
  NWResponse(
    this.statusCode,
  );

  final int statusCode;
}

class NWResponseSuccess<T> extends NWResponse {
  NWResponseSuccess(super.statusCode, this.data);

  final T data;
}

class NWResponseFailed extends NWResponse implements Exception {
  NWResponseFailed(super.statusCode, this.errorMessage, this.errorType);

  factory NWResponseFailed.formJson({
    required int statusCode,
    required Map<String, dynamic> json,
  }) {
    return NWResponseFailed(
      statusCode,
      json['message'] != null ? json['message'] as String : null,
      json['type'] != null ? json['type'] as String : null,
    );
  }

  factory NWResponseFailed.decodeError({
    required int statusCode,
    required String message,
  }) {
    return NWResponseFailed(
      statusCode,
      message,
      'DECODE_ERROR',
    );
  }

  factory NWResponseFailed.invalidRequestError({
    required int statusCode,
    String message = 'Invalid request',
  }) {
    return NWResponseFailed(
      statusCode,
      message,
      'INVALID_REQUEST_ERROR',
    );
  }

  final String? errorMessage;
  final String? errorType;
}
