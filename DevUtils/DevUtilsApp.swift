//
//  DevUtilsApp.swift
//  DevUtils
//
//  Created by Nguyen Nhu Phuc on 21/8/25.
//

import SwiftUI
import AppKit

@main
struct DevUtilsApp: App {
    @StateObject private var appState = AppState()
    private let menuBarManager: MenuBarManager
    private let windowManager: WindowManager
    private let hotKeyManager: HotKeyManager
    
    init() {
        let appState = AppState()
        let windowManager = WindowManager(appState: appState)
        let menuBarManager = MenuBarManager(appState: appState)
        let hotKeyManager = HotKeyManager(windowManager: windowManager)
        
        self._appState = StateObject(wrappedValue: appState)
        self.windowManager = windowManager
        self.menuBarManager = menuBarManager
        self.hotKeyManager = hotKeyManager
    }
    
    var body: some Scene {
        Settings {
            EmptyView()
                .onAppear {
                    setupApp()
                }
        }
        .onChange(of: appState.isMainWindowVisible) { isVisible in
            if isVisible {
                windowManager.showWindow()
            } else {
                windowManager.hideWindow()
            }
        }
    }
    
    private func setupApp() {
        windowManager.setContentView {
            ContentView()
                .environmentObject(appState)
        }
    }
}
