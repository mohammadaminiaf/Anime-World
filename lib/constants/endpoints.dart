class Endpoints {
  static const baseUrl = 'http://10.10.10.252:8000/';

  //! Add base url for image paths
  static String getImage(String imageUrl) {
    if (imageUrl.contains(baseUrl)) {
      return imageUrl;
    }
    return '$baseUrl$imageUrl';
  }

  //! Remove image url from image paths
  static String getUrl(String imageUrl) {
    if (imageUrl.contains(baseUrl)) {
      return imageUrl.substring(baseUrl.length);
    }
    return imageUrl;
  }

  Endpoints._();
}
