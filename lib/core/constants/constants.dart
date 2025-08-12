String kTemplate = 'template';

String kName = 'name';
String kId = 'id';
String kSprites = 'sprites';
String kTypes = 'types';
String kType = 'type';
String kOther = 'other';
String kOfficialArtwork = 'official-artwork';
String kFrontDefault = 'front_default';
String kFrontShiny = 'front_shiny';

class Ac {
  // static const String baseUrl = "https://car-dealer-server-5n0u.onrender.com";

  // Use your machine's IP address instead of localhost for mobile development
  // You can find your IP address by running 'ifconfig' on macOS/Linux or 'ipconfig' on Windows
  // static const String baseUrl = "http://10.0.2.2:3000"; // For Android emulator
  // static const String baseUrl = "http://localhost:6003"; // For iOS simulator
  static const String baseUrl =
      "http://192.168.1.5:6003"; // For physical devices
  static const String imageUrl = "$baseUrl/uploads/";

  static const String googleApiKey = 'AIzaSyD8MdqC-fi8QQts0Q2nytSniXFtQ6Cn-Og';
}
