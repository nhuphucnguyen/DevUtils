# DevUtils - Developer Toolbox for macOS

## Project Overview
DevUtils is a macOS application built with SwiftUI that provides essential developer utilities in a minimal, modern interface. The app features menu bar integration and global keyboard shortcuts for quick access.

## Architecture
- **Language**: Swift
- **UI Framework**: SwiftUI
- **Target**: macOS 14.0+
- **App Type**: Menu bar application with main window

## Core Features
1. **Base64 Encoder/Decoder**: Convert text to/from Base64 encoding
2. **JWT Viewer**: Parse and display JWT token contents with header, payload, and signature sections
3. **JSON Formatter**: Format, validate, and prettify JSON with syntax highlighting

## Technical Requirements

### App Structure
- Menu bar icon for quick access
- Global keyboard shortcut (⌘+Shift+D) to toggle main window
- Tabbed interface for different utilities
- Preferences window for settings
- Window state persistence

### Dependencies
- No external dependencies - use native Swift/SwiftUI only
- Utilize Foundation for JSON/Base64 processing
- Use CryptoKit for JWT signature verification (display only)

### UI Guidelines
- Modern minimal design with system colors
- Support both light and dark mode
- Responsive layout for different window sizes
- Clear visual feedback for user actions
- Error handling with user-friendly messages

## Development Commands
- Build: `xcodebuild -scheme DevUtils -configuration Debug build`
- Test: `xcodebuild test -scheme DevUtils -destination 'platform=macOS'`
- Archive: `xcodebuild -scheme DevUtils archive -archivePath DevUtils.xcarchive`

## File Structure
```
DevUtils/
├── DevUtilsApp.swift           # Main app entry point with menu bar setup
├── ContentView.swift           # Main window container with tab view
├── Models/
│   ├── AppState.swift         # Global app state management
│   └── Utilities/
│       ├── Base64Utility.swift
│       ├── JWTUtility.swift
│       └── JSONUtility.swift
├── Views/
│   ├── Base64View.swift       # Base64 encoder/decoder interface
│   ├── JWTView.swift          # JWT token viewer interface
│   ├── JSONView.swift         # JSON formatter interface
│   └── PreferencesView.swift  # App preferences
├── Services/
│   ├── MenuBarManager.swift   # Menu bar icon and menu management
│   ├── HotKeyManager.swift    # Global keyboard shortcuts
│   └── WindowManager.swift    # Window state management
└── Resources/
    └── Assets.xcassets/       # App icons and images
```

## Implementation Priority
1. Menu bar integration and window management
2. Base64 utility (simplest to implement)
3. JSON formatter with syntax highlighting
4. JWT viewer with token parsing
5. Global keyboard shortcuts
6. Preferences and state persistence
7. App icon and polishing

## Testing Strategy
- Unit tests for utility functions (Base64, JSON, JWT parsing)
- UI tests for main user workflows
- Manual testing for menu bar behavior and shortcuts
- Test on different macOS versions and screen sizes