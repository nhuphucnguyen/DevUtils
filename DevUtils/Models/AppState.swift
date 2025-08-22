//
//  AppState.swift
//  DevUtils
//
//  Created by Claude on 22/8/25.
//

import SwiftUI
import Combine

class AppState: ObservableObject {
    @Published var isMainWindowVisible = false
    @Published var selectedTab = 0
    @Published var windowFrame = CGRect(x: 100, y: 100, width: 600, height: 500)
    
    private let userDefaults = UserDefaults.standard
    
    init() {
        loadWindowState()
    }
    
    func showMainWindow() {
        isMainWindowVisible = true
    }
    
    func hideMainWindow() {
        isMainWindowVisible = false
    }
    
    func toggleMainWindow() {
        isMainWindowVisible.toggle()
    }
    
    func saveWindowState() {
        userDefaults.set(windowFrame.origin.x, forKey: "windowX")
        userDefaults.set(windowFrame.origin.y, forKey: "windowY")
        userDefaults.set(windowFrame.size.width, forKey: "windowWidth")
        userDefaults.set(windowFrame.size.height, forKey: "windowHeight")
        userDefaults.set(selectedTab, forKey: "selectedTab")
    }
    
    private func loadWindowState() {
        let x = userDefaults.double(forKey: "windowX")
        let y = userDefaults.double(forKey: "windowY")
        let width = userDefaults.double(forKey: "windowWidth")
        let height = userDefaults.double(forKey: "windowHeight")
        
        if width > 0 && height > 0 {
            windowFrame = CGRect(x: x, y: y, width: width, height: height)
        }
        
        selectedTab = userDefaults.integer(forKey: "selectedTab")
    }
}