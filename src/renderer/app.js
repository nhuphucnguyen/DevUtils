// DevUtils App - Main JavaScript file

class DevUtilsApp {
    constructor() {
        this.currentTool = 'welcome';
        this.tools = {
            welcome: new WelcomeTool(),
            'base64-encode': new Base64EncodeTool(),
            'base64-decode': new Base64DecodeTool(),
            'jwt-viewer': new JWTViewerTool()
        };
        
        this.init();
    }
    
    init() {
        this.setupEventListeners();
        this.showTool('welcome');
    }
    
    setupEventListeners() {
        // Tool navigation
        document.querySelectorAll('.tool-button').forEach(button => {
            button.addEventListener('click', (e) => {
                const toolName = e.currentTarget.dataset.tool;
                this.showTool(toolName);
            });
        });
    }
    
    showTool(toolName) {
        if (!this.tools[toolName]) return;
        
        // Update active state
        document.querySelectorAll('.tool-button').forEach(btn => {
            btn.classList.remove('active');
        });
        document.querySelector(`[data-tool="${toolName}"]`).classList.add('active');
        
        // Update title bar
        const titleElement = document.getElementById('appTitle');
        const tool = this.tools[toolName];
        
        if (toolName === 'welcome') {
            titleElement.textContent = 'DevUtils';
        } else {
            titleElement.textContent = tool.name;
        }
        
        // Render tool content
        const contentArea = document.getElementById('toolContent');
        contentArea.innerHTML = this.tools[toolName].render();
        
        // Initialize tool
        this.tools[toolName].init();
        
        this.currentTool = toolName;
    }
}

// Base Tool class for extensibility
class BaseTool {
    constructor() {
        this.name = '';
        this.description = '';
    }
    
    render() {
        return '<div>Base tool</div>';
    }
    
    init() {
        // Override in subclasses
    }
    
    setupEventListeners() {
        // Override in subclasses
    }
}

// Welcome Tool
class WelcomeTool extends BaseTool {
    constructor() {
        super();
        this.name = 'Welcome';
        this.description = 'Welcome to DevUtils';
    }
    
    render() {
        return `
            <div class="welcome-content">
                <div class="welcome-icon">
                    <span style="color: white; font-size: 32px;">⚡</span>
                </div>
                <h1 class="welcome-title">Welcome to DevUtils</h1>
                <p class="welcome-subtitle">Your essential developer toolbox for everyday tasks</p>
                
                <div class="feature-grid">
                    <div class="feature-card">
                        <div class="feature-icon">
                            <span style="color: white; font-size: 20px;">🔒</span>
                        </div>
                        <h3 class="feature-title">Base64 Encoder</h3>
                        <p class="feature-description">Encode text and data to Base64 format</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <span style="color: white; font-size: 20px;">🔓</span>
                        </div>
                        <h3 class="feature-title">Base64 Decoder</h3>
                        <p class="feature-description">Decode Base64 strings back to original format</p>
                    </div>
                    
                    <div class="feature-card">
                        <div class="feature-icon">
                            <span style="color: white; font-size: 20px;">🔍</span>
                        </div>
                        <h3 class="feature-title">JWT Viewer</h3>
                        <p class="feature-description">Decode and inspect JWT tokens</p>
                    </div>
                </div>
            </div>
        `;
    }
}

// Base64 Encoder Tool
class Base64EncodeTool extends BaseTool {
    constructor() {
        super();
        this.name = 'Base64 Encoder';
        this.description = 'Encode text to Base64 format';
    }
    
    render() {
        return `
            <div>
                <div class="form-group">
                    <label for="encodeInput" class="form-label">Text to encode:</label>
                    <textarea 
                        id="encodeInput" 
                        class="form-input form-textarea" 
                        placeholder="Enter text to encode..."
                    ></textarea>
                </div>
                
                <div class="button-group">
                    <button id="encodeBtn" class="btn btn-primary">Encode</button>
                    <button id="clearEncodeBtn" class="btn btn-secondary">Clear</button>
                </div>
                
                <div class="result-section">
                    <label for="encodeOutput" class="form-label">Base64 encoded result:</label>
                    <textarea 
                        id="encodeOutput" 
                        class="form-input form-textarea" 
                        readonly
                        placeholder="Encoded result will appear here..."
                    ></textarea>
                    <button id="copyEncodeBtn" class="btn btn-secondary" style="margin-top: 12px;">Copy Result</button>
                </div>
            </div>
        `;
    }
    
    init() {
        this.setupEventListeners();
    }
    
    setupEventListeners() {
        const encodeBtn = document.getElementById('encodeBtn');
        const clearBtn = document.getElementById('clearEncodeBtn');
        const copyBtn = document.getElementById('copyEncodeBtn');
        const input = document.getElementById('encodeInput');
        const output = document.getElementById('encodeOutput');
        
        encodeBtn.addEventListener('click', () => {
            const text = input.value;
            if (text) {
                try {
                    const encoded = btoa(unescape(encodeURIComponent(text)));
                    output.value = encoded;
                } catch (error) {
                    output.value = 'Error: Unable to encode the input text';
                }
            }
        });
        
        clearBtn.addEventListener('click', () => {
            input.value = '';
            output.value = '';
        });
        
        copyBtn.addEventListener('click', () => {
            if (output.value) {
                navigator.clipboard.writeText(output.value).then(() => {
                    copyBtn.textContent = 'Copied!';
                    setTimeout(() => {
                        copyBtn.textContent = 'Copy Result';
                    }, 2000);
                });
            }
        });
        
        // Real-time encoding
        input.addEventListener('input', () => {
            if (input.value) {
                try {
                    const encoded = btoa(unescape(encodeURIComponent(input.value)));
                    output.value = encoded;
                } catch (error) {
                    output.value = 'Error: Unable to encode the input text';
                }
            } else {
                output.value = '';
            }
        });
    }
}

// Base64 Decoder Tool
class Base64DecodeTool extends BaseTool {
    constructor() {
        super();
        this.name = 'Base64 Decoder';
        this.description = 'Decode Base64 strings back to original text';
    }
    
    render() {
        return `
            <div>
                <div class="form-group">
                    <label for="decodeInput" class="form-label">Base64 string to decode:</label>
                    <textarea 
                        id="decodeInput" 
                        class="form-input form-textarea" 
                        placeholder="Enter Base64 string to decode..."
                    ></textarea>
                </div>
                
                <div class="button-group">
                    <button id="decodeBtn" class="btn btn-primary">Decode</button>
                    <button id="clearDecodeBtn" class="btn btn-secondary">Clear</button>
                </div>
                
                <div class="result-section">
                    <label for="decodeOutput" class="form-label">Decoded result:</label>
                    <textarea 
                        id="decodeOutput" 
                        class="form-input form-textarea" 
                        readonly
                        placeholder="Decoded result will appear here..."
                    ></textarea>
                    <button id="copyDecodeBtn" class="btn btn-secondary" style="margin-top: 12px;">Copy Result</button>
                </div>
            </div>
        `;
    }
    
    init() {
        this.setupEventListeners();
    }
    
    setupEventListeners() {
        const decodeBtn = document.getElementById('decodeBtn');
        const clearBtn = document.getElementById('clearDecodeBtn');
        const copyBtn = document.getElementById('copyDecodeBtn');
        const input = document.getElementById('decodeInput');
        const output = document.getElementById('decodeOutput');
        
        decodeBtn.addEventListener('click', () => {
            this.decodeBase64();
        });
        
        clearBtn.addEventListener('click', () => {
            input.value = '';
            output.value = '';
        });
        
        copyBtn.addEventListener('click', () => {
            if (output.value) {
                navigator.clipboard.writeText(output.value).then(() => {
                    copyBtn.textContent = 'Copied!';
                    setTimeout(() => {
                        copyBtn.textContent = 'Copy Result';
                    }, 2000);
                });
            }
        });
        
        // Real-time decoding
        input.addEventListener('input', () => {
            this.decodeBase64();
        });
    }
    
    decodeBase64() {
        const input = document.getElementById('decodeInput');
        const output = document.getElementById('decodeOutput');
        const base64String = input.value.trim();
        
        if (base64String) {
            try {
                const decoded = decodeURIComponent(escape(atob(base64String)));
                output.value = decoded;
            } catch (error) {
                output.value = 'Error: Invalid Base64 string';
            }
        } else {
            output.value = '';
        }
    }
}

// JWT Viewer Tool
class JWTViewerTool extends BaseTool {
    constructor() {
        super();
        this.name = 'JWT Viewer';
        this.description = 'Decode and inspect JWT tokens';
    }
    
    render() {
        return `
            <div>
                <div class="form-group">
                    <label for="jwtInput" class="form-label">JWT Token:</label>
                    <textarea 
                        id="jwtInput" 
                        class="form-input form-textarea" 
                        placeholder="Paste your JWT token here..."
                    ></textarea>
                </div>
                
                <div class="button-group">
                    <button id="parseJwtBtn" class="btn btn-primary">Parse JWT</button>
                    <button id="clearJwtBtn" class="btn btn-secondary">Clear</button>
                </div>
                
                <div class="result-section">
                    <div style="margin-bottom: 20px;">
                        <label for="jwtHeader" class="form-label">Header:</label>
                        <div class="field-container">
                            <textarea 
                                id="jwtHeader" 
                                class="form-input form-textarea" 
                                readonly
                                style="min-height: 100px; padding-right: 50px;"
                                placeholder="JWT header will appear here..."
                            ></textarea>
                            <button class="copy-btn-float" id="copyHeaderBtn" title="Copy Header">📋</button>
                        </div>
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="jwtPayload" class="form-label">Payload:</label>
                        <div class="field-container">
                            <textarea 
                                id="jwtPayload" 
                                class="form-input form-textarea" 
                                readonly
                                style="min-height: 200px; padding-right: 50px;"
                                placeholder="JWT payload will appear here..."
                            ></textarea>
                            <button class="copy-btn-float" id="copyPayloadBtn" title="Copy Payload">📋</button>
                        </div>
                    </div>
                    
                    <div style="margin-bottom: 20px;">
                        <label for="jwtSignature" class="form-label">Signature (Base64):</label>
                        <div class="field-container">
                            <input 
                                id="jwtSignature" 
                                class="form-input" 
                                readonly
                                style="padding-right: 50px;"
                                placeholder="JWT signature will appear here..."
                            />
                            <button class="copy-btn-float" id="copySignatureBtn" title="Copy Signature">📋</button>
                        </div>
                    </div>
                    
                    <div id="jwtInfo" style="margin-bottom: 20px; padding: 16px; background: #f8f9fa; border-radius: 8px; display: none;">
                        <h4 style="margin-bottom: 12px; color: #333;">Token Information:</h4>
                        <div id="jwtDetails"></div>
                    </div>
                </div>
            </div>
        `;
    }
    
    init() {
        this.setupEventListeners();
    }
    
    setupEventListeners() {
        const parseBtn = document.getElementById('parseJwtBtn');
        const clearBtn = document.getElementById('clearJwtBtn');
        const input = document.getElementById('jwtInput');
        
        // Copy button event listeners
        const copyHeaderBtn = document.getElementById('copyHeaderBtn');
        const copyPayloadBtn = document.getElementById('copyPayloadBtn');
        const copySignatureBtn = document.getElementById('copySignatureBtn');
        
        parseBtn.addEventListener('click', () => {
            this.parseJWT();
        });
        
        clearBtn.addEventListener('click', () => {
            input.value = '';
            document.getElementById('jwtHeader').value = '';
            document.getElementById('jwtPayload').value = '';
            document.getElementById('jwtSignature').value = '';
            document.getElementById('jwtInfo').style.display = 'none';
        });
        
        // Copy functionality
        copyHeaderBtn.addEventListener('click', () => {
            this.copyToClipboard('jwtHeader', copyHeaderBtn);
        });
        
        copyPayloadBtn.addEventListener('click', () => {
            this.copyToClipboard('jwtPayload', copyPayloadBtn);
        });
        
        copySignatureBtn.addEventListener('click', () => {
            this.copyToClipboard('jwtSignature', copySignatureBtn);
        });
        
        // Real-time parsing
        input.addEventListener('input', () => {
            this.parseJWT();
        });
    }
    
    copyToClipboard(elementId, buttonElement) {
        const element = document.getElementById(elementId);
        const content = element.value.trim();
        
        if (content) {
            navigator.clipboard.writeText(content).then(() => {
                // Visual feedback
                buttonElement.textContent = '✓';
                buttonElement.classList.add('copied');
                
                setTimeout(() => {
                    buttonElement.textContent = '📋';
                    buttonElement.classList.remove('copied');
                }, 2000);
            }).catch(err => {
                console.error('Failed to copy:', err);
            });
        }
    }
    
    parseJWT() {
        const input = document.getElementById('jwtInput');
        const headerOutput = document.getElementById('jwtHeader');
        const payloadOutput = document.getElementById('jwtPayload');
        const signatureOutput = document.getElementById('jwtSignature');
        const infoDiv = document.getElementById('jwtInfo');
        const detailsDiv = document.getElementById('jwtDetails');
        
        const token = input.value.trim();
        
        if (!token) {
            headerOutput.value = '';
            payloadOutput.value = '';
            signatureOutput.value = '';
            infoDiv.style.display = 'none';
            return;
        }
        
        try {
            const parts = token.split('.');
            
            if (parts.length !== 3) {
                throw new Error('Invalid JWT format');
            }
            
            // Decode header
            const header = JSON.parse(atob(this.base64UrlDecode(parts[0])));
            headerOutput.value = JSON.stringify(header, null, 2);
            
            // Decode payload
            const payload = JSON.parse(atob(this.base64UrlDecode(parts[1])));
            payloadOutput.value = JSON.stringify(payload, null, 2);
            
            // Show signature
            signatureOutput.value = parts[2];
            
            // Show token information
            this.displayTokenInfo(header, payload, detailsDiv);
            infoDiv.style.display = 'block';
            
        } catch (error) {
            headerOutput.value = 'Error: Invalid JWT token';
            payloadOutput.value = 'Error: Invalid JWT token';
            signatureOutput.value = '';
            infoDiv.style.display = 'none';
        }
    }
    
    base64UrlDecode(str) {
        // Convert base64url to base64
        str = str.replace(/-/g, '+').replace(/_/g, '/');
        
        // Add padding if necessary
        while (str.length % 4) {
            str += '=';
        }
        
        return str;
    }
    
    displayTokenInfo(header, payload, container) {
        let html = '';
        
        // Algorithm
        if (header.alg) {
            html += `<p><strong>Algorithm:</strong> ${header.alg}</p>`;
        }
        
        // Type
        if (header.typ) {
            html += `<p><strong>Type:</strong> ${header.typ}</p>`;
        }
        
        // Issuer
        if (payload.iss) {
            html += `<p><strong>Issuer:</strong> ${payload.iss}</p>`;
        }
        
        // Subject
        if (payload.sub) {
            html += `<p><strong>Subject:</strong> ${payload.sub}</p>`;
        }
        
        // Audience
        if (payload.aud) {
            html += `<p><strong>Audience:</strong> ${Array.isArray(payload.aud) ? payload.aud.join(', ') : payload.aud}</p>`;
        }
        
        // Expiration
        if (payload.exp) {
            const expDate = new Date(payload.exp * 1000);
            const isExpired = expDate < new Date();
            html += `<p><strong>Expires:</strong> ${expDate.toLocaleString()} ${isExpired ? '<span style="color: red;">(EXPIRED)</span>' : '<span style="color: green;">(Valid)</span>'}</p>`;
        }
        
        // Issued at
        if (payload.iat) {
            const iatDate = new Date(payload.iat * 1000);
            html += `<p><strong>Issued At:</strong> ${iatDate.toLocaleString()}</p>`;
        }
        
        // Not before
        if (payload.nbf) {
            const nbfDate = new Date(payload.nbf * 1000);
            html += `<p><strong>Not Before:</strong> ${nbfDate.toLocaleString()}</p>`;
        }
        
        container.innerHTML = html;
    }
}

// Initialize the app when DOM is loaded
document.addEventListener('DOMContentLoaded', () => {
    new DevUtilsApp();
});
