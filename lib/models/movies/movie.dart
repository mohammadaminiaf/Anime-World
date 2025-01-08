class Movie {
  final String title;
  final List<String> genres;
  final double rating;
  final int id;
  final String? englishTitle; // Nullable field
  final String? imageUrl; // Nullable field

  Movie({
    required this.title,
    required this.genres,
    required this.rating,
    required this.id,
    this.englishTitle,
    this.imageUrl,
  });

  // Factory method for creating a Movie instance from a JSON map
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'] as String,
      genres:
          List<String>.from(json['genres'] ?? []), // Ensures genres is a list
      rating: (json['rating'] as num).toDouble(), // Handles integer or double
      id: json['id'] as int,
      englishTitle: json['english_title'] as String?, // Nullable
      imageUrl: json['image_url'] as String?, // Nullable
    );
  }

  // Method for converting a Movie instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'genres': genres,
      'rating': rating,
      'id': id,
      'english_title': englishTitle,
      'image_url': imageUrl,
    };
  }
}
