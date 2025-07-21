# lightspeed-ios-demo

## Mobile Test Implementation
This project implements the Lightspeed iOS Mobile Test requirements. This task was done to demonstrate skills relevant to the **Software Developer I - iOS** position.

## Skills Demonstrated

### Refreshed Skills
- Core Data: Implemented data persistence with entity relationships
- Clean MVVM Architecture: Structured the app with clear separation of concerns, see below for more info
- API Integration: Implemented networking with proper error handling and JSON parsing
- SwiftUI: Built modern, declarative user interfaces with reusable components and state management
- XCTest: Created comprehensive unit tests for business logic and data layers

### First Time Implementation
#### Interview-Mentioned Skills I wanted to try
- Swift Testing: Explored Swift Testing alongside traditional XCTest (for UI)
- Coding Keys: Implemented custom JSON mapping using CodingKeys for API responses
- Swift Package Manager (SPM): Managed dependencies using SPM to implement UI from different packages

#### New Technical Challenges
- UI Unit Testing: Developed tests for SwiftUI components and user interactions
- Core Data Relationships: Implemented an entity relationships for the first time

## Architecture Overview

The app follows a clean MVVM architecture with a layered approach:

### Architecture Layers
- **View**: SwiftUI components that observe ViewModels and handle user interactions
- **ViewModel**: Presentation logic layer that processes user actions and prepares data for Views
- **Repository**: Data access abstraction layer that coordinates between Service and local storage
- **Service**: Network layer handling API calls to the Picsum Photos API
- **Core Data**: Local persistence layer for offline data storage and relationships

### Data Flow
1. **View** triggers user actions → **ViewModel**
2. **ViewModel** requests data → **Repository** 
3. **Repository** fetches from **Service** (API) or Core Data
4. Data flows back through the layers with proper error handling at each level

## Project Decisions & Trade-offs

Throughout this project, I made several key architectural and technical decisions:

- MVVM over MVC: Chose MVVM architecture for better testability and separation of concerns, though it added some complexity
- Repository Pattern: Implemented repository layer to abstract data sources. felt perfect for a small project like this that handles both local storage and apis.
- SwiftUI vs. UIKit: Opted for SwiftUI to practice modern iOS development

Thank you so much for the opportunity to work on this project. I had a great time and learned a lot in the process!

Please message me if you have any concerns or questions:
alexyoshida264@gmail.com
