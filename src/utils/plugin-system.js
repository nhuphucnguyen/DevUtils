// Plugin system for DevUtils - makes it easy to add new tools

class PluginManager {
    constructor() {
        this.plugins = new Map();
        this.hooks = new Map();
    }

    /**
     * Register a new plugin/tool
     * @param {string} name - Plugin name
     * @param {BaseTool} plugin - Plugin instance
     */
    register(name, plugin) {
        if (!(plugin instanceof BaseTool)) {
            throw new Error('Plugin must extend BaseTool class');
        }
        
        this.plugins.set(name, plugin);
        this.triggerHook('plugin-registered', { name, plugin });
    }

    /**
     * Get a registered plugin
     * @param {string} name - Plugin name
     * @returns {BaseTool|null} - Plugin instance or null
     */
    get(name) {
        return this.plugins.get(name) || null;
    }

    /**
     * Get all registered plugins
     * @returns {Map} - All plugins
     */
    getAll() {
        return this.plugins;
    }

    /**
     * Unregister a plugin
     * @param {string} name - Plugin name
     */
    unregister(name) {
        const plugin = this.plugins.get(name);
        if (plugin) {
            this.plugins.delete(name);
            this.triggerHook('plugin-unregistered', { name, plugin });
        }
    }

    /**
     * Register a hook callback
     * @param {string} hookName - Hook name
     * @param {Function} callback - Callback function
     */
    addHook(hookName, callback) {
        if (!this.hooks.has(hookName)) {
            this.hooks.set(hookName, []);
        }
        this.hooks.get(hookName).push(callback);
    }

    /**
     * Trigger a hook
     * @param {string} hookName - Hook name
     * @param {any} data - Data to pass to callbacks
     */
    triggerHook(hookName, data) {
        if (this.hooks.has(hookName)) {
            this.hooks.get(hookName).forEach(callback => {
                try {
                    callback(data);
                } catch (error) {
                    console.error(`Error in hook ${hookName}:`, error);
                }
            });
        }
    }

    /**
     * Get plugin metadata
     * @param {string} name - Plugin name
     * @returns {Object} - Plugin metadata
     */
    getMetadata(name) {
        const plugin = this.plugins.get(name);
        if (!plugin) return null;

        return {
            name: plugin.name,
            description: plugin.description,
            version: plugin.version || '1.0.0',
            category: plugin.category || 'utility',
            tags: plugin.tags || [],
            author: plugin.author || 'Unknown'
        };
    }

    /**
     * Search plugins by criteria
     * @param {Object} criteria - Search criteria
     * @returns {Array} - Matching plugins
     */
    search(criteria) {
        const results = [];
        
        for (const [name, plugin] of this.plugins) {
            const metadata = this.getMetadata(name);
            let matches = true;

            if (criteria.category && metadata.category !== criteria.category) {
                matches = false;
            }

            if (criteria.tags && !criteria.tags.every(tag => metadata.tags.includes(tag))) {
                matches = false;
            }

            if (criteria.name && !metadata.name.toLowerCase().includes(criteria.name.toLowerCase())) {
                matches = false;
            }

            if (matches) {
                results.push({ name, plugin, metadata });
            }
        }

        return results;
    }
}

// Enhanced BaseTool class with plugin capabilities
class BaseTool {
    constructor() {
        this.name = '';
        this.description = '';
        this.version = '1.0.0';
        this.category = 'utility';
        this.tags = [];
        this.author = 'DevUtils';
        this.enabled = true;
    }

    /**
     * Render the tool's HTML
     * @returns {string} - HTML string
     */
    render() {
        return '<div>Base tool</div>';
    }

    /**
     * Initialize the tool
     */
    init() {
        if (this.enabled) {
            this.setupEventListeners();
            this.onInit();
        }
    }

    /**
     * Setup event listeners (override in subclasses)
     */
    setupEventListeners() {
        // Override in subclasses
    }

    /**
     * Called after initialization (override in subclasses)
     */
    onInit() {
        // Override in subclasses
    }

    /**
     * Clean up when tool is hidden/destroyed
     */
    destroy() {
        this.onDestroy();
    }

    /**
     * Called before destruction (override in subclasses)
     */
    onDestroy() {
        // Override in subclasses
    }

    /**
     * Enable the tool
     */
    enable() {
        this.enabled = true;
    }

    /**
     * Disable the tool
     */
    disable() {
        this.enabled = false;
    }

    /**
     * Get tool configuration schema
     * @returns {Object} - Configuration schema
     */
    getConfigSchema() {
        return {
            // Override in subclasses to provide configuration options
        };
    }

    /**
     * Get current configuration
     * @returns {Object} - Current configuration
     */
    getConfig() {
        return {
            enabled: this.enabled
        };
    }

    /**
     * Update configuration
     * @param {Object} config - New configuration
     */
    updateConfig(config) {
        if (config.hasOwnProperty('enabled')) {
            this.enabled = config.enabled;
        }
    }
}

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = { PluginManager, BaseTool };
} else if (typeof window !== 'undefined') {
    window.PluginManager = PluginManager;
    window.BaseTool = BaseTool;
}
