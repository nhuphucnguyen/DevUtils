// Utility functions for DevUtils

export const utils = {
    /**
     * Copy text to clipboard
     * @param {string} text - Text to copy
     * @returns {Promise<boolean>} - Success status
     */
    async copyToClipboard(text) {
        try {
            await navigator.clipboard.writeText(text);
            return true;
        } catch (error) {
            console.error('Failed to copy to clipboard:', error);
            return false;
        }
    },

    /**
     * Validate Base64 string
     * @param {string} str - String to validate
     * @returns {boolean} - Is valid Base64
     */
    isValidBase64(str) {
        try {
            return btoa(atob(str)) === str;
        } catch (err) {
            return false;
        }
    },

    /**
     * Validate JWT format
     * @param {string} token - JWT token to validate
     * @returns {boolean} - Is valid JWT format
     */
    isValidJWT(token) {
        const parts = token.split('.');
        return parts.length === 3;
    },

    /**
     * Format JSON string with proper indentation
     * @param {string} jsonString - JSON string to format
     * @param {number} indent - Number of spaces for indentation
     * @returns {string} - Formatted JSON string
     */
    formatJSON(jsonString, indent = 2) {
        try {
            const parsed = JSON.parse(jsonString);
            return JSON.stringify(parsed, null, indent);
        } catch (error) {
            throw new Error('Invalid JSON string');
        }
    },

    /**
     * Debounce function calls
     * @param {Function} func - Function to debounce
     * @param {number} wait - Wait time in milliseconds
     * @returns {Function} - Debounced function
     */
    debounce(func, wait) {
        let timeout;
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout);
                func(...args);
            };
            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    /**
     * Show notification to user
     * @param {string} message - Notification message
     * @param {string} type - Notification type (success, error, info)
     */
    showNotification(message, type = 'info') {
        // Create notification element
        const notification = document.createElement('div');
        notification.className = `notification notification-${type}`;
        notification.textContent = message;
        
        // Style the notification
        Object.assign(notification.style, {
            position: 'fixed',
            top: '20px',
            right: '20px',
            padding: '12px 20px',
            borderRadius: '8px',
            color: 'white',
            fontWeight: '500',
            zIndex: '10000',
            transition: 'all 0.3s ease',
            transform: 'translateX(100%)',
            backgroundColor: type === 'success' ? '#10b981' : type === 'error' ? '#ef4444' : '#3b82f6'
        });
        
        document.body.appendChild(notification);
        
        // Animate in
        setTimeout(() => {
            notification.style.transform = 'translateX(0)';
        }, 10);
        
        // Remove after delay
        setTimeout(() => {
            notification.style.transform = 'translateX(100%)';
            setTimeout(() => {
                document.body.removeChild(notification);
            }, 300);
        }, 3000);
    }
};

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
    module.exports = utils;
}
