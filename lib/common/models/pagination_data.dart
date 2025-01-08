class PaginationData<T> {
  final int? currentPage;
  final int? lastPage;
  final int? total;
  final int? perPage;
  final List<T> data;
  final T Function(Map<String, dynamic> json) fromJson;

  PaginationData({
    this.currentPage,
    this.lastPage,
    this.total,
    this.perPage,
    required this.data,
    required this.fromJson,
  });

  factory PaginationData.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginationData<T>(
      currentPage: json['page_num'],
      lastPage: json['last_page'],
      total: json['total_count'],
      perPage: json['page_size'],
      data: (json['data'] as List).map((item) => fromJsonT(item)).toList(),
      fromJson: fromJsonT,
    );
  }

  PaginationData copyWith({
    final int? currentPage,
    final int? lastPage,
    final int? total,
    final List<T>? data,
    final T Function(Map<String, dynamic> json)? fromJson,
  }) {
    return PaginationData(
      total: total ?? this.total,
      lastPage: lastPage ?? this.lastPage,
      currentPage: currentPage ?? this.currentPage,
      data: data ?? this.data,
      fromJson: fromJson ?? this.fromJson,
    );
  }
}
