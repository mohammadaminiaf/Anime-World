class Pagination {
  int currentPage;
  int lastPage;
  int pageSize;
  int totalCount;
  int totalPages;

  Pagination({
    this.currentPage = 1,
    this.lastPage = 0,
    this.pageSize = 12,
    this.totalCount = 0,
    this.totalPages = 0,
  });

  Pagination copyWith({
    int? page,
    int? pageSize,
    int? totalCount,
    int? totalPages,
  }) {
    return Pagination(
      currentPage: page ?? currentPage,
      pageSize: pageSize ?? this.pageSize,
      totalCount: totalCount ?? this.totalCount,
      totalPages: totalPages ?? this.totalPages,
    );
  }
}
