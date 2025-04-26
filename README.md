# Movie Ticket Booking System

A full-stack application for booking movie tickets featuring a Flutter mobile app, Spring Boot backend, and Angular admin panel.

## Project Structure

```
├── backend/                      # Spring Boot Backend
│   └── bookingmovieticketapp/
│       ├── src/                 # Source code
│       └── pom.xml             # Maven configuration
├── frontendapp/                 # Flutter Mobile App
│   ├── lib/                    # Application source code
│   │   ├── dtos/              # Data Transfer Objects
│   │   ├── models/            # Data models
│   │   ├── screens/           # UI screens
│   │   └── services/          # Business logic and API services
│   └── assets/                # Static assets (images)
└── webadmin/                   # Angular Admin Panel
    ├── src/                    # Source code
    └── public/                 # Static assets
```

## Technology Stack

### Mobile App (Flutter)

- Flutter SDK 3.7.0+
- Key Dependencies:
  - sqflite: ^2.0.0 (Local database)
  - provider: ^6.0.5 (State management)
  - http: ^0.13.6 (API calls)
  - shared_preferences: ^2.3.2 (Local storage)
  - url_launcher: ^6.1.11
  - cached_network_image: ^3.3.1

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

### Backend Setup

1. Navigate to backend directory:

```bash
cd backend/bookingmovieticketapp
```

2. Build the project:

```bash
./mvnw clean install
```

3. Run the application:

```bash
./mvnw spring-boot:run
```

### Mobile App Setup

1. Navigate to frontend directory:

```bash
cd frontendapp
```

2. Install dependencies:

```bash
flutter pub get
```

3. Run the app:

```bash
flutter run
```

### Admin Panel Setup

1. Navigate to admin panel directory:

```bash
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
npm run start or ng serve     # Start development server
npm run build     # Build production version
npm run test      # Run unit tests
```
