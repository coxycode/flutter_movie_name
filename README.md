# movie_app_day4

A new Flutter project.

## Getting Started

# Movie App

A modern Flutter application for discovering, tracking, and managing your favorite movies. Built with Material Design 3 and follows best practices for state management.

## Features

### Home Screen
- Featured movies carousel with dynamic backgrounds
- Categorized movie sections (Now Playing, Popular, Coming Soon)
- Rating and release date display
- Smooth scrolling experience

### Movie Details
- Full-screen poster view
- Detailed movie information
- Add/Remove from watchlist functionality
- Cast & Crew information
- Related movies suggestions

### Watchlist Management
- Personal watchlist creation
- Favorites collection
- Swipe to remove functionality
- Quick actions for movie management
- Organized tabs for different lists

### Search & Discovery
- Movie search functionality
- Genre-based browsing
- Advanced filtering options
- Real-time search results

## Screenshots

| Home Screen | Movie Details | Watchlist |
|------------|---------------|-----------|
| [Image 1]  | [Image 2]     | [Image 3] |

## Technologies Used

- Flutter 3.x
- Provider for state management
- Video Player & Chewie for video playback
- Shared Preferences for local storage
- Material Design 3

## Dependencies

yaml
dependencies:
flutter:
sdk: flutter
cupertino_icons: ^1.0.8
video_player: ^2.8.2
chewie: ^1.7.5
provider: ^6.1.1
shared_preferences: ^2.2.2


## Project Structure
lib/
├── models/
│ └── movie.dart
├── providers/
│ ├── genre_provider.dart
│ ├── theme_provider.dart
│ └── watchlist_provider.dart
├── screens/
│ ├── home_screen.dart
│ ├── movie_details_screen.dart
│ ├── search_screen.dart
│ ├── watchlist_screen.dart
│ └── media_screen.dart
└── main.dart


## Getting Started

1. Clone the repository:


2. Install dependencies:
flutter pub get

3. Run the app:
flutter run