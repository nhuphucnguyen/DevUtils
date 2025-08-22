//
//  DevUtilsApp.swift
//  DevUtils
//
//  Created by Nguyen Nhu Phuc on 21/8/25.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    var appState: AppState!
    var menuBarManager: MenuBarManager!
    var windowManager: WindowManager!
    var hotKeyManager: HotKeyManager!
    var tabKeyboardHandler: TabKeyboardHandler!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        appState = AppState()
        windowManager = WindowManager(appState: appState)
        menuBarManager = MenuBarManager(appState: appState, windowManager: windowManager)
        hotKeyManager = HotKeyManager(windowManager: windowManager)
        tabKeyboardHandler = TabKeyboardHandler()
        
        setupApp()
    }
    
    private func setupApp() {
        windowManager.setContentView {
            ContentView()
                .environmentObject(appState)
        }
    }
}

@main
struct DevUtilsApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}
