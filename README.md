# DevUtils - Developer Toolbox

A modern, elegant desktop application built with Electron that provides essential developer utilities in one convenient place.

## ✨ Features

- **Base64 Encoder** - Encode text and data to Base64 format with real-time preview
- **Base64 Decoder** - Decode Base64 strings back to original text with validation
- **JWT Viewer** - Decode and inspect JWT tokens with detailed information display
- **Modern UI/UX** - Beautiful glassmorphism design with smooth interactions
- **Extensible Architecture** - Easy to add new tools and utilities

## 🚀 Getting Started

### Prerequisites

- Node.js (v14 or higher)
- npm or yarn

### Installation

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd DevUtils
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Build the application:
   ```bash
   npm run build
   ```

4. Start the application:
   ```bash
   npm start
   ```

### Development

For development with hot reload:

```bash
npm run dev
```

This will build the renderer process and start the Electron app.

## 🏗️ Project Structure

```
DevUtils/
├── src/
│   ├── main/           # Main Electron process
│   │   ├── main.js     # Main application entry point
│   │   └── preload.js  # Preload script for security
│   ├── renderer/       # Renderer process (UI)
│   │   ├── index.html  # Main HTML file
│   │   └── app.js      # Main application logic
│   └── utils/          # Shared utilities
├── .vscode/            # VS Code configuration
├── .github/            # GitHub and Copilot configuration
├── dist/               # Built files (generated)
└── webpack.config.js   # Webpack build configuration
```

## 🔧 Adding New Tools

The application is built with extensibility in mind. To add a new tool:

1. **Create a new tool class** that extends `BaseTool`:

```javascript
class MyNewTool extends BaseTool {
    constructor() {
        super();
        this.name = 'My New Tool';
        this.description = 'Description of what it does';
    }
    
    render() {
        return `<!-- HTML template for your tool -->`;
    }
    
    init() {
        this.setupEventListeners();
    }
    
    setupEventListeners() {
        // Add event listeners for your tool
    }
}
```

2. **Register the tool** in the `DevUtilsApp` constructor:

```javascript
this.tools = {
    // ... existing tools
    'my-new-tool': new MyNewTool()
};
```

3. **Add navigation** in the sidebar (index.html):

```html
<li class="tool-item">
    <button class="tool-button" data-tool="my-new-tool">
        <span class="icon">🔧</span>
        My New Tool
    </button>
</li>
```

## 🎨 Design Principles

- **Glassmorphism UI** - Semi-transparent elements with backdrop blur
- **Consistent Spacing** - 8px grid system for consistent layouts
- **Responsive Design** - Adapts to different window sizes
- **Accessible Colors** - High contrast for readability
- **Smooth Animations** - Subtle transitions for better UX

## 📦 Building for Distribution

To build the application for distribution:

```bash
npm run build:prod
npm run dist
```

This will create platform-specific installers in the `dist/` directory.

## 🛠️ Available Scripts

- `npm start` - Start the application
- `npm run dev` - Development mode with building
- `npm run build` - Build for development
- `npm run build:prod` - Build for production
- `npm run dist` - Create distribution packages

## 🔒 Security

The application follows Electron security best practices:

- Context isolation enabled
- Node integration disabled in renderer
- Preload script for secure IPC communication
- Content Security Policy implemented

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes following the existing code style
4. Test your changes
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Built with [Electron](https://electronjs.org/)
- UI inspired by modern design principles
- Icons and styling follow platform conventions
