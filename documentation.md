# Birdle App - Documentation

## Implemented Features

### Spash Screen
**Access:** Automatically displays when app launches
**Implementation:** Animated splash screen using SwiftUI with fade-in and scale animations, auto-dismisses after 2.5 seconds to show main menu view.

### Main Menu Screen
**Access:** Appears after splash screen, accessible via "Back to Menu" or "Done" buttons
**Implementation** Central navigation section using SwiftUI NavigationView with menu buttons that present different views using sheets and fullScreenCover modifiers.

### Daily Puzzle Game
**Access:** Tap "Start Puzzle" button on main menu.
**Implementation:** MVC architectire with PuzzleController managing game state, fetches daily puzzle from provided API, displays progressive images (6 levels), validates guesses against correct answer, and tracks attempts (max 5).

### Practice Puzzle Game
**Access:** Tap "Practice" button on main menu.
**Implementation:** Similar architecture to the daily puzzle game feature. Each practice puzzle has a unique puzzleId and is loaded from a hardcoded array in NetworkService. The controller manages practice-mode state, including puzzle loading, tracking attempts (max 5), handling guesses, timingn and puzzle completion. Unlike daily mode, Practice Puzzles can be played repeatedly with no limits.

### Bird Name Autocomplete
**Access:** Automatically starts when puzzle begins, displayed during gameplay.
**Implementation:** Computed property 'filterSuggestions' in PuzzleControlller that filters bird names array based on user input and displays matching suggestions.

### Timer and Time Tracking
**Access:** Automatically starts when puzzle begins, displayed during gameplay.
**Implementation:** Uses Timer, scheduleTImer in PuzzleController to track elapsed time from start date, formatted as MM::SS display, stops when puzzle completes.

### Puzzle History
**Access:**Tap "History" button on main menu.
**Implementation:** Core Data backed view using @FetchRequest to display all completed puzzles wih bird images, attempts, completion dates, time spent, sorted by most recent first.

### Upload Bird Photos
**Access:** Tap "Upload Bird" button on main menu.
**Implementation:** Form-based view with UIImagePickerController for camera/photo library access, validates required fields, converts image to JPEG, creates multipart/form-data request, and uploads to API endpoint.

### Share Result
**Access:** Tap "Share Results" button after completing puzzle.
**Implementation:** UIActivityViewController wrapper (ShareSheet) that shares formatted text containing puzzle name, date, attempts, bird name, and time.

### Help Screen
**Access:** Tap "Help" button on main menu.
**Implementation:** Static SwiftUI ScrollView with step-by-step instructions, tips section, and visual components using custom InstructionSection and TipRow views.

### About Screen
**Access:** Tap "About" button on main menu.
**Implementation:** Static information view displaying app features, developer details, disclaimer about educational use, and copyright information.

### Network Service
**Access:** Used internally throughout app.
**Implementation:** Singleton class with URLSession-based methods for: fetching daily puzzle, downloading bird images, fetching bird name list, and uploading photos.

### Core Data Persistence
**Access:** Used internally for history storage.
**Implementation:** NSPersistentContainer with "Birdle" model containing PuzzleHistory entity, includes save/fetch methods and date-based queries for duplicate checking.

### Previous Guesses Display
**Access:** Visible during puzzle gameplay after incorrect guesses.
**Implementation:** Array of strings in PuzzleController stores incorrect guesses, displayed with strikethrough text and red X icons.

### Wikipedia Links
**Access:** "Learn More" buttons in results and history views.
**Implementation:** SwiftUI Link views that open bird Wikipedia pages in Safari using bird_link URL from API response.

### Form Validation
**Access:** Upload form and puzzle input fields.
**Implementation:** Computed property `isFormValid` checks all required fields are non-empty, disables submit buttons when validation fails.

### Error Handling
**Access:** Displays automatically when network or data errors occur.
**Implementation:** ErrorView component shows error messages with retry functionality, NetworkError enum defines specific error types with localized descriptions.

### Alert Dialogs
**Access:** Incorrect guess alerts, upload success/failure messages.
**Implementation:** SwiftUI .alert() modifiers with @State boolean triggers, display contextual messages based on user actions.

## Technical Architecture
- **Pattern:** MVC (Model-View-Controller)
- **Data Persistence:** Core Data with NSPersistentContainer
- **UI Framework:** SwiftUI with UIKit bridges (UIImagePickerController, UIActivityViewController)
- **Navigation**: NaviagtionView with sheet/fullScreenCover views.

## API Endpoints Used

- "GET https://easterbilby.net/birdle/api.php" - Daily puzzle
- "GET https://easterbilby.net/birdle/api.php?action=list" - Bird names
- "GET https://easterbilby.net/birdle/api.php?action=download&id={id}" - Specific puzzle
- "POST https://easterbilby.net/birdle/api.php?action=upload" - Upload bird photo
- "GET https://easterbilby.net/birdle/{code}{index}.jpg" - Bird images (0-5 progressive reveal)

## Required My-Birdle-Info.plist Permissions

- NSPhotoLibraryUsageDescription - Access photo library
- NSPhotoLibraryAddUsageDescription - Save photos
- NSCameraUsageDescription - Access camera
- NSAppTransportSecurity - Allow HTTP connections to easterbilby.net


