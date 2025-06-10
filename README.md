# Movie Ticket Booking System

A comprehensive full-stack application for booking movie tickets featuring a Flutter mobile app, Spring Boot backend, and Angular admin panel. This system provides an intuitive interface for users to browse movies, book tickets, and manage their bookings, while offering administrators powerful tools to manage content through a web-based admin panel.

## Features

- User Authentication (Email & Firebase)
- Movie Browsing and Search
- Seat Selection and Booking
- Multiple Payment Methods Integration
- Ticket Management
- Admin Panel for Content Management

## Project Structure

```
├── backend/                      # Spring Boot Backend
│   └── bookingmovieticketapp/
│       ├── src/                 # Source code
│       │   ├── main/           # Main application code
│       │   │   ├── java/       # Java source files
│       │   │   └── resources/  # Configuration files
│       │   └── test/           # Test files
│       ├── images/             # Uploaded media storage
│       │   ├── cinemas/        # Cinema images
│       │   └── users/          # User profile images
│       └── pom.xml             # Maven configuration
├── frontendapp/                 # Flutter Mobile App
│   ├── lib/                    # Application source code
│   │   ├── dtos/              # Data Transfer Objects
│   │   ├── models/            # Data models
│   │   ├── screens/           # UI screens
│   │   └── services/          # Business logic and API services
│   ├── assets/                # Static assets
│   │   └── images/           # App images and icons
│   └── android/               # Android-specific configuration
└── webadmin/                   # Angular Admin Panel
    ├── src/                    # Source code
    │   ├── app/               # Application components
    │   └── assets/            # Static resources
    └── public/                # Public assets
```

## Technology Stack

### Mobile App (Flutter)

- Flutter SDK 3.7.0+
- Key Dependencies:
  - provider: ^6.0.5 (State management)
  - http: ^0.13.6 (API calls)
  - firebase_auth: ^4.20.0 (Authentication)
  - firebase_core: ^2.32.0 (Firebase integration)
  - shared_preferences: ^2.3.2 (Local storage)
  - cached_network_image: ^3.3.1 (Image caching)
  - image_picker: ^0.8.7+4 (Image selection)
  - permission_handler: ^11.2.0 (Permission management)
  - webview_flutter: ^4.8.0 (Web content display)
  - url_launcher: ^6.1.11 (URL handling)
  - shimmer: ^3.0.0 (Loading effects)
  - flutter_cache_manager: ^3.3.1 (Cache management)
  - email_validator: ^3.0.0 (Form validation)
  - crypto: ^3.0.3 (Cryptography functions)

### Backend (Spring Boot)

- Java 17
- Spring Boot 3.4.4
- Dependencies:
  - Spring Data JPA
  - Spring Web
  - Spring Validation
  - MySQL Connector
  - Lombok

### Admin Panel (Angular)

- Angular 19.1.0
- Express.js
- RxJS
- TypeScript

## Setup Instructions

## Development Setup

### Prerequisites

- Java JDK 17 or later
- Flutter SDK 3.7.0 or later
- Node.js 18+ and npm
- MySQL 8.0+
- Android Studio / VS Code with Flutter extensions
- Git

### Database Setup

1. Install MySQL and create a new database:
```sql
CREATE DATABASE movieticket;
```

2. Import the schema:
```bash
mysql -u your_username -p movieticket < database.sql
```

### Backend Setup

1. Navigate to backend directory:
```bash
cd backend/bookingmovieticketapp
```

2. Configure database connection in `src/main/resources/application.properties`

3. Build and run the project:
```bash
./mvnw clean install
./mvnw spring-boot:run
```

The backend server will start at `http://localhost:8080`

### Mobile App Setup

1. Navigate to frontend directory:
```bash
cd frontendapp
```

2. Update the API endpoint in `lib/app_config.dart`

3. Install dependencies and run:
```bash
flutter pub get
flutter run
```

### Admin Panel Setup

1. Navigate to admin panel directory:
```bash
cd webadmin
```

2. Install dependencies and start the development server:
```bash
npm install
npm start
```

The admin panel will be available at `http://localhost:4200`

## Code Conventions

### Backend (Java)

- Follow standard Java naming conventions
- Use meaningful class and method names
- Implement interfaces for service layers
- Use DTOs for data transfer
- Write unit tests for business logic
- Document public APIs using Javadoc

### Frontend (Flutter)

- Follow Dart style guide
- Use camelCase for variables and methods
- Use PascalCase for classes and types
- Keep widget methods small and focused
- Implement proper state management using Provider
- Use constants for colors and text styles
- Organize imports in three sections:
  1. Dart/Flutter SDK imports
  2. Package imports
  3. Local imports

### Admin Panel (Angular)

- Follow Angular style guide
- Use TypeScript features appropriately
- Implement lazy loading for modules
- Use proper component lifecycle hooks
- Follow LIFT principle:
  - Locatable
  - Identify
  - Flat
  - Try to be DRY

## API Documentation

The API documentation is available at `http://localhost:8080/swagger-ui.html` when running the backend server.
cd webadmin
```

2. Install dependencies:

```bash
npm install
```

3. Start the development server:

```bash
npm start
```

Or

```bash
ng serve
```

## Code Conventions

### Flutter/Dart

- Use camelCase for variables and methods
- Use PascalCase for class names and enums
- Organize imports in sections: dart, flutter, third-party, project
- Keep widget methods small and focused
- Use const constructors when possible
- Follow Flutter's official style guide

### Spring Boot

- Use standard Java naming conventions
- Package structure:
  - controllers: REST endpoints
  - services: Business logic
  - repositories: Data access
  - models: Entity classes
  - dtos: Data Transfer Objects
- Use proper annotations (@RestController, @Service, etc.)
- Implement proper exception handling
- Document APIs with comments

### Angular

- Follow Angular style guide
- Use kebab-case for file names
- Use camelCase for methods and properties
- Use PascalCase for class names
- Organize imports by type
- Implement lazy loading for modules
- Use TypeScript types/interfaces

## Available Commands

### Mobile App

```bash
flutter test          # Run tests
flutter build apk    # Build Android APK
flutter build ios    # Build iOS app
flutter clean       # Clean build files
```

### Backend

```bash
./mvnw test         # Run tests
./mvnw package      # Create JAR
./mvnw clean        # Clean build files
```

### Admin Panel

```bash
npm run start     # Start development server
npm run build     # Build production version
npm run test      # Run unit tests
```