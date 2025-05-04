# smart-inventory-system-ios  
An iOS application for managing a smart inventory system, enabling users to authenticate, organize groups, manage devices, shelves, and items efficiently.

## Table of Contents  
- [Features](#features)  
- [Stack](#stack)  
- [Installation](#installation)  
  - [Prerequisites](#prerequisites)  
  - [Setup Instructions](#setup-instructions)  
- [Configuration](#configuration)  

## Features  
- User registration and login with JWT-based authentication.  
- User profile management with role assignments.  
- Group creation, management, and user membership handling.  
- Device management including device creation and activation.  
- Shelves management with the ability to control lighting and add items.  
- Item management featuring item addition, details, status updates, and history tracking.  
- Pagination and search support for listing users, items, devices, and shelves.  
- Ukrainian localization support alongside English.  

## Stack  
- Swift, SwiftUI for iOS app development.  
- JWTDecode for JWT token management and user authentication.  
- RESTful API communication for backend integration via HttpClient.  
- Async/Await concurrency for network request handling.  
- Local data modeling with Codable structs and classes.  

## Installation  

### Prerequisites  
- macOS system with Xcode installed (version compatible with SwiftUI and iOS app development).  
- An Apple Developer account for running on physical devices (optional for simulator use).  

### Setup Instructions  
Clone the repository:  
```bash  
git clone https://github.com/Shchoholiev/smart-inventory-system-ios.git  
cd smart-inventory-system-ios/SmartInventorySystem  
```  

Open the Xcode project:  
```bash  
open SmartInventorySystem.xcodeproj  
```  

Build and run the project in the Xcode simulator or on a connected iOS device.

## Configuration  
- The base URL for API calls is set in `HttpClient.swift` pointing to `https://smart-inventory-system.azurewebsites.net`. Update this if necessary.  
- Authentication tokens (access & refresh) are securely stored via `JwtTokensService` and managed through the app lifecycle.  
- Group ID persistence uses `UserDefaults` to maintain user group context.  
- Localization strings are maintained in `Localizable.xcstrings`, currently supporting English and Ukrainian.  

No additional environment variables are required. Make sure the backend API is accessible and configured correctly for token-based authentication.
