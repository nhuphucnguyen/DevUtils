//
//  MenuBarManager.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import AppKit
import SwiftUI

class MenuBarManager {
    private var statusItem: NSStatusItem?
    private let appState: AppState
    private weak var windowManager: WindowManager?
    
    init(appState: AppState, windowManager: WindowManager) {
        self.appState = appState
        self.windowManager = windowManager
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let statusButton = statusItem?.button {
            // Use a more appropriate developer tools icon
            if let image = NSImage(systemSymbolName: "terminal", accessibilityDescription: "DevUtils") {
                image.isTemplate = true // Makes it adapt to light/dark mode
                statusButton.image = image
            } else {
                // Fallback to text if symbol not available
                statusButton.title = "DevUtils"
            }
            statusButton.action = #selector(statusBarButtonClicked)
            statusButton.target = self
        }
        
        setupMenu()
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        let showItem = NSMenuItem(title: "Show DevUtils", action: #selector(showApp), keyEquivalent: "")
        showItem.keyEquivalentModifierMask = [.command, .shift]
        showItem.keyEquivalent = "d"
        menu.addItem(showItem)
        
        menu.addItem(NSMenuItem.separator())
        
        let shortcutsItem = NSMenuItem(title: "Keyboard Shortcuts", action: nil, keyEquivalent: "")
        let shortcutsSubmenu = NSMenu()
        shortcutsSubmenu.addItem(NSMenuItem(title: "⌘+Shift+D - Toggle Window", action: nil, keyEquivalent: ""))
        shortcutsSubmenu.addItem(NSMenuItem(title: "⌘+1 - Base64 Tab", action: nil, keyEquivalent: ""))
        shortcutsSubmenu.addItem(NSMenuItem(title: "⌘+2 - JWT Tab", action: nil, keyEquivalent: ""))
        shortcutsSubmenu.addItem(NSMenuItem(title: "⌘+3 - JSON Tab", action: nil, keyEquivalent: ""))
        shortcutsItem.submenu = shortcutsSubmenu
        menu.addItem(shortcutsItem)
        
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit DevUtils", action: #selector(quitApp), keyEquivalent: "q"))
        
        menu.items.forEach { $0.target = self }
        statusItem?.menu = menu
    }
    
    @objc private func statusBarButtonClicked() {
        windowManager?.toggleWindow()
    }
    
    @objc private func showApp() {
        windowManager?.showWindow()
    }
    
    @objc private func showPreferences() {
        // TODO: Implement preferences window
        print("Show preferences")
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}