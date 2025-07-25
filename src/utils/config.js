// Application configuration and settings

export const appConfig = {
    // App metadata
    name: 'DevUtils',
    version: '1.0.0',
    description: 'A modern developer toolbox',
    
    // Window settings
    window: {
        defaultWidth: 1200,
        defaultHeight: 800,
        minWidth: 800,
        minHeight: 600,
        center: true,
        resizable: true,
        titleBarStyle: 'hiddenInset'
    },
    
    // UI settings
    ui: {
        theme: 'default',
        sidebarWidth: 280,
        animationDuration: 200,
        showWelcome: true,
        autoSave: true
    },
    
    // Tool categories
    toolCategories: {
        'encoding': {
            name: 'Encoding & Decoding',
            icon: '🔐',
            description: 'Tools for encoding and decoding data'
        },
        'jwt': {
            name: 'JSON Web Tokens',
            icon: '🔍',
            description: 'JWT related utilities'
        },
        'text': {
            name: 'Text Processing',
            icon: '📝',
            description: 'Text manipulation and formatting tools'
        },
        'data': {
            name: 'Data Processing',
            icon: '🗃️',
            description: 'Data transformation and validation tools'
        },
        'network': {
            name: 'Network Tools',
            icon: '🌐',
            description: 'Network and HTTP utilities'
        }
    },
    
    // Default tools configuration
    defaultTools: [
        {
            id: 'welcome',
            name: 'Welcome',
            category: 'general',
            enabled: true,
            order: 0
        },
        {
            id: 'base64-encode',
            name: 'Base64 Encoder',
            category: 'encoding',
            enabled: true,
            order: 1
        },
        {
            id: 'base64-decode',
            name: 'Base64 Decoder',
            category: 'encoding',
            enabled: true,
            order: 2
        },
        {
            id: 'jwt-viewer',
            name: 'JWT Viewer',
            category: 'jwt',
            enabled: true,
            order: 3
        }
    ],
    
    // Keyboard shortcuts
    shortcuts: {
        'toggleDevTools': 'CmdOrCtrl+Shift+I',
        'reload': 'CmdOrCtrl+R',
        'quit': 'CmdOrCtrl+Q',
        'copy': 'CmdOrCtrl+C',
        'paste': 'CmdOrCtrl+V',
        'selectAll': 'CmdOrCtrl+A'
    },
    
    // Feature flags
    features: {
        autoCopy: true,
        realTimeProcessing: true,
        historyTracking: false,
        themes: false,
        plugins: true
    },
    
    // Security settings
    security: {
        contextIsolation: true,
        nodeIntegration: false,
        enableRemoteModule: false,
        allowRunningInsecureContent: false
    }
};

// Settings manager for persistent configuration
export class SettingsManager {
    constructor() {
        this.settings = { ...appConfig };
        this.storageKey = 'devutils-settings';
        this.load();
    }

    /**
     * Load settings from localStorage
     */
    load() {
        try {
            const stored = localStorage.getItem(this.storageKey);
            if (stored) {
                const parsed = JSON.parse(stored);
                this.settings = { ...this.settings, ...parsed };
            }
        } catch (error) {
            console.warn('Failed to load settings:', error);
        }
    }

    /**
     * Save settings to localStorage
     */
    save() {
        try {
            localStorage.setItem(this.storageKey, JSON.stringify(this.settings));
        } catch (error) {
            console.error('Failed to save settings:', error);
        }
    }

    /**
     * Get a setting value
     * @param {string} path - Setting path (e.g., 'ui.theme')
     * @param {any} defaultValue - Default value if not found
     * @returns {any} - Setting value
     */
    get(path, defaultValue = null) {
        const keys = path.split('.');
        let value = this.settings;
        
        for (const key of keys) {
            if (value && value.hasOwnProperty(key)) {
                value = value[key];
            } else {
                return defaultValue;
            }
        }
        
        return value;
    }

    /**
     * Set a setting value
     * @param {string} path - Setting path (e.g., 'ui.theme')
     * @param {any} value - New value
     */
    set(path, value) {
        const keys = path.split('.');
        const lastKey = keys.pop();
        let current = this.settings;
        
        for (const key of keys) {
            if (!current[key] || typeof current[key] !== 'object') {
                current[key] = {};
            }
            current = current[key];
        }
        
        current[lastKey] = value;
        this.save();
    }

    /**
     * Reset settings to defaults
     */
    reset() {
        this.settings = { ...appConfig };
        this.save();
    }

    /**
     * Get all settings
     * @returns {Object} - All settings
     */
    getAll() {
        return { ...this.settings };
    }

    /**
     * Update multiple settings at once
     * @param {Object} updates - Settings to update
     */
    update(updates) {
        this.settings = { ...this.settings, ...updates };
        this.save();
    }
}

// Create global settings instance
let settingsInstance = null;

export function getSettings() {
    if (!settingsInstance) {
        settingsInstance = new SettingsManager();
    }
    return settingsInstance;
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { appConfig, SettingsManager, getSettings };
}
