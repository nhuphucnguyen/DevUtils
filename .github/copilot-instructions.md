<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# DevUtils - Electron Desktop App

This is an Electron desktop application that serves as a developer toolbox with various utilities.

## Architecture Guidelines

- **Main Process**: Located in `src/main/` - handles app lifecycle, window management, and system interactions
- **Renderer Process**: Located in `src/renderer/` - handles UI and user interactions
- **Utilities**: Located in `src/utils/` - shared utility functions
- **Tool-based Architecture**: Each tool extends the `BaseTool` class for consistency and extensibility

## Code Style Guidelines

- Use modern JavaScript (ES6+) features
- Follow the existing modular tool pattern when adding new utilities
- Maintain the elegant, modern UI design with consistent styling
- Use descriptive variable and function names
- Add proper error handling for all user inputs

## Adding New Tools

To add a new tool:
1. Create a new class that extends `BaseTool`
2. Implement the required methods: `render()`, `init()`, and `setupEventListeners()`
3. Add the tool to the `tools` object in the `DevUtilsApp` constructor
4. Add a navigation button in the sidebar HTML

## UI/UX Principles

- Maintain the gradient background and glassmorphism design
- Use consistent spacing and typography
- Provide real-time feedback for user actions
- Include copy-to-clipboard functionality for outputs
- Show clear error messages for invalid inputs
