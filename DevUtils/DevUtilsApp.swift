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
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        appState = AppState()
        windowManager = WindowManager(appState: appState)
        menuBarManager = MenuBarManager(appState: appState)
        hotKeyManager = HotKeyManager(windowManager: windowManager)
        
        setupApp()
    }
    
    private func setupApp() {
        print("Setting up app...")
        
        windowManager.setContentView {
            ContentView()
                .environmentObject(appState)
        }
        
        print("Content view configured, showing window...")
        windowManager.showWindow()
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
