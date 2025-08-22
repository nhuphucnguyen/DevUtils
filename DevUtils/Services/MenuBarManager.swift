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
    
    init(appState: AppState) {
        self.appState = appState
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let statusButton = statusItem?.button {
            statusButton.image = NSImage(systemSymbolName: "wrench.and.screwdriver", accessibilityDescription: "DevUtils")
            statusButton.action = #selector(statusBarButtonClicked)
            statusButton.target = self
        }
        
        setupMenu()
    }
    
    private func setupMenu() {
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "Show DevUtils", action: #selector(showApp), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Preferences...", action: #selector(showPreferences), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit DevUtils", action: #selector(quitApp), keyEquivalent: "q"))
        
        menu.items.forEach { $0.target = self }
        statusItem?.menu = menu
    }
    
    @objc private func statusBarButtonClicked() {
        appState.toggleMainWindow()
    }
    
    @objc private func showApp() {
        appState.showMainWindow()
    }
    
    @objc private func showPreferences() {
        // TODO: Implement preferences window
        print("Show preferences")
    }
    
    @objc private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}